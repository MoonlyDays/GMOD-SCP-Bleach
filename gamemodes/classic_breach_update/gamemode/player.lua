-- Serverside file for all player related functions
function CheckStart()
	if MINPLAYERS == nil then MINPLAYERS = 2 end
	if gamestarted == false and #GetActivePlayers() >= MINPLAYERS then RoundRestart() end
	if #GetActivePlayers() == MINPLAYERS then RoundRestart() end
	if gamestarted then BroadcastLua('gamestarted = true') end
end

function GM:PlayerInitialSpawn(ply)
	ply:SetCanZoom(false)
	ply:SetNoDraw(true)
	ply.Active = false
	ply.freshspawn = true
	ply.isblinking = false
	ply.ActivePlayer = true
	ply.Karma = StartingKarma() or 1000
	if timer.Exists("RoundTime") == true then
		net.Start("UpdateTime")
		net.WriteString(tostring(timer.TimeLeft("RoundTime")))
		net.Send(ply)
	end

	player_manager.SetPlayerClass(ply, "class_default")
	CheckStart()
	if gamestarted then ply:SendLua('gamestarted = true') end
	if not ply.GetNClass then player_manager.RunClass(ply, "SetupDataTables") end
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
	ply.Active = false
	ply.Leaver = "none"
	if prepring then
		ply:SetClassD()
	else
		ply:SetSpectator()
	end
end

function GM:PlayerSpawn(ply)
	ply.Leaver = "none"
	ply:SetupHands()
	ply:SetNoCollideWithTeammates(true)
	if prepring == false then ply:SetSpectator() end
	if ply.freshspawn then
		ply:SetSpectator()
		ply.freshspawn = false
	end

	ply:SetupHands()
	if not ply.GetNClass then
		player_manager.SetPlayerClass(ply, "class_default")
		player_manager.RunClass(ply, "SetupDataTables")
	end

	if not ply.GetNClass then player_manager.RunClass(ply, "SetupDataTables") end
end

function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	if info then
		if ply.handsmodel ~= nil then info = ply.handsmodel end
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end

function GM:PlayerDeathThink(ply)
	if ply.nextspawn == nil then ply.nextspawn = CurTime() + 5 end
	if CurTime() >= ply.nextspawn then
		ply:Freeze(false)
		ply:Spawn()
		ply:SetSpectator()
		ply.nextspawn = CurTime() + 1
	end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo) --Camera fix from Breach 1.5
	if ply:GetNClass() ~= ROLE_SCP173 then ply:CreateRagdoll(ply, attacker, dmginfo:GetDamageType()) end
	ply:AddDeaths(1)
end

