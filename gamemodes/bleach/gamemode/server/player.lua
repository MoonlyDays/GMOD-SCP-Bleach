function GM:PlayerSpawn(pl, transition)
    BaseClass.PlayerSpawn(self, pl, transition)
end


-- Serverside file for all player related functions
function CheckStart()
    if MIN_PLAYERS == nil then
        MIN_PLAYERS = 2
    end
    if gamestarted == false and #GetActivePlayers() >= MIN_PLAYERS then
        RoundRestart()
    end
    if #GetActivePlayers() == MIN_PLAYERS then
        RoundRestart()
    end
    if gamestarted then
        BroadcastLua('gamestarted = true')
    end
end

function GM:PlayerInitialSpawn(ply)

    ply:SetCanZoom(false)
    ply:SetNoDraw(true)
    ply.Active = false
    ply.freshspawn = true
    ply.isblinking = false
    ply.ActivePlayer = true

    player_manager.SetPlayerClass(ply, "player_breach")

    ply:SetNEXP(tonumber(ply:GetPData("breach_exp", 0)))
    ply:SetNLevel(tonumber(ply:GetPData("breach_level", 0)))
    ply:SetNGTeam(TEAM_SPECTATOR)
    CheckStart()
    if gamestarted then
        ply:SendLua('gamestarted = true')
    end
end

function GM:PlayerSpawn(ply)
    ply:SetTeam(1)
    ply:SetNoCollideWithTeammates(true)
    ply:SetCustomCollisionCheck(true)
    if ply.freshspawn then
        ply:SetSpectator()
        ply.freshspawn = false
    end
end

function GM:PlayerSetHandsModel(ply, ent)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)
    if info then
        if ply.handsmodel ~= nil then
            info = ply.handsmodel
        end
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
    if ply:GetNClass() ~= ROLES.ROLE_SCP173 then
        CreateRagdollPL(ply, attacker, dmginfo:GetDamageType())
    end
    ply:AddDeaths(1)
end

-- From Gmod base
function GM:PlayerDeathThink(ply)
    if ply:IsFrozen() == true then
        ply:Freeze(false)
    end
    if ply:IsBot() or ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_ATTACK2) or ply:KeyPressed(IN_JUMP) then
        ply:Spawn()
        ply:SetSpectator()
    end
end

function GM:PlayerDeath(victim, inflictor, attacker)
    victim:SetWalkSpeed(200)
    victim:SetRunSpeed(200)
    victim:SetJumpPower(200)
    victim:SetViewEntity(victim)
    if victim:IsFrozen() then
        victim:Freeze(false)
    end
    victim.nextspawn = CurTime() + 5
    if attacker:IsPlayer() then
        print("[KILL] " .. attacker:Nick() .. " [" .. attacker:GetNClass() .. "] killed " .. victim:Nick() .. " [" .. victim:GetNClass() .. "]")
    end
    victim:SetNClass(ROLES.ROLE_SPEC)
    if attacker ~= victim and postround == false and attacker:IsPlayer() then
        if attacker:IsPlayer() then
            if attacker:GTeam() == TEAM_GUARD then
                victim:PrintMessage(HUD_PRINTTALK, "You were killed by an MTF Guard: " .. attacker:Nick())
                if victim:GTeam() == TEAM_SCP then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
                    attacker:AddFrags(10)
                elseif victim:GTeam() == TEAM_CHAOS then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 5 points for killng a Chaos Insurgency member!")
                    attacker:AddFrags(5)
                elseif victim:GTeam() == TEAM_CLASS_D then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Class D Personnel!")
                    attacker:AddFrags(2)
                end
            elseif attacker:GTeam() == TEAM_CHAOS then
                victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Chaos Insurgency Soldier: " .. attacker:Nick())
                if victim:GTeam() == TEAM_GUARD then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Guard!")
                    attacker:AddFrags(2)
                elseif victim:GTeam() == TEAM_SCIENTIST then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Researcher!")
                    attacker:AddFrags(2)
                elseif victim:GTeam() == TEAM_STAFF then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng Staff!")
                    attacker:AddFrags(2)
                elseif victim:GTeam() == TEAM_SCP then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
                    attacker:AddFrags(10)
                elseif victim:GTeam() == TEAM_CLASS_D then
                    attacker:PrintMessage(HUD_PRINTTALK, "Don't kill Class D Personnel, you can capture them to get bonus points!")
                    attacker:AddFrags(1)
                end
            elseif attacker:GTeam() == TEAM_SCP then
                victim:PrintMessage(HUD_PRINTTALK, "You were killed by an SCP: " .. attacker:Nick())
                attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng " .. victim:Nick())
                attacker:AddFrags(2)
            elseif attacker:GTeam() == TEAM_CLASS_D then
                victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Class D: " .. attacker:Nick())
                if victim:GTeam() == TEAM_GUARD then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 4 points for killng a Guard!")
                    attacker:AddFrags(4)
                elseif victim:GTeam() == TEAM_SCIENTIST then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Researcher!")
                    attacker:AddFrags(2)
                elseif victim:GTeam() == TEAM_STAFF then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng Staff!")
                    attacker:AddFrags(2)
                elseif victim:GTeam() == TEAM_SCP then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
                    attacker:AddFrags(10)
                elseif victim:GTeam() == TEAM_CHAOS then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Chaos Insurgency member!")
                    attacker:AddFrags(2)
                end
            elseif attacker:GTeam() == TEAM_SCIENTIST then
                victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Researcher: " .. attacker:Nick())
                if victim:GTeam() == TEAM_SCP then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
                    attacker:AddFrags(10)
                elseif victim:GTeam() == TEAM_CHAOS then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 5 points for killng a Chaos Insurgency member!")
                    attacker:AddFrags(5)
                elseif victim:GTeam() == TEAM_CLASS_D then
                    attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killing a Class D Personnel!")
                    attacker:AddFrags(2)
                end
            end
        end
    end

    roundstats.deaths = roundstats.deaths + 1
    victim:SetNGTeam(TEAM_SPECTATOR)
    if #victim:GetWeapons() > 0 then
        local pos = victim:GetPos()
        for k, v in pairs(victim:GetWeapons()) do
            local candrop = true
            if v.droppable ~= nil then
                if v.droppable == false then
                    candrop = false
                end
            end
            if candrop then
                local wep = ents.Create(v:GetClass())
                if IsValid(wep) then
                    wep:SetPos(pos)
                    wep:Spawn()
                    local atype = v:GetPrimaryAmmoType()
                    if atype > 0 then
                        wep.SavedAmmo = v:Clip1()
                    end
                end
            end
        end
    end

    WinCheck()
