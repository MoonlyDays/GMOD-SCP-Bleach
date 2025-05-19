-- Shared file
GM.Name = "Bleach"
GM.Author = "Moonly Days"
GM.Email = ""
GM.Website = ""
function GM:Initialize()
	self.BaseClass.Initialize(self)
end

TEAM_SPEC = 1
TEAM_SCP = 2
TEAM_GUARD = 3
TEAM_CLASSD = 4
TEAM_SCI = 5
TEAM_CHAOS = 6
TEAM_STAFF = 7
MINPLAYERS = 2
team.SetUp(1, "Default", Color(255, 255, 0))
function GetLangRole(rl)
	if clang == nil then return rl end
	local rolef = nil
	for k, v in pairs(ROLES) do
		if rl == v then rolef = k end
	end

	if rolef ~= nil then
		return clang.ROLES[rolef]
	else
		return rl
	end
end

ROLES = {}
-- SCPS
ROLES.ROLE_SCP173 = "SCP-173"
ROLES.ROLE_SCP106 = "SCP-106"
ROLES.ROLE_SCP049 = "SCP-049"
ROLES.ROLE_SCP457 = "SCP-457"
ROLES.ROLE_SCP966 = "SCP-966"
ROLES.ROLE_SCP0492 = "SCP-049-2"
ROLES.ROLE_SCP0082 = "SCP-008-2"
-- Research Staff
ROLES.ROLE_RES = "Researcher"
ROLES.ROLE_RES_SPY = "CI Spy"
ROLES.ROLE_HRES = "Head Researcher"
-- Misc Staff
ROLES.ROLE_JANITOR = "Janitor"
ROLES.ROLE_ENG = "Engineer"
ROLES.ROLE_MEDIC = "Medic"
-- Class D Personnel
ROLES.ROLE_CLASSD = "Class D Personnel"
ROLES.ROLE_VETERAN = "Class D Veteran"
-- Security
ROLES.ROLE_SEC_GUARD = "Security Guard"
ROLES.ROLE_SEC_OFFICER = "Security Officer"
ROLES.ROLE_SEC_MEDIC = "Security Medic"
ROLES.ROLE_SEC_CHIEF = "Security Chief"
ROLES.ROLE_SD = "Site Director"
-- Support
ROLES.ROLE_CHAOS = "CI Soldier"
ROLES.ROLE_MTF_OFFICER = "MTF Officer"
ROLES.ROLE_MTF_MEDIC = "MTF Medic"
ROLES.ROLE_MTF_SCU = "MTF SCU"
ROLES.ROLE_MTF_SNIPER = "MTF Sniper"
ROLES.ROLE_CHAOSCOM = "CI Commander"
ROLES.ROLE_MTF_LIE = "MTF Lieutenant"
ROLES.ROLE_MTF_COM = "MTF Commander"
-- CI Spies
ROLES.ROLE_CI_RES = "CI Spy Researcher"
ROLES.ROLE_CI_GUARD = "CI Spy Guard"
ROLES.ROLE_CI_SOLD = "CI Spy Soldier"
-- Other
ROLES.ROLE_SPEC = "Spectator"
if not ConVarExists("br_time_preparing") then CreateConVar("br_time_preparing", "45", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set preparing time") end
if not ConVarExists("br_time_round") then CreateConVar("br_time_round", "720", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set round time") end
if not ConVarExists("br_time_postround") then CreateConVar("br_time_postround", "20", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set postround time") end
if not ConVarExists("br_time_gateb_open_min") then CreateConVar("br_time_gateb_open_min", "252", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Minimum time the gate b should open") end
if not ConVarExists("br_time_gateb_open_max") then CreateConVar("br_time_gateb_open_max", "684", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Maximum time the gate b should open") end
if not ConVarExists("br_time_ntfenter_delay_min") then CreateConVar("br_time_ntfenter_delay_min", "90", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Minimum time that NTF units will enter the facility") end
if not ConVarExists("br_time_ntfenter_delay_max") then CreateConVar("br_time_ntfenter_delay_max", "180", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Maximum time that NTF units will enter the facility") end
if not ConVarExists("br_time_blink") then CreateConVar("br_time_blink", "0.2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Blink timer") end
if not ConVarExists("br_time_blinkdelay") then CreateConVar("br_time_blinkdelay", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Delay between blinks") end
if not ConVarExists("br_specialround_percentage") then CreateConVar("br_specialround_percentage", "12", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set percentage of special rounds") end
if not ConVarExists("br_specialround_forcenext") then CreateConVar("br_specialround_forcenext", "none", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Force the next round to be a special round") end
if not ConVarExists("br_scoreboardranks") then CreateConVar("br_scoreboardranks", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "") end
if not ConVarExists("br_defaultlanguage") then CreateConVar("br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "") end
if not ConVarExists("br_expscale") then CreateConVar("br_expscale", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "") end
if not ConVarExists("br_force_roles") then CreateConVar("br_force_roles", "none", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Force roles for the next round") end
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
	return
end

function FindRole(role)
	for k, v in pairs(ALLCLASSES) do
		for k2, v2 in pairs(v.roles) do
			if v2.name == role then return v2 end
		end
	end
	return nil
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

function InGas(ply)
	if GAS_AREAS == nil then return false end
	for k, v in pairs(ply:GetWeapons()) do
		if v.GasMaskOn == true then return false end
	end

	for k, v in pairs(GAS_AREAS) do
		local pos1 = v.pos1
		local pos2 = v.pos2
		OrderVectors(pos1, pos2)
		if ply:GetPos():WithinAABox(pos1, pos2) then return true end
	end
	return false
end

function GM:Move(ply, mv)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then if isfunction(wep.Move) then return wep:Move(ply, mv) end end
	return false
end

function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
	return true
end

function GM:EntityTakeDamage(target, dmginfo)
	if target:IsPlayer() then
		if target:Alive() then
			local dmgtype = dmginfo:GetDamageType()
			if dmgtype == 268435464 or dmgtype == 8 then
				if target:GTeam() == TEAM_SCP then
					dmginfo:SetDamage(0)
					return true
				elseif target.UsingArmor == "armor_fireproof" then
					dmginfo:ScaleDamage(0.60)
				end
			end
		end
	end
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	local at = dmginfo:GetAttacker()
	local mul = 1
	local armormul = 1
	if at ~= ply and at:IsPlayer() then
		if ply.UsingArmor ~= nil and dmginfo:IsDamageType(DMG_BULLET) then if ply.UsingArmor ~= "armor_fireproof" then armormul = 0.85 end end
		local att_team = at:GTeam()
		local vic_team = ply:GTeam()
		if postround == false then
			if (att_team == TEAM_GUARD or att_team == TEAM_SCI or att_team == TEAM_STAFF) and (vic_team == TEAM_GUARD or vic_team == TEAM_SCI or vic_team == TEAM_STAFF) then
				return true
			elseif (att_team == TEAM_CLASSD or att_team == TEAM_CHAOS) and (vic_team == TEAM_CLASSD or vic_team == TEAM_CHAOS) then
				return true
			elseif att_team == TEAM_SCP and vic_team == TEAM_CLASSD then
				return true
			end

			if SERVER then at:AddExp(math.Round(dmginfo:GetDamage() / 4)) end
		end
	end

	if hitgroup == HITGROUP_HEAD then
		mul = 1.5
	elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
		mul = 0.9
	elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
		mul = 0.9
	elseif hitgroup == HITGROUP_GEAR then
		mul = 0
	elseif hutgroup == HITGROUP_STOMACH then
		mul = 1
	end

	if SERVER then
		mul = mul * armormul
		dmginfo:ScaleDamage(mul)
	end
end

function Check914Button()
	local pos_tab = {
		{
			st = Vector(1565.968750, -823.031616, 61.957233),
			en = Vector(1565.968750, -826.915161, 62.004955)
		},
		{
			st = Vector(1565.968750, -825.680786, 68.210999),
			en = Vector(1565.968750, -828.393799, 65.604767)
		},
		{
			st = Vector(1565.968750, -832.041626, 70.997414),
			en = Vector(1565.968750, -832.085083, 66.835930)
		},
		{
			st = Vector(1565.968750, -838.287720, 68.332352),
			en = Vector(1565.968750, -835.649292, 65.702744)
		},
		{
			st = Vector(1565.968750, -841.050415, 62.003887),
			en = Vector(1565.968750, -837.351990, 61.958420)
		},
	}

	for i, v in ipairs(pos_tab) do
		local tr = util.TraceLine({
			start = v.st,
			endpos = v.en,
			mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE
		})

		if tr.Hit == true then return i end
	end
	return 0
end