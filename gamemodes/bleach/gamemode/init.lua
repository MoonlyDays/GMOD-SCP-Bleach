include("shared.lua")

AddCSLuaFile("client/class_menu.lua")
AddCSLuaFile("client/fonts.lua")
AddCSLuaFile("client/head_bob.lua")
AddCSLuaFile("client/hud.lua")
AddCSLuaFile("client/language.lua")
AddCSLuaFile("client/mtf_menu.lua")
AddCSLuaFile("client/scoreboard.lua")
AddCSLuaFile("client/sounds.lua")
AddCSLuaFile("client/target_id.lua")


-- Variables
gamestarted = false
preparing = false
postround = false
nextgateaopen = 0
roundcount = 0

function GM:PlayerSpray(sprayer)
    return InPD(sprayer) or sprayer:GetGTeam() == TEAM_SPECTATOR
end

function WakeEntity(ent)
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetVelocity(Vector(0, 0, 25))
    end
end

function PlayerNTFSound(sound, ply)
    if (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) and ply:Alive() then
        if ply.lastsound == nil then
            ply.lastsound = 0
        end
        if ply.lastsound > CurTime() then
            ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
            return
        end

        --ply:EmitSound( "Beep.ogg", 500, 100, 1 )
        ply.lastsound = CurTime() + 3
        --timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
        ply:EmitSound(sound, 450, 100, 1)
        --end)
    end
end

function OnUseEyedrops(ply)
    if ply.usedeyedrops == true then
        ply:PrintMessage(HUD_PRINTTALK, "Don't use them that fast!")
        return
    end

    ply.usedeyedrops = true
    ply:StripWeapon("item_eyedrops")
    ply:PrintMessage(HUD_PRINTTALK, "Used eyedrops, you will not be blinking for 10 seconds")
    timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
        ply.usedeyedrops = false
        ply:PrintMessage(HUD_PRINTTALK, "You will be blinking now")
    end)
end

timer.Create("BlinkTimer", GetConVar("br_time_blinkdelay"):GetInt(), 0, function()
    local time = GetConVar("br_time_blink"):GetFloat()
    if time >= 5 then
        return
    end
    for k, v in pairs(player.GetAll()) do
        if v:Alive() == true and v.blinkedby173 == false and v.usedeyedrops == false then
            net.Start("PlayerBlink")
            net.WriteFloat(time)
            net.Send(v)
            v.isblinking = true
            v.nextBlinkCheck = CurTime() + (time / 2)
        end
    end

    timer.Create("UnBlinkTimer", time + 0.2, 1, function()
        for k, v in pairs(player.GetAll()) do
            if v.blinkedby173 == false then
                v.isblinking = false
            end
        end
    end)
end)

function RequestOpenGateA(ply)
    if preparing or postround then
        return
    end
    if ply:CLevelGlobal() < 4 then
        return
    end
    if not (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) then
        return
    end
    if nextgateaopen > CurTime() then
        ply:PrintMessage(HUD_PRINTTALK, "You cannot open Gate A now, you must wait " .. math.Round(nextgateaopen - CurTime()) .. " seconds")
        return
    end

    local gatea = nil
    local rdc = nil
    for id, ent in pairs(ents.FindByClass("func_rot_button")) do
        for k, v in pairs(MAP_BUTTONS) do
            if v["pos"] == ent:GetPos() then
                if v["name"] == "Remote Door Control" then
                    rdc = ent
                    rdc:Use(ply, ply, USE_ON, 1)
                end
            end
        end
    end

    for id, ent in pairs(ents.FindByClass("func_button")) do
        for k, v in pairs(BUTTONS) do
            if v["pos"] == ent:GetPos() then
                if v["name"] == "Gate A" then
                    gatea = ent
                end
            end
        end
    end

    if IsValid(gatea) then
        nextgateaopen = CurTime() + 20
        timer.Simple(2, function()
            if IsValid(gatea) then
                gatea:Use(ply, ply, USE_ON, 1)
            end
        end)
    end
end

local lastpocketd = 0
function GetPocketPos()
    if lastpocketd > #POS_POCKETD then
        lastpocketd = 0
    end
    lastpocketd = lastpocketd + 1
    return POS_POCKETD[lastpocketd]
