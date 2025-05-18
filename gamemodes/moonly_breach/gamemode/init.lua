-- Initialization file
AddCSLuaFile("fonts.lua")
AddCSLuaFile("class_default.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_mtfmenu.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("other/ambient.lua")
AddCSLuaFile("other/scp914leverfix_site19old.lua")
AddCSLuaFile("other/scp914leverfix_site19v43.lua")
AddCSLuaFile("other/nameversiontext.lua")
AddCSLuaFile("other/cl_weaponmovement.lua")
AddCSLuaFile("other/cl_thirdperson.lua")
AddCSLuaFile("other/cl_chatsound.lua")
AddCSLuaFile("other/cl_viewbobbing.lua")
AddCSLuaFile("other/f4menu.lua")
AddCSLuaFile("other/cl_hud_mic_vc.lua")
AddCSLuaFile("other/SCPDeadAnnouncements.lua")
AddCSLuaFile("ulx_forceclass.lua")
mapFile = "mapconfigs/" .. game.GetMap() .. ".lua"
AddCSLuaFile(mapFile)
ALL_LANGUAGES = {}
clang = nil
local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA")
for k, v in pairs(files) do
    local path = "languages/" .. v
    if string.Right(v, 3) == "lua" then
        AddCSLuaFile(path)
        include(path)
        print("Language found: " .. path)
    end
end

AddCSLuaFile("rounds.lua")
AddCSLuaFile("cl_sounds.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_init.lua")
include("server.lua")
include("rounds.lua")
include("class_default.lua")
include("shared.lua")
include(mapFile)
include("sh_player.lua")
include("sv_player.lua")
include("player.lua")
include("sv_round.lua")
include("other/ambient.lua")
include("other/scp914leverfix_site19old.lua")
include("other/scp914leverfix_site19v43.lua")
include("other/nameversiontext.lua")
include("other/f4menu.lua")
include("other/cl_hud_mic_vc.lua")
include("other/SCPDeadAnnouncements.lua")
include("ulx_forceclass.lua")

resource.AddFile("sound/breach/radio/chatter1.ogg")
resource.AddFile("sound/breach/radio/chatter2.ogg")
resource.AddFile("sound/breach/radio/chatter3.ogg")
resource.AddFile("sound/breach/radio/chatter4.ogg")
resource.AddFile("sound/breach/radio/franklin1.ogg")
resource.AddFile("sound/breach/radio/franklin2.ogg")
resource.AddFile("sound/breach/radio/franklin3.ogg")
resource.AddFile("sound/breach/radio/franklin4.ogg")
resource.AddFile("sound/breach/radio/radioalarm.ogg")
resource.AddFile("sound/breach/radio/radioalarm2.ogg")
resource.AddFile("sound/breach/radio/scpradio0.ogg")
resource.AddFile("sound/breach/radio/scpradio1.ogg")
resource.AddFile("sound/breach/radio/scpradio2.ogg")
resource.AddFile("sound/breach/radio/scpradio3.ogg")
resource.AddFile("sound/breach/radio/scpradio4.ogg")
resource.AddFile("sound/breach/radio/scpradio5.ogg")
resource.AddFile("sound/breach/radio/scpradio6.ogg")
resource.AddFile("sound/breach/radio/scpradio7.ogg")
resource.AddFile("sound/breach/radio/scpradio8.ogg")
resource.AddFile("sound/breach/radio/ohgod.ogg")
-- Variables
gamestarted = false
preparing = false
postround = false
roundcount = 0
MAP_BUTTONS = table.Copy(BUTTONS)
function GM:PlayerSpray(sprayer)
    return not sprayer:Team() == TEAM_SPECTATOR
end

function GetActivePlayers()
    local tab = {}
    for k, v in pairs(player.GetAll()) do
        if v.ActivePlayer == nil then
            v.ActivePlayer = true
        end
        if v.ActivePlayer == true then
            table.ForceInsert(tab, v)
        end
    end
    return tab
end

function GetNotActivePlayers()
    local tab = {}
    for k, v in pairs(player.GetAll()) do
        if v.ActivePlayer == nil then
            v.ActivePlayer = true
        end
        if v.ActivePlayer == false then
            table.ForceInsert(tab, v)
        end
    end
    return tab
end

function GM:ShutDown()
    for k, v in pairs(player.GetAll()) do
        v:SaveKarma()
    end
end

function WakeEntity(ent)
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetVelocity(Vector(0, 0, 25))
    end
end

function PlayerNTFSound(sound, ply)
    if (ply:Team() == TEAM_GUARD or ply:Team() == TEAM_CHAOS) and ply:Alive() then
        if ply.lastsound == nil then
            ply.lastsound = 0
        end
        if ply.lastsound > CurTime() then
            ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
            return
        end

        ply.lastsound = CurTime() + 3
        ply:EmitSound(sound, 450, 100, 1)
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
        if v.canblink and v.blinkedby173 == false and v.usedeyedrops == false then
            net.Start("PlayerBlink")
            net.WriteFloat(time)
            net.Send(v)
            v.isblinking = true
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

nextgateaopen = 0
function RequestOpenGateA(ply)
    if preparing or postround then
        ply:PrintMessage(HUD_PRINTTALK, "You cannot open Gate A at this time")
        return
    end
    if ply:CLevelGlobal() < 4 then
        ply:PrintMessage(HUD_PRINTTALK, "Access denied")
        return
    end

    if nextgateaopen > CurTime() then
        ply:PrintMessage(HUD_PRINTTALK, "You cannot open Gate A now, you must wait " .. math.Round(nextgateaopen - CurTime()) .. " seconds")
        return
    end

    local gatea
    local rdc
    for _, ent in pairs(ents.FindByClass("func_rot_button")) do
        if IsButtonNamed(ent, "Remote Door Control") then
            rdc = ent
            rdc:Use(ply, ply, USE_ON, 1)
            break
        end
    end

    if IsValid(gatea) then
        ply:PrintMessage(HUD_PRINTTALK, "Your request to open Gate A has been accepted. Processing...")
        nextgateaopen = CurTime() + 60
        timer.Simple(2, function()
            if IsValid(gatea) then
                gatea:Use(ply, ply, USE_ON, 1)
            end
        end)
    end
end

local lastpocketd = 0
function GetPocketPos()
    if lastpocketd > #PD_ENTRANCES then
        lastpocketd = 0
    end
    lastpocketd = lastpocketd + 1
    return PD_ENTRANCES[lastpocketd]
end

function Kanade()
    for k, v in pairs(player.GetAll()) do
        if v:SteamID64() == "76561198156389563" then
            return v
        end
    end
end

function SpawnAllItems()
    for k, v in pairs(SPAWN_FIREPROOFARMOR) do
        local vest = ents.Create("armor_fireproof")
        if IsValid(vest) then
            vest:Spawn()
            vest:SetPos(v + Vector(0, 0, -5))
            WakeEntity(vest)
        end
    end

    for k, v in pairs(SPAWN_ARMORS) do
        local vest = ents.Create("armor_mtfguard")
        if IsValid(vest) then
            vest:Spawn()
            vest:SetPos(v + Vector(0, 0, -15))
            WakeEntity(vest)
        end
    end

    for k, v in pairs(SPAWN_PISTOLS) do
        local wep = ents.Create(table.Random({ "weapon_mtf_usp", "weapon_mtf_deagle" }))
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v + Vector(0, 0, -25))
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_SMGS) do
        local wep = ents.Create(table.Random({ "weapon_mtf_p90", "weapon_mtf_tmp", "weapon_mtf_ump45" }))
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v + Vector(0, 0, -25))
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_RIFLES) do
        local wep = ents.Create(table.Random({ "weapon_chaos_ak47", "weapon_chaos_famas" }))
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v + Vector(0, 0, -25))
            wep.SavedAmmo = wep.Primary.ClipSize
            WakeEntity(wep)
        end
    end

    for k, v in pairs(SPAWN_AMMO_RIFLE) do
        local wep = ents.Create("item_rifleammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v + Vector(0, 0, -25))
        end
    end

    for k, v in pairs(SPAWN_AMMO_SMG) do
        local wep = ents.Create("item_smgammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v + Vector(0, 0, -25))
        end
    end

    for k, v in pairs(SPAWN_AMMO_PISTOL) do
        local wep = ents.Create("item_pistolammo")
        if IsValid(wep) then
            wep:Spawn()
            wep:SetPos(v + Vector(0, 0, -25))
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

    local resps_items = table.Copy(SPAWN_MISCITEMS)
    local resps_melee = table.Copy(SPAWN_MELEEWEPS)
    local resps_medkits = table.Copy(SPAWN_MEDKITS)
    local resps_scp420j = table.Copy(SPAWN_SCP420J)
    local resps_scp500 = table.Copy(SPAWN_SCP500)
    local resps_scp714 = table.Copy(SPAWN_SCP714)
    local resps_scpcatj = table.Copy(SPAWN_SCPCATJ)
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

    local item = ents.Create("item_scp_420j")
    if IsValid(item) then
        local spawn4 = table.Random(resps_scp420j)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_scp420j, spawn4)
    end

    local item = ents.Create("item_scp_714")
    if IsValid(item) then
        local spawn1 = table.Random(resps_scp714)
        item:Spawn()
        item:SetPos(spawn1)
        table.RemoveByValue(resps_scp714, spawn1)
    end

    local item = ents.Create("weapon_scp_cat_j")
    if IsValid(item) then
        local spawn1 = table.Random(resps_scpcatj)
        item:Spawn()
        item:SetPos(spawn1)
        table.RemoveByValue(resps_scpcatj, spawn1)
    end

    local item = ents.Create("item_scp_500")
    if IsValid(item) then
        local spawn4 = table.Random(resps_scp500)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_scp500, spawn4)
    end

    local item = ents.Create("item_snav_300")
    if IsValid(item) then
        local spawn4 = table.Random(resps_items)
        item:Spawn()
        item:SetPos(spawn4)
        table.RemoveByValue(resps_items, spawn4)
    end

    local item = ents.Create("item_snav_ultimate")
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