end

function GM:PlayerDisconnected(ply)
    if #player.GetAll() < MIN_PLAYERS then
        BroadcastLua('gamestarted = false')
        gamestarted = false
    end

    ply:SaveExp()
    ply:SaveLevel()
    WinCheck()
end

function HaveRadio(pl1, pl2)
    if pl1:HasWeapon("item_radio") then
        if pl2:HasWeapon("item_radio") then
            local r1 = pl1:GetWeapon("item_radio")
            local r2 = pl2:GetWeapon("item_radio")
            if not IsValid(r1) or not IsValid(r2) then
                return false
            end
            if r1.Enabled == true then
                if r2.Enabled == true then
                    if r1.Channel == r2.Channel then
                        if r1.Channel > 4 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if talker:Alive() == false then
        return false
    end
    if listener:Alive() == false then
        return false
    end
    if talker:GTeam() == TEAM_SCP then
        if listener:GTeam() ~= TEAM_SCP then
            return false
        end
    end
    if talker:GTeam() == TEAM_SPECTATOR then
        if listener:GTeam() == TEAM_SPECTATOR then
            return true
        else
            return false
        end
    end

    if HaveRadio(listener, talker) == true then
        return true
    end
    if talker:GetPos():Distance(listener:GetPos()) < 750 then
        return true, true
    else
        return false
    end
end

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, talker)
    if talker.Alive == nil then
        return true
    end
    if talker:Alive() == false then
        return false
    end
    if listener:Alive() == false then
        return false
    end
    if teamOnly then
        if talker:GetPos():Distance(listener:GetPos()) < 750 then
            return listener:GTeam() == talker:GTeam()
        else
            return false
        end
    end

    if talker:GTeam() == TEAM_SPECTATOR then
        if listener:GTeam() == TEAM_SPECTATOR then
            return true
        else
            return false
        end
    end

    if HaveRadio(listener, talker) == true then
        return true
    end
    return talker:GetPos():Distance(listener:GetPos()) < 750
end

function GM:PlayerDeathSound()
    return true
end

function GM:PlayerCanPickupWeapon(ply, wep)
    if wep.IDK ~= nil then
        for k, v in pairs(ply:GetWeapons()) do
            if wep.Slot == v.Slot then
                return false
            end
        end
    end

    if wep.clevel ~= nil then
        for k, v in pairs(ply:GetWeapons()) do
            if v.clevel then
                return false
            end
        end
    end

    if ply:GTeam() == TEAM_SCP then
        if not wep.ISSCP then
            return false
        else
            if wep.ISSCP == true then
                return true
            else
                return false
            end
        end
    end

    if ply:GTeam() ~= TEAM_SPECTATOR then
        if wep.teams then
            local canuse = false
            for k, v in pairs(wep.teams) do
                if v == ply:GTeam() then
                    canuse = true
                end
            end

            if canuse == false then
                return false
            end
        end

        for k, v in pairs(ply:GetWeapons()) do
            if v:GetClass() == wep:GetClass() then
                return false
            end
        end

        ply.gettingammo = wep.SavedAmmo
        return true
    else
        return false
    end