end

function SpawnAllItems()
    if #SPAWN_FIREPROOF_ARMOR > 3 then
        local num_of_fpa = math.Round(#SPAWN_FIREPROOF_ARMOR * 0.5)
        local fpa = table.Copy(SPAWN_FIREPROOF_ARMOR)
        for i = 1, num_of_fpa do
            table.RemoveByValue(fpa, table.Random(fpa))
        end

        for k, v in pairs(fpa) do
            local vest = ents.Create("armor_fireproof")
            if IsValid(vest) then
                vest:Spawn()
                vest:SetPos(v)
                WakeEntity(vest)
            end
        end
    end

    if #SPAWN_ARMORS > 3 then
        local num_of_arm = math.Round(#SPAWN_ARMORS * 0.3)
        local fpa = table.Copy(SPAWN_ARMORS)
        for i = 1, num_of_arm do
            table.RemoveByValue(fpa, table.Random(fpa))
        end

        for k, v in pairs(fpa) do
            local vest = ents.Create("armor_sec_guard")
            if IsValid(vest) then
                vest:Spawn()
                vest:SetPos(v)
                WakeEntity(vest)
            end
        end
    end

    for k, v in pairs(SPAWN_PISTOLS) do
        if math.random(1, 3) ~= 2 then
            --print("SPAWNED A PISTOL")
            local pist = "weapon_mtf_usp"
            if math.random(1, 4) == 3 then
                pist = "weapon_mtf_deagle"
            end
            local wep = ents.Create(pist)
            if IsValid(wep) then
                wep:Spawn()
                wep:SetPos(v)
                wep.SavedAmmo = wep.Primary.ClipSize
                WakeEntity(wep)
            end
        end
    end

    for k, v in pairs(SPAWN_GPISTOLS) do
        local pist = "weapon_mtf_usp"
        if math.random(1, 4) == 3 then
            pist = "weapon_mtf_deagle"
        end
        local wep = ents.Create(pist)
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_SMGS) do
        local wep = ents.Create(table.Random({ "weapon_mtf_p90", "weapon_mtf_tmp", "weapon_mtf_ump45" }))
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_SHOTGUNS) do
        local wep = ents.Create(table.Random({ "weapon_chaos_m3s90", "weapon_chaos_xm1014" }))
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_SNIPER_RIFLES) do
        local wep = ents.Create("weapon_chaos_sg550")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_RIFLES) do
        local wep = ents.Create(table.Random({ "weapon_chaos_ak47", "weapon_chaos_famas" }))
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_AMMO_RIFLE) do
        local wep = ents.Create("item_rifleammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
        end
    end

    for k, v in pairs(SPAWN_AMMO_SMG) do
        local wep = ents.Create("item_smgammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
        end
    end

    for k, v in pairs(SPAWN_AMMO_SHOTGUN) do
        local wep = ents.Create("item_shotgunammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
        end
    end

    for k, v in pairs(SPAWN_AMMO_PISTOL) do
        local wep = ents.Create("item_pistolammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v)
        end
    end

    for k, v in pairs(SPAWN_KEYCARD2) do
        local item = ents.Create("keycard_level2")
        if IsValid(item) then
            item:Spawn()
            item:SetPos(table.Random(v))
        end
    end

    for k, v in pairs(SPAWN_KEYCARD3) do
        local item = ents.Create("keycard_level3")
        if IsValid(item) then
            item:Spawn()
            item:SetPos(table.Random(v))
        end
    end

    for k, v in pairs(SPAWN_KEYCARD4) do
        local item = ents.Create("keycard_level4")
        if IsValid(item) then
            item:Spawn()
            item:SetPos(table.Random(v))
        end
    end

    for k, v in pairs(SPAWN_GMEDKITS) do
        local item = ents.Create("item_medkit")
        if IsValid(item) then
            item:Spawn()
            item:SetPos(v)
        end
    end

    local resps_items = table.Copy(SPAWN_MISC_ITEMS)
    local resps_melee = table.Copy(SPAWN_MELEE_WEPS)
    local resps_medkits = table.Copy(SPAWN_MEDKITS)
    local item = ents.Create("item_medkit")
    if IsValid(item) then
        local spawn4 = table.Random(resps_medkits)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_medkits, spawn4)
    end

    local item = ents.Create("item_medkit")
    if IsValid(item) then
        local spawn4 = table.Random(resps_medkits)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_medkits, spawn4)
    end

    local item = ents.Create("item_radio")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("item_eyedrops")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("item_nvg")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("item_nvg")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("item_gasmask")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("item_gasmask")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("weapon_crowbar")
    if IsValid(item) then
        local spawn4 = table.Random(resps_melee)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_melee, spawn4)
    end

    local item = ents.Create("weapon_crowbar")
    if IsValid(item) then
        local spawn4 = table.Random(resps_melee)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_melee, spawn4)
    end
