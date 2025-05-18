function AssaultGamemode()
	local all = GetActivePlayers()
	for i = 1, math.Round(#player.GetAll() / 2) do
		local pl = table.Random(all)
		pl:SetNTF()
		pl:SetPos(SPAWN_GUARD[i])
		table.RemoveByValue(all, pl)
	end

	for k, v in ipairs(all) do
		v:SetChaosInsurgency(4)
		v:SetPos(SPAWN_CLASSD[k])
	end
end

function ZombieGamemode()
	local all = GetActivePlayers()
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	--table.Add(allspawns, SPAWN_OUTSIDE)
	table.Add(allspawns, SPAWN_SCIENT)
	table.Add(allspawns, SPAWN_CLASSD)
	for i = 1, #all do
		local pl = table.Random(all)
		local spawn = table.Random(allspawns)
		pl:SetGuard()
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
		table.RemoveByValue(all, pl)
	end
end

function InfectPeople()
	local all = GetActivePlayers()
	for i = 1, #all / 4 do
		local pl = table.Random(all)
		pl:SetSCP0082()
		table.RemoveByValue(all, pl)
	end
end

function SpyGamemode()
	local all = GetActivePlayers()
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	--table.Add(allspawns, SPAWN_OUTSIDE)
	table.Add(allspawns, SPAWN_SCIENT)
	table.Add(allspawns, SPAWN_CLASSD)
	for i = 1, #GetActivePlayers() / 3 do
		local pl = table.Random(all)
		local spawn = table.Random(allspawns)
		pl:SetChaosInsurgency(1)
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
		table.RemoveByValue(all, pl)
	end

	for i, pl in ipairs(all) do
		local spawn = table.Random(allspawns)
		pl:SetGuard()
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
	end
end

normalround = {
	playersetup = function() SetupPlayers(GetRoleTable(#GetActivePlayers())) end,
	name = "Containment breach",
	minplayers = 3,
	allowntfspawn = true,
	mtfandscpdelay = true,
	onroundstart = nil
}

ROUNDS = {
	assault = {
		playersetup = AssaultGamemode,
		name = "Assault",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = nil
	},
	spies = {
		playersetup = SpyGamemode,
		name = "Trouble in SCP Town",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = nil
	},
	multiplebreaches = {
		playersetup = function()
			local pnum = #GetActivePlayers()
			if pnum < 7 then
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 1, 0, 0, 0, false))
			elseif pnum > 6 and pnum < 13 then
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 2, 0, 0, 0, false))
			elseif pnum > 12 and pnum < 20 then
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 3, 0, 0, 0, false))
			else
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 4, 0, 0, 0, false))
			end
		end,
		name = "Multiple breaches",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = true,
		onroundstart = nil
	},
	zombieplague = {
		playersetup = ZombieGamemode,
		name = "Zombie Plague",
		minplayers = 6,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = InfectPeople
	},
}