end

function GM:PlayerCanPickupItem(ply, item)
    return not (ply:GTeam() == TEAM_SPECTATOR)
end

function GM:AllowPlayerPickup(ply, ent)
    return not (ply:GTeam() == TEAM_SPECTATOR)
end

function CacheButtons()
    for _, ent in pairs(ents.GetAll()) do
        for _, button in pairs(MAP_BUTTONS) do
            if IsButton(ent, button) then
                ent.BreachButton = button
            end
        end
    end
end

function ShouldPlayerUse(ply, ent)
    if not istable(ent.BreachButton) then
        return true
    end

    if ent.BreachButton.canactivate then
        local canactivate = ent.BreachButton.canactivate(ply, ent)
        if not canactivate then
            if ent.BreachButton.usesounds then
                ply:EmitSound("KeycardUse2.ogg")
            end
            ply.lastuse = CurTime() + 1
            if ent.BreachButton.customdenymsg then
                ply:PrintMessage(HUD_PRINTCENTER, ent.BreachButton.customdenymsg)
            else
                ply:PrintMessage(HUD_PRINTCENTER, "Access denied")
            end
            return false
        end
    end

    if ent.BreachButton.clevel then
        if ply:CLevel() < ent.BreachButton.clevel then
            if ent.BreachButton.usesounds == true then
                ply:EmitSound("KeycardUse2.ogg")
            end
            ply.lastuse = CurTime() + 1
            ply:PrintMessage(HUD_PRINTCENTER, "You need to have " .. ent.BreachButton.clevel .. " clearance level to open this door.")
            return false
        end
    end

    if ent.BreachButton.usesounds == true then
        ply:EmitSound("KeycardUse1.ogg")
    end

    ply.lastuse = CurTime() + 1
    ply:PrintMessage(HUD_PRINTCENTER, "Access granted to " .. ent.BreachButton["name"])

    if ent.BreachButton.used then
        ent.BreachButton.used(ply, ent)
    end

    return true
end

function GM:PlayerUse(ply, ent)
    if not ply:Alive() then
        return false
    end
    if ply:GTeam() == TEAM_SPECTATOR then
        return false
    end
    if ply.lastuse == nil then
        ply.lastuse = 0
    end
    if ply.lastuse > CurTime() then
        return false
    end
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) then
        if isfunction(wep.HandleUse) then
            wep:HandleUse()
            ply.lastuse = CurTime() + 1
            return false
        end
    end
    return ShouldPlayerUse(ply, ent)
end

function GM:CanPlayerSuicide(ply)
    return false
end

function BreachTick()
    if isfunction(MAP_THINK) then
        MAP_THINK()
    end
    for k, v in pairs(player.GetAll()) do
        if v.GTeam() == TEAM_SPECTATOR then
            local target = v:GetObserverTarget()
            if IsValid(target) and target:IsPlayer() then
                if target:GTeam() == TEAM_SPECTATOR then
                    v:SpectatePlayerLeft()
                end
            end
        end

        if v.nextDamageInPD == nil then
            v.nextDamageInPD = 0
        end
        if v.nextDamageInGas == nil then
            v.nextDamageInGas = 0
        end
        if v.LastCough == nil then
            v.LastCough = 0
        end
        if v.NextCough == nil then
            v.NextCough = 0
        end
        if v:Alive() == true and v:GTeam() ~= TEAM_SPECTATOR and v:GTeam() ~= TEAM_SCP then
            if InPD(v) == true and v.nextDamageInPD < CurTime() then
                v.nextDamageInPD = CurTime() + 2
                v:SetHealth(v:Health() - 2)
                if v:Health() < 1 then
                    v:Kill()
                end
            end

            if InGas(v) == true and v.nextDamageInGas < CurTime() then
                v.nextDamageInGas = CurTime() + 0.35
                v:SetHealth(v:Health() - 1)
                if v:Health() < 1 then
                    v:Kill()
                end
                if v.NextCough < CurTime() then
                    v.LastCough = v.LastCough + 1
                    if v.LastCough > 3 then
                        v.LastCough = 1
                    end
                    print(v.LastCough)
                    v:EmitSound("D9341/Cough" .. v.LastCough .. ".ogg")
                    --v.targetForSCPs = CurTime()
                    v:SetNWFloat("targetForSCPs", CurTime())
                    v.NextCough = CurTime() + 3
                end
            end
        end
    end
end

hook.Add("Tick", "BreachTickHook", BreachTick)