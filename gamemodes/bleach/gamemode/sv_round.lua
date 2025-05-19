nextSpecialRound = nil
roundCommotionSounds = nil

function PlayCommotionSound()
    if istable(roundCommotionSounds) then
        local rnd_sound = table.Random(roundCommotionSounds)
        if isstring(rnd_sound) == false then
            print("Couldnt find a commotion sound, removing the timer.")
            timer.Remove("PlayCommotionSounds")
            return
        end

        BroadcastLua('surface.PlaySound("' .. rnd_sound .. '")')
        table.RemoveByValue(roundCommotionSounds, rnd_sound)
        timer.Create("PlayCommotionSounds", math.random(8, 14), 1, PlayCommotionSound)
    end
end

function HandleNTFSpawns()
    if timer.Exists("RoundTime") == false then
        print("roundtime does not exist")
        return
    end

    local nextNTFs = math.random(GetConVar("br_time_ntfenter_delay_min"):GetInt(), GetConVar("br_time_ntfenter_delay_max"):GetInt())
    if nextNTFs == nil or timer.TimeLeft("RoundTime") == nil then
        return
    end
    if (timer.TimeLeft("RoundTime") - nextNTFs) > 10 then
        timer.Create("NTFEnterTime", nextNTFs, 1, function()
            SpawnNTFS()
            HandleNTFSpawns()
        end)

        print("Next NTF spawn in " .. tostring(nextNTFs))
    end
end


function RoundRestart()
    timer.Destroy("PreparingTime")
    timer.Destroy("RoundTime")
    timer.Destroy("PostTime")
    timer.Destroy("GateOpen")
    timer.Destroy("PlayerInfo")
    timer.Destroy("NTFEnterTime")
    timer.Destroy("PlayCommotionSounds")
    if timer.Exists("CheckEscape") == false then
        timer.Create("CheckEscape", 1, 0, CheckEscape)
    end
    game.CleanUpMap()
    roundCommotionSounds = table.Copy(COMMOTION_SOUNDS)
    nextgateaopen = 0
    spawnedntfs = 0
    roundstats = {
        descaped = 0,
        rescaped = 0,
        sescaped = 0,
        dcaptured = 0,
        rescorted = 0,
        deaths = 0,
        teleported = 0,
        snapped = 0,
        zombies = 0,
    }

    print("round: mapcleaned")
    MAP_BUTTONS = table.Copy(BUTTONS)
    CacheButtons()
    for k, v in pairs(player.GetAll()) do
        player_manager.SetPlayerClass(v, "class_breach")
        player_manager.RunClass(v, "SetupDataTables")
        v:Freeze(false)
        v.MaxUses = nil
        v.blinkedby173 = false
        v.usedeyedrops = false
        v.isescaping = false
    end

    print("round: playersconfigured")
    preparing = true
    postround = false
    nextSpecialRound = nil
    local foundr = GetConVar("br_specialround_forcenext"):GetString()
    if foundr ~= nil then
        if foundr ~= "none" then
            print("Found a round from command: " .. foundr)
            nextSpecialRound = foundr
            RunConsoleCommand("br_specialround_forcenext", "none")
        else
            print("Couldn't find any round from command, setting to normal (" .. foundr .. ")")
            nextSpecialRound = nil
        end
    end

    if nextSpecialRound ~= nil then
        if ROUNDS[nextSpecialRound] ~= nil then
            print("Found round: " .. ROUNDS[nextSpecialRound].name)
            roundtype = ROUNDS[nextSpecialRound]
        else
            print("Couldn't find any round with name " .. nextSpecialRound .. ", setting to normal")
            roundtype = normalround
        end
    else
        if math.random(1, 100) <= math.Clamp(GetConVar("br_specialround_percentage"):GetInt(), 1, 100) then
            local roundstouse = {}
            for k, v in pairs(ROUNDS) do
                if v.minplayers <= #GetActivePlayers() then
                    table.ForceInsert(roundstouse, v)
                end
            end

            roundtype = table.Random(roundstouse)
        else
            roundtype = normalround
        end
    end

    if roundtype == nil then
        roundtype = normalround
    end
    roundtype.playersetup()
    for _, v in pairs(player.GetAll()) do
        if (v:GetMoveType() ~= MOVETYPE_WALK and v:GetNClass() ~= ROLES.ROLE_SCP173) and (v:GTeam() ~= TEAM_SPEC or v:GetNoDraw() == false) then
            print("SPEC FIXED: " .. v:Nick() .. "!")
            v:SetMoveType(MOVETYPE_WALK)
            v:SetNoDraw(false)
        end
    end

    if isfunction(MAPCONFIG_POST_ROUNDSTART) then
        MAPCONFIG_POST_ROUNDSTART()
    end
    net.Start("UpdateRoundType")
    net.WriteString(roundtype.name)
    net.Broadcast()
    print("round: roundtype working")
    gamestarted = true
    BroadcastLua('gamestarted = true')
    print("round: gamestarted")
    SpawnAllItems()
    net.Start("PrepStart")
    net.WriteInt(GetPrepTime(), 8)
    net.Broadcast()
    timer.Create("PlayCommotionSounds", 78, 1, function()
        print("starting to play commotion sounds")
        PlayCommotionSound()
    end)

    print("round: started successfully")
    timer.Create("PreparingTime", GetPrepTime(), 1, function()
        print("round: prepinit")
        for k, v in pairs(player.GetAll()) do
            v:Freeze(false)
        end

        preparing = false
        postround = false
        if roundtype ~= nil then
            if isfunction(roundtype.onroundstart) == true then
                roundtype.onroundstart()
            end
        end
        if roundtype.mtfandscpdelay == true then
            OpenSCPDoors()
        end
        net.Start("RoundStart")
        net.WriteInt(GetRoundTime(), 12)
        net.Broadcast()
        print("round: prepgood")
        timer.Create("RoundTime", GetRoundTime(), 1, function()
            postround = false
            postround = true
            net.Start("SendRoundInfo")
            net.WriteTable(roundstats)
            net.Broadcast()
            net.Start("PostStart")
            net.WriteInt(GetPostTime(), 6)
            net.WriteInt(1, 4)
            net.Broadcast()
            timer.Create("PostTime", GetPostTime(), 1, function()
                RoundRestart()
            end)
        end)

        HandleNTFSpawns()
    end)
