-- Shared file
GM.Name = "Classic Breach"
GM.Author = "Dragon4k"
GM.Email = ""
GM.Website = ""
function GM:Initialize()
	self.BaseClass.Initialize(self)
end

TEAM_SCP = 1
TEAM_GUARD = 2
TEAM_CLASSD = 3
TEAM_SPECTATOR = 4
TEAM_SCI = 5
TEAM_CHAOS = 6
MINPLAYERS = 2
-- Team setup
team.SetUp(TEAM_SCP, "SCPs", Color(237, 28, 63))
team.SetUp(TEAM_GUARD, "MTF Guards", Color(0, 100, 255))
team.SetUp(TEAM_CLASSD, "Class Ds", Color(255, 130, 0))
team.SetUp(TEAM_SPECTATOR, "Spectators", Color(133, 183, 155))
team.SetUp(TEAM_SCI, "Scientists", Color(66, 188, 244))
team.SetUp(TEAM_CHAOS, "Chaos Insurgency", Color(0, 100, 255))
function GetLangRole(rl)
	if clang == nil then return rl end
	if rl == ROLE_SCP173 then return clang.ROLE_SCP173 end
	if rl == ROLE_SCP106 then return clang.ROLE_SCP106 end
	if rl == ROLE_SCP049 then return clang.ROLE_SCP049 end
	if rl == ROLE_SCP035 then return clang.ROLE_SCP035 end
	if rl == ROLE_SCP457 then return clang.ROLE_SCP457 end
	if rl == ROLE_SCP096 then return clang.ROLE_SCP096 end
	if rl == ROLE_SCP939 then return clang.ROLE_SCP939 end
	if rl == ROLE_SCP0492 then return clang.ROLE_SCP0492 end
	if rl == ROLE_MTFGUARD then return clang.ROLE_MTFGUARD end
	if rl == ROLE_MTFCOM then return clang.ROLE_MTFCOM end
	if rl == ROLE_MTFNTF then return clang.ROLE_MTFNTF end
	if rl == ROLE_CHAOSCOM then return clang.ROLE_CHAOSCOM end
	if rl == ROLE_CHAOS then return clang.ROLE_CHAOS end
	if rl == ROLE_CLASSD then return clang.ROLE_CLASSD end
	if rl == ROLE_RES then return clang.ROLE_RES end
	if rl == ROLE_SPEC then return clang.ROLE_SPEC end
	return rl
end

ROLE_SCP173 = "SCP-173"
ROLE_SCP106 = "SCP-106"
ROLE_SCP049 = "SCP-049"
ROLE_SCP035 = "SCP-035"
ROLE_SCP457 = "SCP-457"
ROLE_SCP096 = "SCP-096"
ROLE_SCP939 = "SCP-939"
ROLE_SCP0492 = "SCP-049-2"
ROLE_SCP0082 = "SCP-008-2"
ROLE_MTFGUARD = "MTF Guard"
ROLE_MTFCOM = "MTF Commander"
ROLE_MTFNTF = "MTF Nine Tailed Fox"
ROLE_CHAOS = "Chaos Insurgency"
ROLE_CHAOSCOM = "CI Commander"
ROLE_CLASSD = "Class D Personell"
ROLE_RES = "Researcher"
ROLE_SPEC = "Spectator"
-- scp table for a gamemode
SCPS = {
	{
		name = "SCP 035",
		func = function(pl) pl:SetSCP035() end
	},
	{
		name = "SCP 049",
		func = function(pl) pl:SetSCP049() end
	},
	{
		name = "SCP 096",
		func = function(pl) pl:SetSCP096() end
	},
	{
		name = "SCP 106",
		func = function(pl) pl:SetSCP106() end
	},
	{
		name = "SCP 173",
		func = function(pl) pl:SetSCP173() end
	},
	{
		name = "SCP 457",
		func = function(pl) pl:SetSCP457() end
	},
	{
		name = "SCP 939",
		func = function(pl) pl:SetSCP939() end
	}
}

--ULX FORCECLASS
-- scp table for ulx forceclass
SCPCLASSES = {
	{
		name = "SCP 035",
		func = function(pl) pl:SetSCP035() end
	},
	{
		name = "SCP 049",
		func = function(pl) pl:SetSCP049() end
	},
	{
		name = "SCP 049 2",
		func = function(pl) pl:SetSCP0492() end
	},
	{
		name = "SCP 096",
		func = function(pl) pl:SetSCP096() end
	},
	{
		name = "SCP 106",
		func = function(pl) pl:SetSCP106() end
	},
	{
		name = "SCP 173",
		func = function(pl) pl:SetSCP173() end
	},
	{
		name = "SCP 457",
		func = function(pl) pl:SetSCP457() end
	},
	{
		name = "SCP 939",
		func = function(pl) pl:SetSCP939() end
	}
}