function GetSCPLeavers()
    local tab = {}
    for k, v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
        if v.Leaver == "scp" then
            table.ForceInsert(tab, v)
        end
    end

    print("giving scp leavers with count: " .. #tab)
    return tab
end

function GetClassDLeavers()
    local tab = {}
    for k, v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
        if v.Leaver == "classd" then
            table.ForceInsert(tab, v)
        end
    end

    print("giving class d leavers with count: " .. #tab)
    return tab
end

function GetSciLeavers()
    local tab = {}
    for k, v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
        if v.Leaver == "sci" then
            table.ForceInsert(tab, v)
        end
    end

    print("giving sci leavers with count: " .. #tab)
    return tab
end

spawnedntfs = 0
function SpawnNTFS()
    --if roundtype.allowntfspawn == false then return end
    if spawnedntfs > 100 then
        return
    end
    local allspecs = {}
    for k, v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
        if v.ActivePlayer == true then
            table.ForceInsert(allspecs, v)
        end
    end

    local num = math.Clamp(#allspecs, 0, 5)
    local spawnci = false
    spawnedntfs = spawnedntfs + num
    if math.random(1, 5) == 1 then
        spawnci = true
    end
    for i = 1, num do
        local pl = table.Random(allspecs)
        if spawnci then
            pl:SetChaosInsurgency(3)
            pl:SetPos(SPAWN_OUTSIDE[i])
        else
            pl:SetNTF()
            pl:SetPos(SPAWN_OUTSIDE[i])
        end

        table.RemoveByValue(allspecs, pl)
    end

    if num > 0 then
        PrintMessage(HUD_PRINTTALK, "[SYSTEM ALERT] Mobile Task Force has entered the facility.")
        BroadcastLua('surface.PlaySound("breach/intercom/mtf_entered"..math.random(1,3)..".ogg", 200)')
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
    print("Use914B")
    if CurTime() < lasttime914b then
        return
    end
    lasttime914b = CurTime() + 1.3
    ForceUse(ent, 1, 1)
    if buttonstatus == 0 then
        buttonstatus = 1
        activator:PrintMessage(HUD_PRINTTALK, "Changed to coarse")
    elseif buttonstatus == 1 then
        buttonstatus = 2
        activator:PrintMessage(HUD_PRINTTALK, "Changed to 1:1")
    elseif buttonstatus == 2 then
        buttonstatus = 3
        activator:PrintMessage(HUD_PRINTTALK, "Changed to fine")
    elseif buttonstatus == 3 then
        buttonstatus = 4
        activator:PrintMessage(HUD_PRINTTALK, "Changed to very fine")
    elseif buttonstatus == 4 then
        buttonstatus = 0
        activator:PrintMessage(HUD_PRINTTALK, "Changed to rough")
    end

    net.Start("Update914B")
    net.WriteInt(buttonstatus, 6)
    net.Broadcast()
end

lasttime914 = 0
function Use914(ent)
    print("Use914")
    if CurTime() < lasttime914 then
        return
    end
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

function GetButton(ent)
    for _, v in pairs(MAP_BUTTONS) do
        if (v["pos"] == ent:GetPos()) then
            return v
        end
    end
end

function FindNamedButton(name, className)
    for _, ent in pairs(ents.FindByClass(className)) do
        if IsButtonNamed(ent, name) then
            return ent
        end
    end
end

function IsButtonNamed(ent, name)
    local button = GetButton(ent);
    if button and button.name == name then
        return true
    end
    return false
end

function OpenSCPDoors()
    for _, ent in pairs(ents.FindByClass("func_button")) do
        local button = GetButton(ent);
        if button and button.roundStartOpen then
            ForceUse(ent, 1, 1)
        end
    end
end

function GetAlivePlayers()
    local plys = {}
    for k, v in pairs(player.GetAll()) do
        if v:Team() ~= TEAM_SPECTATOR then
            if v:Alive() then
                table.ForceInsert(plys, v)
            end
        end
    end
    return plys
end

function GM:GetFallDamage(ply, speed)
    return speed / 6
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

function CheckThings()
    print("//// class d leavers: " .. #GetClassDLeavers() .. " with classdcount: " .. classdcount)
    print("//// scp leavers: " .. #GetSCPLeavers() .. " with scpcount: " .. scpcount)
    --GetClassDLeavers()
    --GetSCPLeavers()
end

function GM:OnEntityCreated(ent)
    ent:SetShouldPlayPickupSound(false)
end

function DARK()
    engine.LightStyle(0, "a")
    BroadcastLua('render.RedownloadAllLightmaps(true)')
    BroadcastLua('RunConsoleCommand("mat_specular", 0)')
end