end

function SpawnNTFS()
    --print("roundtype.allowntfspawn: " .. tostring(roundtype.allowntfspawn))
    if roundtype.allowntfspawn == false then
        return
    end
    local usablesupport = {}
    local activeplayers = {}
    for k, v in pairs(gteams.GetPlayers(TEAM_SPECTATOR)) do
        if v.ActivePlayer == true then
            table.ForceInsert(activeplayers, v)
        end
    end

    for k, v in pairs(ALL_CLASSES["support"]["roles"]) do
        table.ForceInsert(usablesupport, {
            role = v,
            list = {}
        })
    end

    for _, rl in pairs(usablesupport) do
        for k, v in pairs(activeplayers) do
            if rl.role.level <= v:GetLevel() then
                local can = true
                if rl.role.customcheck ~= nil then
                    if rl.role.customcheck(v) == false then
                        can = false
                    end
                end
                if can == true then
                    table.ForceInsert(rl.list, v)
                end
            end
        end
    end

    local usechaos = math.random(1, 5)
    if usechaos == 1 then
        usechaos = true
    else
        usechaos = false
    end

    if usechaos == true then
        local chaosnum = 0
        for _, rl in pairs(usablesupport) do
            if rl.role.team == TEAM_CHAOS then
                chaosnum = chaosnum + #rl.list
            end
        end

        --print("cinum: " .. chaosnum)
        if chaosnum > 1 then
            local cinum = 0
            for _, rl in pairs(usablesupport) do
                if rl.role.team == TEAM_CHAOS then
                    for k, v in pairs(rl.list) do
                        if cinum > 4 then
                            return
                        end
                        cinum = cinum + 1
                        v:SetupNormal()
                        v:ApplyRoleStats(rl.role)
                        v:SetPos(SPAWN_OUTSIDE[cinum])
                    end
                end
            end
            return
        end
    end

    local used = 0
    for _, rl in pairs(usablesupport) do
        if rl.role.team == TEAM_GUARD then
            for k, v in pairs(rl.list) do
                if used > 4 then
                    return
                end
                used = used + 1
                v:SetupNormal()
                v:ApplyRoleStats(rl.role)
                v:SetPos(SPAWN_OUTSIDE[used])
            end
        end
    end

    if used > 0 then
        PrintMessage(HUD_PRINTTALK, "MTF Units NTF has entered the facility.")
        BroadcastLua('surface.PlaySound("EneteredFacility.ogg")')
    end
end

function ForceUse(ent, on, int)
    for k, v in pairs(player.GetAll()) do
        if v:Alive() then
            ent:Use(v, v, on, int)
        end
    end
end

function OpenGateA()
    for k, v in pairs(ents.FindByClass("func_rot_button")) do
        if v:GetPos() == POS_GATEABUTTON then
            ForceUse(v, 1, 1)
        end
    end
end

buttonstatus = 0
lasttime914b = 0
function Use914B(activator, ent)
    if CurTime() < lasttime914b then
        return
    end
    lasttime914b = CurTime() + 1.3
    ForceUse(ent, 1, 1)
end