function GM:PlayerDeath(victim, inflictor, attacker)
	-- FIX FOR A VERY WEIRD BUG WITH FALLING DOWN --From Breach 1.5
	if victim:HasWeapon("weapon_scp_173") then victim:StripWeapon("weapon_scp_173") end
	victim:SetWalkSpeed(200)
	victim:SetRunSpeed(200)
	victim:SetJumpPower(200)
	victim:SetViewEntity(victim)
	if victim:IsFrozen() then victim:Freeze(false) end
	victim.nextspawn = CurTime() + 5
	if attacker:IsPlayer() then print("[KILL] " .. attacker:Nick() .. " [" .. attacker:GetNClass() .. "] killed " .. victim:Nick() .. " [" .. victim:GetNClass() .. "]") end
	victim:SetNClass(ROLE_SPEC)
	if attacker ~= victim and postround == false and attacker:IsPlayer() then
		if attacker:IsPlayer() then
			if attacker:Team() == TEAM_GUARD then
				victim:PrintMessage(HUD_PRINTTALK, "You were killed by an MTF Guard: " .. attacker:Nick())
				if victim:Team() == TEAM_SCP then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:AddFrags(10)
				elseif victim:Team() == TEAM_CHAOS then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 5 points for killng a Chaos Insurgency member!")
					attacker:AddFrags(5)
				elseif victim:Team() == TEAM_CLASSD then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Class D Personell!")
					attacker:AddFrags(2)
				end
			elseif attacker:Team() == TEAM_CHAOS then
				victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Chaos Insurgency Soldier: " .. attacker:Nick())
				if victim:Team() == TEAM_GUARD then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng an MTF Guard!")
					attacker:AddFrags(2)
				elseif victim:Team() == TEAM_SCI then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Researcher!")
					attacker:AddFrags(2)
				elseif victim:Team() == TEAM_SCP then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:AddFrags(10)
				elseif victim:Team() == TEAM_CLASSD then
					attacker:PrintMessage(HUD_PRINTTALK, "Don't kill Class D Personell, you can capture them to get bonus points!")
					attacker:AddFrags(1)
				end
			elseif attacker:Team() == TEAM_SCP then
				victim:PrintMessage(HUD_PRINTTALK, "You were killed by an SCP: " .. attacker:Nick())
				attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng " .. victim:Nick())
				attacker:AddFrags(2)
			elseif attacker:Team() == TEAM_CLASSD then
				victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Class D: " .. attacker:Nick())
				if victim:Team() == TEAM_GUARD then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 4 points for killng an MTF Guard!")
					attacker:AddFrags(4)
				elseif victim:Team() == TEAM_SCI then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Researcher!")
					attacker:AddFrags(2)
				elseif victim:Team() == TEAM_SCP then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:AddFrags(10)
				elseif victim:Team() == TEAM_CHAOS then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Chaos Insurgency member!")
					attacker:AddFrags(2)
				end
			elseif attacker:Team() == TEAM_SCI then
				victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Researcher: " .. attacker:Nick())
				if victim:Team() == TEAM_SCP then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:AddFrags(10)
				elseif victim:Team() == TEAM_CHAOS then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 5 points for killng a Chaos Insurgency member!")
					attacker:AddFrags(5)
				elseif victim:Team() == TEAM_CLASSD then
					attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killing a Class D Personell!")
					attacker:AddFrags(2)
				end
			end
		end
	end

	roundstats.deaths = roundstats.deaths + 1
	victim:SetTeam(TEAM_SPECTATOR)
	--victim:UnUseArmor()
	if #victim:GetWeapons() > 0 then
		local pos = victim:GetPos()
		for k, v in pairs(victim:GetWeapons()) do
			local candrop = true
			if v.droppable ~= nil then if v.droppable == false then candrop = false end end
			if candrop then
				local wep = ents.Create(v:GetClass())
				if IsValid(wep) then
					wep:SetPos(pos)
					wep:Spawn()
					wep:SetClip1(v:Clip1())
				end
			end
		end
	end

	WinCheck()
end

function GM:PlayerDisconnected(ply)
	ply:SetTeam(TEAM_SPECTATOR)
	if #player.GetAll() < MINPLAYERS then
		BroadcastLua('gamestarted = false')
		gamestarted = false
	end

	ply:SaveKarma()
	WinCheck()
end

function HaveRadio(pl1, pl2)
	if pl1:HasWeapon("item_radio") then
		if pl2:HasWeapon("item_radio") then
			local r1 = pl1:GetWeapon("item_radio")
			local r2 = pl2:GetWeapon("item_radio")
			if not IsValid(r1) or not IsValid(r2) then return false end
			--[[
			print(pl1:Nick() .. " - " .. pl2:Nick())
			print(r1.Enabled)
			print(r1.Channel)
			print(r2.Enabled)
			print(r2.Channel)
			]]
			if r1.Enabled == true then if r2.Enabled == true then if r1.Channel == r2.Channel then if r1.Channel > 4 then return true end end end end
		end
	end
	return false
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if talker:Team() == TEAM_SCP then if listener:Team() ~= TEAM_SCP then return false end end
	if talker:Team() == TEAM_SPECTATOR then
		if listener:Team() == TEAM_SPECTATOR then
			return true
		else
			return false
		end
	end

	if HaveRadio(listener, talker) == true then return true end
	if talker:GetPos():Distance(listener:GetPos()) < 750 then
		return true, true
	else
		return false
	end
