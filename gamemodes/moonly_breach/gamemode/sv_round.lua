nextspecialround = nil
function RoundRestart()
	print("round: starting")
	timer.Destroy("PreparingTime")
	timer.Destroy("RoundTime")
	timer.Destroy("PostTime")
	timer.Destroy("GateOpen")
	timer.Destroy("PlayerInfo")
	timer.Destroy("NTFEnterTime")
	game.CleanUpMap()
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
		secretf = false
	}

	print("round: mapcleaned")
	MAP_BUTTONS = table.Copy(BUTTONS)
	for k, v in pairs(player.GetAll()) do
		player_manager.SetPlayerClass(v, "class_default")
		player_manager.RunClass(v, "SetupDataTables")
		v:Freeze(false)
		v.MaxUses = nil
		v.blinkedby173 = false
		v.usedeyedrops = false
		v.isescaping = false
		v:AddKarma(KarmaRound())
		v:UpdateNKarma()
	end

	print("round: playersconfigured")
	preparing = true
	postround = false

	SetupPlayers(GetRoleTable(#GetActivePlayers()))
	net.Start("UpdateRoundType")
	net.WriteString("Containment Breach")
	net.Broadcast()
	print("round: roundtypeworking good")
	gamestarted = true
	BroadcastLua('gamestarted = true')
	print("round: gamestarted")
	if GetConVar("br_spawnzombies"):GetBool() == true then
		for k, v in pairs(SPAWN_ZOMBIES) do
			local zombie = ents.Create("npc_fastzombie")
			if IsValid(zombie) then
				zombie:Spawn()
				zombie:SetPos(v)
				zombie:SetHealth(165)
			end
		end
	end

	SpawnAllItems()
	timer.Create("NTFEnterTime", GetNTFEnterTime(), 0, function() SpawnNTFS() end)
	net.Start("PrepStart")
	net.WriteInt(GetPrepTime(), 8)
	net.Broadcast()
	print("round: round got well")
	timer.Create("PreparingTime", GetPrepTime(), 1, function()
		print("round: prepinit")
		for k, v in pairs(player.GetAll()) do
			v:Freeze(false)
		end

		preparing = false
		postround = false
		OpenSCPDoors()
		net.Start("RoundStart")
		net.WriteInt(GetRoundTime(), 12)
		net.Broadcast()

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
			timer.Create("PostTime", GetPostTime(), 1, function() RoundRestart() end)
		end)
	end)
end

canescortds = true
canescortrs = true
function CheckEscape()
	for k_exit, v_exit in pairs(PD_EXITS) do
		for k_ent, v_ent in pairs(ents.FindInSphere(v_exit + Vector(0, 0, 25), 200)) do
			if v_ent:IsPlayer() == true then
				if v_ent:Team() ~= TEAM_SPECTATOR and v_ent:Alive() == true then
					local rand = math.random(1, 100)
					if rand < 6 then
						local attacker = v_106
						local inflictor = v_106
						local scps_found = {}
						for k_106, v_106 in pairs(player.GetAll()) do
							if v_106:GetNClass() == ROLE_SCP106 and v_106:Alive() == true and v_ent.last106 == v_106 then table.ForceInsert(scps_found, v_106) end
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
						v_ent:EmitSound("breach/PocketDimension/Exit.ogg", 75, 100, 0.7)
					else
						v_ent:SetPos(table.Random(PD_BAD_EXIT))
						if math.random(1, 3) == 1 then v_ent:SendLua('surface.PlaySound("breach/pocketdimension/Laugh.ogg")') end
					end
				end
			end
		end
	end

	for k, v in pairs(ents.FindInSphere(POS_GATEA, 250)) do
		if v:IsPlayer() == true then
			if v.isescaping == true then return end
			if v:Team() == TEAM_CLASSD or v:Team() == TEAM_SCI or v:Team() == TEAM_SCP then
				if v:Team() == TEAM_SCI then
					roundstats.rescaped = roundstats.rescaped + 1
					net.Start("OnEscaped")
					net.WriteInt(1, 4)
					net.Send(v)
					v:AddFrags(5)
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

					v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time.")
					--BroadcastLua( "surface.PlaySound('breach/misc/bell2.ogg')" )
				elseif v:Team() == TEAM_CLASSD then
					roundstats.descaped = roundstats.descaped + 1
					net.Start("OnEscaped")
					net.WriteInt(2, 4)
					net.Send(v)
					v:AddFrags(5)
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

					v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by Chaos Insurgency Soldiers.")
					--BroadcastLua( "surface.PlaySound('breach/misc/bell2.ogg')" )
				elseif v:Team() == TEAM_SCP then
					roundstats.sescaped = roundstats.sescaped + 1
					net.Start("OnEscaped")
					net.WriteInt(4, 4)
					net.Send(v)
					v:AddFrags(5)
					v:GodEnable()
					v:Freeze(true)
					--BroadcastLua( "surface.PlaySound('breach/misc/bell2.ogg')" )
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
	if pl:Team() ~= TEAM_GUARD then return end
	local foundpl = nil
	local foundrs = {}
	for k, v in pairs(ents.FindInSphere(POS_ESCORT, 350)) do
		if v:IsPlayer() then
			if pl == v then
				foundpl = v
			elseif v:Team() == TEAM_SCI then
				table.ForceInsert(foundrs, v)
			end
		end
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

	if #foundrs == 0 then return end
	pl:AddFrags(#foundrs * 3)
	for k, v in ipairs(foundrs) do
		roundstats.rescaped = roundstats.rescaped + 1
		v:SetSpectator()
		v:AddFrags(10)
		v:PrintMessage(HUD_PRINTTALK, "You've been escorted by " .. pl:Nick())
		--BroadcastLua( "surface.PlaySound('breach/misc/bell2.ogg')" )
		net.Start("OnEscaped")
		net.WriteInt(3, 4)
		net.Send(v)
		WinCheck()
	end

	pl:PrintMessage(HUD_PRINTTALK, "You've successfully escorted: " .. rsstr)
end

function CheckEscortChaos(pl)
	if pl:Team() ~= TEAM_CHAOS then return end
	local foundpl = nil
	local foundds = {}
	for k, v in pairs(ents.FindInSphere(POS_ESCORT, 350)) do
		if v:IsPlayer() then
			if v:GetNClass() == ROLE_SCP035 then return end
			if pl == v then
				foundpl = v
			elseif v:Team() == TEAM_CLASSD then
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

	if #foundds == 0 then return end
	pl:AddFrags(#foundds * 3)
	for k, v in ipairs(foundds) do
		roundstats.dcaptured = roundstats.dcaptured + 1
		v:SetSpectator()
		v:AddFrags(10)
		v:PrintMessage(HUD_PRINTTALK, "You've been captured by " .. pl:Nick())
		--BroadcastLua( "surface.PlaySound('breach/misc/bell2.ogg')" )
		net.Start("OnEscaped")
		net.WriteInt(3, 4)
		net.Send(v)
		WinCheck()
	end

	pl:PrintMessage(HUD_PRINTTALK, "You've successfully captured: " .. rsstr)
end

function WinCheck(ply)
	if #player.GetAll() < 2 then return end
	if postround then return end
	local endround = false
	local ds = team.NumPlayers(TEAM_CLASSD)
	local mtfs = team.NumPlayers(TEAM_GUARD)
	local res = team.NumPlayers(TEAM_SCI)
	local scps = team.NumPlayers(TEAM_SCP)
	local chaos = team.NumPlayers(TEAM_CHAOS)
	local all = #GetAlivePlayers()
	local why = "idk man"
	if scps == all then
		endround = true
		why = "there are only scps"
	elseif mtfs == all then
		endround = true
		why = "there are only mtfs"
	elseif res == all then
		endround = true
		why = "there are only researchers"
	elseif ds == all then
		endround = true
		why = "there are only class ds"
	elseif chaos == all then
		endround = true
		why = "there are only chaos insurgency members"
	elseif (mtfs + res) == all then
		endround = true
		why = "there are only mtfs and researchers"
	elseif (chaos + ds) == all then
		endround = true
		why = "there are only chaos insurgency members and class ds"
	elseif (chaos + scps) == all then
		endround = false
		why = "there are only chaos insurgency members and scps"
	end

	if endround then
		print("Ending round because " .. why)
		BroadcastLua("surface.PlaySound('breach/misc/bell2.ogg')")
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
		net.WriteInt(2, 4)
		net.Broadcast()
		timer.Create("PostTime", GetPostTime(), 1, function() RoundRestart() end)
	end
end

function StopRound()
	timer.Stop("PreparingTime")
	timer.Stop("RoundTime")
	timer.Stop("PostTime")
	timer.Stop("GateOpen")
	timer.Stop("PlayerInfo")
end