lasttime914 = 0
function Use914(ent)
    local b914status = Check914Button()
    print("b914status: " .. tostring(b914status))
    if b914status == 0 then
        return
    end
    if CurTime() < lasttime914 then
        return
    end
    buttonstatus = b914status
    lasttime914 = CurTime() + 20
    ForceUse(ent, 0, 1)
    local pos = ENTER_914
    local pos2 = EXIT_914
    timer.Create("914Use", 4, 1, function()
        for k, v in pairs(ents.FindInSphere(pos, 80)) do
            if v.betterone ~= nil or v.GetBetterOne ~= nil then
                local useb
                if v.betterone then
                    useb = v.betterone
                end
                if v.GetBetterOne then
                    useb = v:GetBetterOne()
                end
                local betteritem = ents.Create(useb)
                if IsValid(betteritem) then
                    betteritem:SetPos(pos2)
                    betteritem:Spawn()
                    WakeEntity(betteritem)
                    v:Remove()
                end
            end
        end
    end)
end

function OpenSCPDoors()
    print("OPENING DOORS")
    for k, v in pairs(ents.FindByClass("func_button")) do
        if v.BreachButton and v.BreachButton.openRoundStart then
            print("OPENING DOORS", v)
            ForceUse(v, 1, 1)
        end
    end
end

function GetAlivePlayers()
    local plys = {}
    for _, v in pairs(player.GetAll()) do
        if v:GTeam() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_SPECTATOR then
            if v:Alive() then
                table.ForceInsert(plys, v)
            end
        end
    end
    return plys
end

function GM:GetFallDamage(ply, speed)
    --if SERVER then
    --	ply:PrintMessage(HUD_PRINTCENTER, "falldamage: "..tostring(speed / 5)  )
    --end
    return speed / 5
end

function PlayerCount()
    return #player.GetAll()
end

function CheckPLAYER_SETUP()
    local si = 1
    for i = 3, #PLAYER_SETUP do
        local v = PLAYER_SETUP[si]
        local num = v[1] + v[2] + v[3] + v[4]
        if i ~= num then
            print(tostring(si) .. " is not good: " .. tostring(num) .. "/" .. tostring(i))
        else
            print(tostring(si) .. " is good: " .. tostring(num) .. "/" .. tostring(i))
        end

        si = si + 1
    end
end

function GM:OnEntityCreated(ent)
    ent:SetShouldPlayPickupSound(false)
end

function GetPlayer(nick)
    for k, v in pairs(player.GetAll()) do
        if v:Nick() == nick then
            return v
        end
    end
    return nil
end

function CreateRagdollPL(victim, attacker, dmgtype)
    if victim:GetGTeam() == TEAM_SPECTATOR then
        return
    end
    if not IsValid(victim) then
        return
    end
    local rag = ents.Create("prop_ragdoll")
    if not IsValid(rag) then
        return nil
    end
    rag:SetPos(victim:GetPos())
    rag:SetModel(victim:GetModel())
    rag:SetAngles(victim:GetAngles())
    rag:SetColor(victim:GetColor())
    rag:Spawn()
    rag:Activate()
    rag.Info = {}
    rag.Info.CorpseID = rag:GetCreationID()
    rag:SetNWInt("CorpseID", rag.Info.CorpseID)
    rag.Info.Victim = victim:Nick()
    rag.Info.DamageType = dmgtype
    rag.Info.Time = CurTime()
    local group = COLLISION_GROUP_DEBRIS_TRIGGER
    rag:SetCollisionGroup(group)
    timer.Simple(1, function()
        if IsValid(rag) then
            rag:CollisionRulesChanged()
        end
    end)
    local num = rag:GetPhysicsObjectCount() - 1
    local v = victim:GetVelocity() * 0.35
    for i = 0, num do
        local bone = rag:GetPhysicsObjectNum(i)
        if IsValid(bone) then
            local bp, ba = victim:GetBonePosition(rag:TranslatePhysBoneToBone(i))
            if bp and ba then
                bone:SetPos(bp)
                bone:SetAngles(ba)
            end

            bone:SetVelocity(v * 1.4)
        end
    end
end

function DARK()
    engine.LightStyle(0, "a")
    BroadcastLua('render.RedownloadAllLightmaps(true)')
    BroadcastLua('RunConsoleCommand("mat_specular", 0)')
end