end

canescortds = true
canescortrs = true
function CheckEscape()
    for k_exit, v_exit in pairs(PD_EXITS) do
        for k_ent, v_ent in pairs(ents.FindInSphere(v_exit + Vector(0, 0, 25), 200)) do
            if v_ent:IsPlayer() == true then
                if v_ent:GTeam() ~= TEAM_SPEC and v_ent:Alive() == true then
                    local rand = math.random(1, 100)
                    if rand < 6 then
                        local attacker = v_106
                        local inflictor = v_106
                        local scps_found = {}
                        for k_106, v_106 in pairs(player.GetAll()) do
                            if v_106:GetNClass() == ROLES.ROLE_SCP106 and v_106:Alive() == true and v_ent.last106 == v_106 then
                                table.ForceInsert(scps_found, v_106)
                            end
                        end

                        if #scps_found == 1 then
                            attacker = scps_found[1]
                            inflictor = scps_found[1]:GetActiveWeapon()
                            print("found scp 106")
                            scps_found[1]:AddExp(45, true)
                        end

                        v_ent:TakeDamage(v_ent:Health() + 10, attacker, inflictor)
                    elseif rand < 37 then
                        v_ent:SetPos(table.Random(PD_GOOD_EXIT))
                        v_ent:EmitSound("PocketDimension/Exit.ogg", 75, 100, 0.7)
                    else
                        v_ent:SetPos(table.Random(PD_BAD_EXIT))
                        if math.random(1, 3) == 1 then
                            v_ent:SendLua('surface.PlaySound("Laugh.ogg")')
                        end
                    end
                end
            end
        end
    end

    for k, v in pairs(ents.FindInSphere(POS_GATEA, 250)) do
        if v:IsPlayer() == true then
            if v:Alive() == false then
                return
            end
            if v.isescaping == true then
                return
            end
            if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_STAFF or v:GTeam() == TEAM_SCP then
                if v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_STAFF then
                    roundstats.rescaped = roundstats.rescaped + 1
                    local rtime = timer.TimeLeft("RoundTime")
                    local exptoget = 300
                    if rtime ~= nil then
                        exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
                        exptoget = exptoget * 1.8
                        exptoget = math.Round(math.Clamp(exptoget, 300, 10000))
                    end

                    net.Start("OnEscaped")
                    net.WriteInt(1, 4)
                    net.Send(v)
                    v:AddFrags(5)
                    v:AddExp(exptoget, true)
                    v:GodEnable()
                    v:Freeze(true)
                    v.canblink = false
                    v.isescaping = true
                    timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
                        v:Freeze(false)
                        v:GodDisable()
                        v:SetSpectator()
                        WinCheck()
                        v.isescaping = false
                    end)
                    --v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
                elseif v:GTeam() == TEAM_CLASSD then
                    roundstats.descaped = roundstats.descaped + 1
                    local rtime = timer.TimeLeft("RoundTime")
                    local exptoget = 500
                    if rtime ~= nil then
                        exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
                        exptoget = exptoget * 2
                        exptoget = math.Round(math.Clamp(exptoget, 500, 10000))
                    end

                    net.Start("OnEscaped")
                    net.WriteInt(2, 4)
                    net.Send(v)
                    v:AddFrags(5)
                    v:AddExp(exptoget, true)
                    v:GodEnable()
                    v:Freeze(true)
                    v.canblink = false
                    v.isescaping = true
                    timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
                        v:Freeze(false)
                        v:GodDisable()
                        v:SetSpectator()
                        WinCheck()
                        v.isescaping = false
                    end)
                    --v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by Chaos Insurgency Soldiers next time to get bonus points.")
                elseif v:GTeam() == TEAM_SCP then
                    roundstats.sescaped = roundstats.sescaped + 1
                    local rtime = timer.TimeLeft("RoundTime")
                    local exptoget = 425
                    if rtime ~= nil then
                        exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
                        exptoget = exptoget * 1.9
                        exptoget = math.Round(math.Clamp(exptoget, 425, 10000))
                    end

                    net.Start("OnEscaped")
                    net.WriteInt(4, 4)
                    net.Send(v)
                    v:AddFrags(5)
                    v:AddExp(exptoget, true)
                    v:GodEnable()
                    v:Freeze(true)
                    v.canblink = false
                    v.isescaping = true
                    timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
                        v:Freeze(false)
                        v:GodDisable()
                        v:SetSpectator()
                        WinCheck()
                        v.isescaping = false
                    end)
                end
            end
        end
    end