-- class table for ulx forceclass
ALLCLASSES = {
	{
		name = "Class D",
		func = function(pl)
			pl:SetClassD()
			local dspawns = table.Copy(SPAWN_CLASSD)
			local spawn = table.Random(dspawns)
			pl:SetPos(spawn)
		end
	},
	{
		name = "Scientist",
		func = function(pl)
			pl:SetScientist()
			local scispawns = table.Copy(SPAWN_SCIENT)
			local spawn = table.Random(scispawns)
			pl:SetPos(spawn)
		end
	},
	{
		name = "MTF Commander",
		func = function(pl)
			pl:SetCommander()
			local guardspawns = table.Copy(SPAWN_GUARD)
			local spawn = table.Random(guardspawns)
			pl:SetPos(spawn)
		end
	},
	{
		name = "MTF Guard",
		func = function(pl)
			pl:SetGuard()
			local guardspawns = table.Copy(SPAWN_GUARD)
			local spawn = table.Random(guardspawns)
			pl:SetPos(spawn)
		end
	},
	{
		name = "MTF NTF",
		func = function(pl)
			pl:SetNTF()
			local outsidespawns = table.Copy(SPAWN_OUTSIDE)
			local spawn = table.Random(outsidespawns)
			pl:SetPos(spawn)
		end
	},
	{
		name = "CI Commander", --dont work, spawn as normal CI, to fix
		func = function(pl)
			pl:SetChaosInsCom()
			local outsidespawns = table.Copy(SPAWN_OUTSIDE)
			local spawn = table.Random(outsidespawns)
			pl:SetPos(spawn)
		end
	},
	{
		name = "Chaos Insurgency",
		func = function(pl)
			pl:SetChaosInsurgency(3)
			local outsidespawns = table.Copy(SPAWN_OUTSIDE)
			local spawn = table.Random(outsidespawns)
			pl:SetPos(spawn)
		end
	}
}