end

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, talker)
	if teamOnly then
		if talker:GetPos():Distance(listener:GetPos()) < 750 then
			return listener:Team() == talker:Team()
		else
			return false
		end
	end

	if talker:Team() == TEAM_SPECTATOR then
		if listener:Team() == TEAM_SPECTATOR then
			return true
		else
			return false
		end
	end

	if HaveRadio(listener, talker) == true then return true end
	return talker:GetPos():Distance(listener:GetPos()) < 750
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerCanPickupWeapon(ply, wep)
	--if ply.lastwcheck == nil then ply.lastwcheck = 0 end
	--if ply.lastwcheck > CurTime() then return end
	--ply.lastwcheck = CurTime() + 0.5
	if wep.IDK ~= nil then
		for k, v in pairs(ply:GetWeapons()) do
			if wep.Slot == v.Slot then return false end
		end
	end

	if wep.clevel ~= nil then
		for k, v in pairs(ply:GetWeapons()) do
			if v.clevel then return false end
		end
	end

	if ply:Team() == TEAM_SCP then
		if ply:GetNClass() == ROLE_SCP173 then
			return wep:GetClass() == "weapon_scp_173"
		elseif ply:GetNClass() == ROLE_SCP106 then
			return wep:GetClass() == "weapon_scp_106"
		elseif ply:GetNClass() == ROLE_SCP049 then
			return wep:GetClass() == "weapon_scp_049"
		elseif ply:GetNClass() == ROLE_SCP0492 then
			return wep:GetClass() == "weapon_br_zombie"
		elseif ply:GetNClass() == ROLE_SCP457 then
			return wep:GetClass() == "weapon_scp_457"
		elseif ply:GetNClass() == ROLE_SCP0082 then
			return wep:GetClass() == "weapon_br_zombie_infect"
		elseif ply:GetNClass() == ROLE_SCP035 then
			return wep:GetClass() == "weapon_scp_035_deagle"
		elseif ply:GetNClass() == ROLE_SCP096 then
			return wep:GetClass() == "weapon_scp_096"
		elseif ply:GetNClass() == ROLE_SCP939 then
			return wep:GetClass() == "weapon_scp_939"
		else
			return false
		end
	end

	if ply:GetNClass() ~= ROLE_SCP173 then if wep:GetClass() == "weapon_scp_173" then return false end end
	if ply:GetNClass() ~= ROLE_SCP106 then if wep:GetClass() == "weapon_scp_106" then return false end end
	if ply:GetNClass() ~= ROLE_SCP049 then if wep:GetClass() == "weapon_scp_049" then return false end end
	if ply:GetNClass() ~= ROLE_SCP035 then if wep:GetClass() == "weapon_scp_035_deagle" then return false end end
	if ply:GetNClass() ~= ROLE_SCP096 then if wep:GetClass() == "weapon_scp_096" then return false end end
	if ply:GetNClass() ~= ROLE_SCP939 then if wep:GetClass() == "weapon_scp_939" then return false end end
	if ply:GetNClass() ~= ROLE_SCP0492 then if wep:GetClass() == "weapon_br_zombie" then return false end end
	if ply:Team() ~= TEAM_SPECTATOR then
		if wep.teams then
			local canuse = false
			for k, v in pairs(wep.teams) do
				if v == ply:Team() then canuse = true end
			end

			if canuse == false then return false end
		end

		for k, v in pairs(ply:GetWeapons()) do
			if v:GetClass() == wep:GetClass() then return false end
		end

		ply.gettingammo = wep.SavedAmmo
		return true
	else
		return false
	end
end

function GM:PlayerCanPickupItem(ply, item)
	return not (ply:Team() == TEAM_SPECTATOR)
end

function GM:AllowPlayerPickup(ply, ent)
	return not (ply:Team() == TEAM_SPECTATOR)
end

-- usesounds = true,
function GM:PlayerUse(ply, ent)
	if ply:Team() == TEAM_SPECTATOR then return false end
	if ply.lastuse == nil then ply.lastuse = 0 end
	if ply.lastuse > CurTime() then return false end
	for k, v in pairs(MAPBUTTONS) do
		if v["pos"] == ent:GetPos() then
			--print("Found a button: " .. v["name"])
			if v.clevel ~= nil then
				if ply:CLevel() >= v.clevel then
					if v.usesounds == true then ply:EmitSound("breach/KeycardUse1.ogg") end
					ply.lastuse = CurTime() + 1
					ply:PrintMessage(HUD_PRINTCENTER, "Access granted to " .. v["name"])
					return true
				else
					if v.usesounds == true then ply:EmitSound("breach/KeycardUse2.ogg") end
					ply.lastuse = CurTime() + 1
					ply:PrintMessage(HUD_PRINTCENTER, "You need to have " .. v.clevel .. " clearance level to open this door.")
					return false
				end
			end

			if v.canactivate ~= nil then
				local canactivate = v.canactivate(ply, ent)
				if canactivate then
					if v.usesounds == true then ply:EmitSound("breach/KeycardUse1.ogg") end
					ply.lastuse = CurTime() + 1
					ply:PrintMessage(HUD_PRINTCENTER, "Access granted to " .. v["name"])
					return true
				else
					if v.usesounds == true then ply:EmitSound("breach/KeycardUse2.ogg") end
					ply.lastuse = CurTime() + 1
					if v.customdenymsg then
						ply:PrintMessage(HUD_PRINTCENTER, v.customdenymsg)
					else
						ply:PrintMessage(HUD_PRINTCENTER, "Access denied")
					end
					return false
				end
			end
		end
	end
	return true
end

function GM:CanPlayerSuicide(ply)
	return false
end