end

timer.Create("CheckEscape", 1, 0, CheckEscape)
function CheckEscortMTF(pl)
    if pl.nextescheck ~= nil then
        if pl.nextescheck > CurTime() then
            pl:PrintMessage(HUD_PRINTTALK, "Wait " .. math.Round(pl.nextescheck - CurTime()) .. " seconds.")
            return
        end
    end

    pl.nextescheck = CurTime() + 3
    if pl:GTeam() ~= TEAM_GUARD then
        return
    end
    local foundpl = nil
    local foundrs = {}
    for k, v in pairs(ents.FindInSphere(POS_ESCORT, 350)) do
        if v:IsPlayer() then
            if pl == v then
                foundpl = v
            elseif (v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_STAFF) and v:Alive() then
                table.ForceInsert(foundrs, v)
            end
        end
    end

    if not IsValid(foundpl) then
        return
    end
    rsstr = ""
    for i, v in ipairs(foundrs) do
        if i == 1 then
            rsstr = v:Nick()
        elseif i == #foundrs then
            rsstr = rsstr .. " and " .. v:Nick()
        else
            rsstr = rsstr .. ", " .. v:Nick()
        end
    end

    if #foundrs == 0 then
        return
    end
    pl:AddFrags(#foundrs * 3)
    pl:AddExp(#foundrs * 425, true)
    local rtime = timer.TimeLeft("RoundTime")
    local exptoget = 700
    if rtime ~= nil then
        exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
        exptoget = exptoget * 2.25
        exptoget = math.Round(math.Clamp(exptoget, 700, 10000))
    end

    for k, v in ipairs(foundrs) do
        --roundstats.rescaped = roundstats.rescaped + 1
        roundstats.rescorted = roundstats.rescorted + 1
        v:SetSpectator()
        v:AddFrags(10)
        v:AddExp(exptoget, true)
        v:PrintMessage(HUD_PRINTTALK, "You've been escorted by " .. pl:Nick())
        net.Start("OnEscaped")
        net.WriteInt(3, 4)
        net.Send(v)
        WinCheck()
    end

    pl:PrintMessage(HUD_PRINTTALK, "You've successfully escorted: " .. rsstr)
end

function CheckEscortChaos(pl)
    if pl.nextescheck ~= nil then
        if pl.nextescheck > CurTime() then
            pl:PrintMessage(HUD_PRINTTALK, "Wait " .. math.Round(pl.nextescheck - CurTime()) .. " seconds.")
            return
        end
    end

    pl.nextescheck = CurTime() + 3
    if pl:GTeam() ~= TEAM_CHAOS then
        return
    end
    local foundpl = nil
    local foundds = {}
    for k, v in pairs(ents.FindInSphere(POS_ESCORT, 350)) do
        if v:IsPlayer() then
            if pl == v then
                foundpl = v
            elseif v:GTeam() == TEAM_CLASSD and v:Alive() then
                table.ForceInsert(foundds, v)
            end
        end
    end

    rsstr = ""
    for i, v in ipairs(foundds) do
        if i == 1 then
            rsstr = v:Nick()
        elseif i == #foundds then
            rsstr = rsstr .. " and " .. v:Nick()
        else
            rsstr = rsstr .. ", " .. v:Nick()
        end
    end

    if #foundds == 0 then
        return
    end
    pl:AddFrags(#foundds * 3)
    pl:AddExp(#foundds * 500, true)
    local rtime = timer.TimeLeft("RoundTime")
    local exptoget = 800
    if rtime ~= nil then
        exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
        exptoget = exptoget * 2.5
        exptoget = math.Round(math.Clamp(exptoget, 800, 10000))
    end

    for k, v in ipairs(foundds) do
        roundstats.dcaptured = roundstats.dcaptured + 1
        v:SetSpectator()
        v:AddFrags(10)
        v:AddExp(exptoget, true)
        v:PrintMessage(HUD_PRINTTALK, "You've been captured by " .. pl:Nick())
        net.Start("OnEscaped")
        net.WriteInt(3, 4)
        net.Send(v)
        WinCheck()
    end

    pl:PrintMessage(HUD_PRINTTALK, "You've successfully captured: " .. rsstr)
end

function WinCheck()
    if #player.GetAll() < 2 then
        return
    end
    if preparing then
        return
    end
    if postround then
        return
    end
    local endround = false
    local ds = gteams.NumPlayers(TEAM_CLASSD)
    local mtfs = gteams.NumPlayers(TEAM_GUARD)
    local res = gteams.NumPlayers(TEAM_SCI)
    local staff = gteams.NumPlayers(TEAM_STAFF)
    local scps = gteams.NumPlayers(TEAM_SCP)
    local chaos = gteams.NumPlayers(TEAM_CHAOS)
    local all = #GetAlivePlayers()
    --print("wincheck! ds:", ds, "mtfs:", mtfs, "res:", res, "staff:", staff, "scps:", scps, "chaos:", chaos, "all:", all)
    local why = "idk"
    local wintype = 2
    if all == 0 then
        why = "everybody is dead"
        endround = true
        wintype = 3
    elseif scps == all then
        endround = true
        why = "there are only scps"
    elseif mtfs == all then
        endround = true
        why = "there are only mtfs"
    elseif res == all then
        endround = true
        why = "there are only researchers"
    elseif staff == all then
        endround = true
        why = "there is only staff"
    elseif ds == all then
        endround = true
        why = "there are only class ds"
    elseif chaos == all then
        endround = true
        why = "there are only chaos insurgency members"
    elseif ((mtfs + res) == all) or ((mtfs + staff) == all) or ((res + staff) == all) or ((mtfs + res + staff) == all) then
        endround = true
        why = "there is only staff"
    elseif (chaos + ds) == all then
        endround = true
        why = "there are only chaos insurgency members and class ds"
    end

    if endround then
        print("Ending round because " .. why)
        PrintMessage(HUD_PRINTCONSOLE, "Ending round because " .. why)
        StopRound()
        timer.Destroy("PostTime")
        preparing = false
        postround = true
        -- send infos
        net.Start("SendRoundInfo")
        net.WriteTable(roundstats)
        net.Broadcast()
        net.Start("PostStart")
        net.WriteInt(GetPostTime(), 6)
        net.WriteInt(wintype, 4)
        net.Broadcast()
        timer.Create("PostTime", GetPostTime(), 1, function()
            RoundRestart()
        end)
    end
end

function StopRound()
    timer.Stop("PreparingTime")
    timer.Stop("RoundTime")
    timer.Stop("PostTime")
    timer.Stop("GateOpen")
    timer.Stop("PlayerInfo")
    timer.Stop("PlayCommotionSounds")
end

timer.Create("WinCheckTimer", 15, 0, function()
    if postround == false and preparing == false then
        WinCheck()
    end
end)
timer.Create("EXPTimer", 120, 0, function()
    for k, v in pairs(player.GetAll()) do
        if IsValid(v) and v.AddExp ~= nil then
            v:AddExp(100, true)
        end
    end
end)