if not ConVarExists("br_roundrestart") then CreateConVar("br_roundrestart", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Restart the round") end
if not ConVarExists("br_time_preparing") then CreateConVar("br_time_preparing", "45", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set preparing time") end
if not ConVarExists("br_time_round") then CreateConVar("br_time_round", "1920", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set round time") end
if not ConVarExists("br_time_postround") then CreateConVar("br_time_postround", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set postround time") end
--if !ConVarExists("br_time_gateopen") then CreateConVar( "br_time_gateopen", "180", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set gate open time" ) end
if not ConVarExists("br_time_ntfenter") then CreateConVar("br_time_ntfenter", "360", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Time that NTF units will enter the facility") end
if not ConVarExists("br_time_blink") then CreateConVar("br_time_blink", "0.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Blink timer") end
if not ConVarExists("br_time_blinkdelay") then CreateConVar("br_time_blinkdelay", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Delay between blinks") end
--if !ConVarExists("br_opengatea_enabled") then CreateConVar( "br_opengatea_enabled", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want to force opening gate A after x seconds?" ) end
if not ConVarExists("br_spawn_level4") then CreateConVar("br_spawn_level4", "2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How many keycards level 4 you want to spawn?") end
if not ConVarExists("br_spawnzombies") then CreateConVar("br_spawnzombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want zombies?") end
if not ConVarExists("br_karma") then CreateConVar("br_karma", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want to enable karma system?") end
if not ConVarExists("br_karma_max") then CreateConVar("br_karma_max", "1200", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Max karma") end
if not ConVarExists("br_karma_starting") then CreateConVar("br_karma_starting", "1000", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Starting karma") end
if not ConVarExists("br_karma_save") then CreateConVar("br_karma_save", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want to save the karma?") end
if not ConVarExists("br_karma_round") then CreateConVar("br_karma_round", "120", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How much karma to add after a round") end
if not ConVarExists("br_karma_reduce") then CreateConVar("br_karma_reduce", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How much karma to reduce after damaging someone") end
if not ConVarExists("br_scoreboardranks") then CreateConVar("br_scoreboardranks", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "") end
if not ConVarExists("br_defaultlanguage") then CreateConVar("br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "") end
function KarmaReduce()
	return GetConVar("br_karma_reduce"):GetInt()
end

function KarmaRound()
	return GetConVar("br_karma_round"):GetInt()
end

function SaveKarma()
	return GetConVar("br_karma_save"):GetInt()
end

function MaxKarma()
	return GetConVar("br_karma_max"):GetInt()
end

function StartingKarma()
	return GetConVar("br_karma_starting"):GetInt()
end

function KarmaEnabled()
	return GetConVar("br_karma"):GetBool()
end

function GetPrepTime()
	return GetConVar("br_time_preparing"):GetInt()
end

function GetRoundTime()
	return GetConVar("br_time_round"):GetInt()
end

function GetPostTime()
	return GetConVar("br_time_postround"):GetInt()
end

function GetGateOpenTime()
	return GetConVar("br_time_gateopen"):GetInt()
end

function GetNTFEnterTime()
	return GetConVar("br_time_ntfenter"):GetInt()
end

function InPD(ply)
	if POCKETDIMENSION == nil then return false end
	for k, v in pairs(POCKETDIMENSION) do
		local pos1 = v.pos1
		local pos2 = v.pos2
		OrderVectors(pos1, pos2)
		if ply:GetPos():WithinAABox(pos1, pos2) then return true end
	end
	return false
end

function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
	if not ply.GetNClass then player_manager.RunClass(ply, "SetupDataTables") end
	if not ply.GetNClass then return end
	if ply:GetNClass() == ROLE_SCP173 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 6 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/173/step" .. math.random(1, 3) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_SCP106 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 2 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/106/step" .. math.random(1, 3) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_SCP049 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 3 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/049/step" .. math.random(1, 3) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_SCP457 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/classd_scp035_scient/concrete" .. math.random(1, 4) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_SCP035 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/classd_scp035_scient/concrete" .. math.random(1, 4) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_CLASSD then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/classd_scp035_scient/concrete" .. math.random(1, 4) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_RES then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/classd_scp035_scient/concrete" .. math.random(1, 4) .. ".ogg", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_MTFNTF then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/mtf_ci/concrete" .. math.random(1, 6) .. ".wav", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_MTFCOM then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/mtf_ci/concrete" .. math.random(1, 6) .. ".wav", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_MTFGUARD then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/mtf_ci/concrete" .. math.random(1, 6) .. ".wav", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_CHAOSCOM then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/mtf_ci/concrete" .. math.random(1, 6) .. ".wav", 300, 100, 1) end
		end
		return true
	end

	if ply:GetNClass() == ROLE_CHAOS then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 1 then
			ply.steps = 1
			if SERVER then ply:EmitSound("breach/steps/mtf_ci/concrete" .. math.random(1, 6) .. ".wav", 300, 100, 1) end
		end
		return true
	end
	return false
end

function GM:EntityTakeDamage(target, dmginfo)
	local at = dmginfo:GetAttacker()
	if at:IsNPC() then
		if at:GetClass() == "npc_fastzombie" then dmginfo:ScaleDamage(4) end
	elseif target:IsPlayer() then
		if target:Alive() then
			local dmgtype = dmginfo:GetDamageType()
			if dmgtype == 268435464 or dmgtype == 8 then
				if target:Team() == TEAM_SCP then
					dmginfo:SetDamage(0)
					return true
				elseif target.UsingArmor == "armor_fireproof" then
					dmginfo:ScaleDamage(0.4)
				end
			end
		end
	end
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	--[[
	if SERVER then
		local at = dmginfo:Getat()
		if ply:Team() == at:Team() then
			at:TakeDamage( 25, at, at )
		end
	end
	]]
	--print("a")
	local at = dmginfo:GetAttacker()
	local mul = 1
	local armormul = 1
	if SERVER then
		local rdm = false
		if at ~= ply then
			if at:IsPlayer() then
				if dmginfo:IsDamageType(DMG_BULLET) then if ply.UsingArmor ~= nil then if ply.UsingArmor ~= "armor_fireproof" then armormul = 0.85 end end end
				if postround == false then
					if at:Team() == TEAM_GUARD then
						if ply:Team() == TEAM_GUARD then
							rdm = true
						elseif ply:Team() == TEAM_SCI then
							rdm = true
						end
					elseif at:Team() == TEAM_CHAOS then
						if ply:Team() == TEAM_CHAOS then rdm = true end
					elseif at:Team() == TEAM_SCP then
						if ply:Team() == TEAM_SCP then rdm = true end
					elseif at:Team() == TEAM_CLASSD then
						if ply:Team() == TEAM_CLASSD then rdm = true end
					elseif at:Team() == TEAM_SCI then
						if ply:Team() == TEAM_GUARD or ply:Team() == TEAM_SCI then rdm = true end
					end
				end
			end
		end
	end

	if hitgroup == HITGROUP_HEAD then mul = 1.5 end
	if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then mul = 0.9 end
	if hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then mul = 0.9 end
	if hitgroup == HITGROUP_GEAR then mul = 0 end
	if hutgroup == HITGROUP_STOMACH then mul = 1 end
	if SERVER then
		if at:IsPlayer() then if at.GetNKarma then mul = mul * (at:GetNKarma() / StartingKarma()) end end
		mul = mul * armormul
		--mul = math.Round(mul)
		--print("mul: " .. mul)
		dmginfo:ScaleDamage(mul)
	end
end