include("shared.lua")
include("gteams.lua")
include("fonts.lua")
include("class_breach.lua")
include("classes.lua")
include("cl_classmenu.lua")
include("sh_player.lua")
include("cl_mtfmenu.lua")
include("cl_scoreboard.lua")
include("cl_sounds.lua")
include("cl_targetid.lua")
include("cl_headbob.lua")
buttonstatus = "rough"
clang = nil
ALL_LANGUAGES = {}
local files, _ = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA")
for k, v in pairs(files) do
	local path = "languages/" .. v
	if string.Right(v, 3) == "lua" then
		include(path)
		print("Loading language: " .. path)
	end
end

langtouse = CreateClientConVar("br_language", "english", true, false):GetString()
cvars.AddChangeCallback("br_language", function(convar_name, value_old, value_new)
	langtouse = value_new
	if ALL_LANGUAGES[langtouse] then clang = ALL_LANGUAGES[langtouse] end
end)

print("langtouse:")
print(langtouse)
if ALL_LANGUAGES[langtouse] then
	clang = ALL_LANGUAGES[langtouse]
else
	clang = ALL_LANGUAGES.english
end

mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
include(mapfile)
include("cl_hud.lua")
RADIO4SOUNDSHC = {{"chatter1", 39}, {"chatter2", 72}, {"chatter4", 12}, {"franklin1", 8}, {"franklin2", 13}, {"franklin3", 12}, {"franklin4", 19}, {"ohgod", 25}}
RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
disablehud = false
function DropCurrentVest()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() ~= TEAM_SPEC then
		net.Start("DropCurrentVest")
		net.SendToServer()
	end
end

concommand.Add("br_roundrestart_cl", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		net.Start("RoundRestart")
		net.SendToServer()
	end
end)

concommand.Add("br_dropvest", function(ply, cmd, args) DropCurrentVest() end)
concommand.Add("br_disableallhud", function(ply, cmd, args) disablehud = not disablehud end)
function LPoutside()
	local pos1 = FOG_SETTINGS.pos1
	local pos2 = FOG_SETTINGS.pos2
	OrderVectors(pos1, pos2)
	if LocalPlayer():GetPos():WithinAABox(pos1, pos2) then return true end
	return false
end

function MakeFOG()
	local nvg = nil
	for k, v in pairs(LocalPlayer():GetWeapons()) do
		if istable(v.NVG) and v.NVGenabled == true then
			nvg = v.NVG
			nvg[9]()
			return true
		end
	end

	if FOG_SETTINGS ~= nil then
		if LPoutside() == true then
			render.FogStart(500)
			render.FogEnd(5000)
			render.FogColor(200, 200, 200)
			render.FogMaxDensity(1)
			render.FogMode(MATERIAL_FOG_LINEAR)
			return true
		end

		render.FogStart(1)
		render.FogEnd(850)
		render.FogColor(2, 2, 2)
		render.FogMaxDensity(1)
		render.FogMode(MATERIAL_FOG_LINEAR)
	end
	return true
end

hook.Add("SetupWorldFog", "force_fog", function()
	MakeFOG()
	return true
end)

hook.Add("SetupSkyboxFog", "force_fog_skybox", function()
	MakeFOG()
	return true
end)

gamestarted = false
cltime = 0
drawinfodelete = 0
shoulddrawinfo = false
drawendmsg = nil
timefromround = 0
timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():GTeam() ~= TEAM_SPEC then if LocalPlayer():Health() < 21 then LocalPlayer():EmitSound("heartbeat.ogg") end end
end)

function OnUseEyedrops(ply)
end

function StartTime()
	timer.Destroy("UpdateTime")
	timer.Create("UpdateTime", 1, 0, function() if cltime > 0 then cltime = cltime - 1 end end)
end

endinformation = {}
last_capture_by_106 = 0
net.Receive("CapturedBy106", function(len)
	--surface.PlaySound("Laugh.ogg")
	surface.PlaySound("PocketDimension/Enter.ogg")
	last_capture_by_106 = CurTime()
end)

net.Receive("Update914B", function(len)
	local sstatus = net.ReadInt(6)
	if sstatus == 0 then
		buttonstatus = "rough"
	elseif sstatus == 1 then
		buttonstatus = "coarse"
	elseif sstatus == 2 then
		buttonstatus = "1:1"
	elseif sstatus == 3 then
		buttonstatus = "fine"
	elseif sstatus == 4 then
		buttonstatus = "very fine"
	end
end)

local smokeparticles = {Model("particle/particle_smokegrenade"), Model("particle/particle_noisesphere")}
net.Receive("BR_CreateSmoke", function(len)
	local smoke_pos = net.ReadVector()
	local smoke_time = net.ReadInt(16)
	local em = ParticleEmitter(smoke_pos)
	for i = 1, 20 do
		--local prpos = VectorRand() * 300
		--prpos.z = prpos.z + 32
		local p = em:Add(table.Random(smokeparticles), smoke_pos)
		if p then
			local gray = 10
			p:SetColor(gray, gray, gray)
			p:SetStartAlpha(255)
			p:SetEndAlpha(200)
			p:SetVelocity(VectorRand() * math.Rand(900, 1300))
			p:SetLifeTime(0)
			p:SetDieTime(smoke_time)
			p:SetStartSize(40)
			p:SetEndSize(8)
			p:SetRoll(math.random(-180, 180))
			p:SetRollDelta(math.Rand(-0.1, 0.1))
			p:SetAirResistance(600)
			p:SetCollide(true)
			p:SetBounce(0.4)
			p:SetLighting(false)
		end
	end

	em:Finish()
end)

net.Receive("UpdateTime", function(len)
	cltime = tonumber(net.ReadString())
	StartTime()
end)

net.Receive("OnEscaped", function(len)
	local nri = net.ReadInt(4)
	shoulddrawescape = nri
	esctime = CurTime() - timefromround
	lastescapegot = CurTime() + 20
	StartEndSound()
	SlowFadeBlink(5)
end)

net.Receive("ForcePlaySound", function(len)
	local sound = net.ReadString()
	surface.PlaySound(sound)
end)

net.Receive("UpdateRoundType", function(len)
	roundtype = net.ReadString()
	print("Current roundtype: " .. roundtype)
end)

net.Receive("SendRoundInfo", function(len)
	local infos = net.ReadTable()
	endinformation = {string.Replace(clang.lang_pldied, "{num}", tostring(infos.deaths)), string.Replace(clang.lang_descaped, "{num}", tostring(infos.descaped)), string.Replace(clang.lang_sescaped, "{num}", tostring(infos.sescaped)), string.Replace(clang.lang_rescaped, "{num}", tostring(infos.rescaped)), string.Replace(clang.lang_dcaptured, "{num}", tostring(infos.dcaptured)), string.Replace(clang.lang_rescorted, "{num}", tostring(infos.rescorted)), string.Replace(clang.lang_teleported, "{num}", tostring(infos.teleported)), string.Replace(clang.lang_snapped, "{num}", tostring(infos.snapped)), string.Replace(clang.lang_zombies, "{num}", tostring(infos.zombies))}
end)

net.Receive("RolesSelected", function(len)
	drawinfodelete = CurTime() + 25
	shoulddrawinfo = true
end)

net.Receive("PrepStart", function(len)
	cltime = net.ReadInt(8)
	chat.AddText(string.Replace(clang.preparing, "{num}", tostring(cltime)))
	StartTime()
	drawendmsg = nil
	timer.Destroy("SoundsOnRoundStart")
	timer.Create("SoundsOnRoundStart", 1, 1, SoundsOnRoundStart)
	timefromround = CurTime() + 10
	f_started = false
	RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
	--SAVEDIDS = {}
end)

net.Receive("RoundStart", function(len)
	cltime = net.ReadInt(12)
	chat.AddText(clang.round)
	StartTime()
	drawendmsg = nil
end)

net.Receive("PostStart", function(len)
	cltime = net.ReadInt(6)
	win = net.ReadInt(4)
	drawendmsg = win
	StartTime()
end)

hook.Add("OnPlayerChat", "CheckChatFunctions", function(ply, strText, bTeam, bDead)
	strText = string.lower(strText)
	if strText == "dropvest" then
		if ply == LocalPlayer() then DropCurrentVest() end
		return true
	end
end)

-- Blinking system
--if f_brightness == nil then
f_brightness = 0
f_fadein = 0.25
f_fadeout = 0.000075
f_end = 0
f_started = false
--end
function tick_flash()
	--if LocalPlayer().GTeam == nil then return end
	if shoulddrawinfo == true then
		if CurTime() > drawinfodelete then
			shoulddrawinfo = false
			drawinfodelete = 0
		end
	end

	if f_started == true then
		if CurTime() > f_end then
			f_brightness = f_brightness + f_fadeout
			if f_brightness < 0 then
				f_end = 0
				f_brightness = 0
				f_started = false
				--print("blink end")
			end
		else
			if f_brightness < 1 then f_brightness = f_brightness - f_fadein end
		end
	end
end

hook.Add("Tick", "htickflash", tick_flash)
material_173_1 = CreateMaterial("blinkGlow7", "UnlitGeneric", {
	["$basetexture"] = "particle/particle_glow_05",
	["$basetexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
	["$additive"] = 1,
	["$translucent"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$ignorez"] = 0
})

--[[
EntsToHighlight = {{}, 0}
net.Receive( "173HLentities", function( len )
	EntsToHighlight = {
		{net.ReadEntity()},
		CurTime()
	}
	PrintTable(EntsToHighlight)
end)
]]
local next_halo_check = 0
local players_to_highlight = {}
hook.Add("PreDrawHalos", "Halo173", function()
	if SERVER then return end
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then if isfunction(wep.PreDrawHalos) then wep:PreDrawHalos() end end
	if ply:GTeam() == TEAM_SCP then
		for i, v in pairs(players_to_highlight) do
			local pl = v[1]
			if CurTime() - v[2] > 10 then
				table.RemoveByValue(players_to_highlight, v)
				print("Removed " .. tostring(v[1]) .. " from players_to_highlight")
			elseif IsValid(pl) == false or pl:Alive() == false or pl:GTeam() == TEAM_SCP or pl:GTeam() == TEAM_SPEC then
				table.RemoveByValue(players_to_highlight, v)
				print("Removed " .. tostring(v[1]) .. " from players_to_highlight")
			end
		end

		if next_halo_check < CurTime() then
			next_halo_check = CurTime() + 2
			for k, v in pairs(player.GetAll()) do
				local tfscps = v:GetNWFloat("targetForSCPs", nil)
				if tfscps ~= nil then
					if CurTime() - tfscps < 11 then
						local found_pl = false
						for k2, v2 in pairs(players_to_highlight) do
							if v2[1] == v then found_pl = true end
						end

						if found_pl == false then
							print("Added " .. tostring(v) .. " to players_to_highlight")
							table.ForceInsert(players_to_highlight, {v, tfscps})
						end
					end
				end
			end
		end

		local tab_fixed = {}
		for k, v in pairs(players_to_highlight) do
			table.ForceInsert(tab_fixed, v[1])
		end

		halo.Add(tab_fixed, Color(255, 0, 0), 4, 4, 4, true, true)
	end
end)

function HandleFootstepsCL()
	for k, v in pairs(player.GetAll()) do
		local vel = math.Round(v:GetVelocity():Length())
		if v:GTeam() ~= TEAM_SPEC and v:GetMoveType() ~= 8 and v:GetMoveType() ~= 10 and v:GetMoveType() ~= 0 and vel > 25 and v:IsOnGround() then
			if v.nextstep == nil then v.nextstep = 0 end
			if v.nextstep > CurTime() then return true end
			local fvel = math.Clamp(1 - (vel / 100) / 3, 0.18, 2)
			v.nextstep = CurTime() + fvel
			local tr = util.TraceLine({
				start = v:GetPos(),
				endpos = v:GetPos() + Angle(90, 0, 0):Forward() * 10000
			})

			--v:PrintMessage(HUD_PRINTTALK, tr.MatType)
			local volume = 0.9
			local running = false
			local sound = ""
			volume = volume * ((vel / 100) / 3)
			if vel < 80 then
				volume = volume * 0.7
			elseif vel > 150 then
				volume = volume * 1.3
				running = true
			end

			local soundLevel = 70
			if not v.GetNClass then player_manager.RunClass(v, "SetupDataTables") end
			if not v.GetNClass then return end
			if v:GetNClass() == ROLES.ROLE_SCP966 then return true end
			if tr.MatType == MAT_DIRT or tr.MatType == MAT_GRASS then
				volume = volume * 0.35
				sound = "steps/StepForest" .. math.random(1, 3) .. ".mp3"
			else
				if v.UsingArmor ~= nil and string.find(v.UsingArmor, "mtf", 1, true) then
					sound = "steps/HeavyStep" .. math.random(1, 3) .. ".ogg"
				else
					if tr.MatType == MAT_METAL then
						if running == true then
							volume = volume * 0.55
							sound = "steps/RunMetal" .. math.random(1, 8) .. ".mp3"
						else
							volume = volume * 0.7
							sound = "steps/StepMetal" .. math.random(1, 8) .. ".mp3"
						end
					else
						if running == true then
							volume = volume * 0.55
							sound = "steps/Run" .. math.random(1, 8) .. ".mp3"
						else
							volume = volume * 0.7
							sound = "steps/Step" .. math.random(1, 8) .. ".mp3"
						end
					end
				end
			end

			local wep = v:GetActiveWeapon()
			if IsValid(wep) and wep:GetClass() == "weapon_scp_173" then
				sound = "173sound" .. math.random(1, 3) .. ".ogg"
				v.nextstep = CurTime() + math.random(2, 3)
			end

			EmitSound(sound, v:GetPos(), v:EntIndex(), CHAN_AUTO, math.Clamp(volume, 0, 1), soundLevel)
		end
	end
end

function CLTick()
	if postround == false and isnumber(drawendmsg) then drawendmsg = nil end
	if clang == nil then clang = english end
	HandleFootstepsCL()
end

hook.Add("Tick", "client_tick_hook", CLTick)
net.Receive("PlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

net.Receive("SlowPlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

function SlowFadeBlink(time)
	f_brightness = 0
	f_fadein = 0.0075
	f_fadeout = 0.0075
	f_started = true
	f_end = CurTime() + time
end

function Blink(time)
	f_brightness = 0
	f_fadein = 0.25
	f_fadeout = 0.000075
	f_started = true
	if LocalPlayer():GTeam() == TEAM_SCP then
		f_end = CurTime()
	else
		f_end = CurTime() + time
	end
	--print("blink start")
end

CreateClientConVar("br_vignette_enabled", "1", true, false, "Enable vignette")
last996attack = 0
function GM:RenderScreenspaceEffects()
	local contrast = 1.2
	local colour = 1
	local brightness = 0
	local clr_r = 0
	local clr_g = 0
	local clr_b = 0
	local bloommul = 0
	local vignette_alpha = 125
	last996attack = last996attack - 0.002
	if last996attack < 0 then
		last996attack = 0
	else
		DrawMotionBlur(1 - last996attack, 1, 0.05)
		DrawSharpen(last996attack, 2)
		contrast = last996attack
	end

	if CurTime() - last_capture_by_106 < 10 then DrawMotionBlur(0.2, 0.5, 0.05) end
	local nvg = nil
	for k, v in pairs(LocalPlayer():GetWeapons()) do
		if istable(v.NVG) then
			if v.NVGenabled == true then
				nvg = v.NVG
				contrast = contrast + nvg[1]
				colour = nvg[2]
				if nvg[3] < 0.7 then brightness = nvg[3] end
				clr_r = nvg[4]
				clr_g = nvg[5]
				clr_b = nvg[6]
				vignette_alpha = nvg[7]
				nvg[8]()
			end
		end
	end

	if f_started == true and LocalPlayer():GTeam() ~= TEAM_SCP then brightness = brightness + f_brightness end
	if LocalPlayer():Health() < 21 and LocalPlayer():Alive() then
		colour = math.Clamp((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 5, 0, 2)
		DrawMotionBlur(0.27, 0.5, 0.01)
		DrawSharpen(1, 2)
	end

	--DrawBloom( 0.65, bloommul, 9, 9, 1, 1, 1, 1, 1 )
	local tab = {
		--["$pp_colour_addr"] = 0.012,
		--["$pp_colour_addg"] = 0.012,
		--["$pp_colour_addb"] = 0.012,
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = brightness,
		["$pp_colour_contrast"] = contrast,
		["$pp_colour_colour"] = colour,
		["$pp_colour_mulr"] = clr_r,
		["$pp_colour_mulg"] = clr_g,
		["$pp_colour_mulb"] = clr_b
	}

	DrawColorModify(tab)
end

local br_spawnmenu_enabled = false
concommand.Add("enablespawnmenu", function()
	if LocalPlayer():IsSuperAdmin() == true then
		br_spawnmenu_enabled = not br_spawnmenu_enabled
		--print("br_spawnmenu_enabled: " .. tostring(br_spawnmenu_enabled))
		chat.AddText("br_spawnmenu_enabled: " .. tostring(br_spawnmenu_enabled))
	end
end)

local dropnext = 0
function GM:PlayerBindPress(ply, bind, pressed)
	--print(bind)
	--print(pressed)
	local ply = LocalPlayer()
	if bind == "+zoom" then
		if pressed == true then
			OpenMenu()
		else
			CloseMTFMenu()
		end
		return true
	elseif bind == "+menu" then
		if br_spawnmenu_enabled == false then
			if dropnext > CurTime() then return true end
			dropnext = CurTime() + 0.25
			--print("dropwep")
			net.Start("DropWeapon")
			net.SendToServer()
			if ply.channel ~= nil then
				ply.channel:EnableLooping(false)
				ply.channel:Stop()
				ply.channel = nil
			end
			return true
		end
	elseif bind == "gm_showteam" then
		OpenClassMenu()
		return true
		--elseif bind == "+menu_context" then
		--thirdpersonenabled = !thirdpersonenabled
		--if br_spawnmenu_enabled == false then return true end
	end
end

concommand.Add("br_requestescort", function()
	if not ((LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) or LocalPlayer():GTeam() == TEAM_CHAOS) then return end
	net.Start("RequestEscorting")
	net.SendToServer()
end)

concommand.Add("br_requestgatea", function()
	if not ((LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) or LocalPlayer():GTeam() == TEAM_CHAOS) then return end
	if LocalPlayer():CLevelGlobal() < 4 then return end
	net.Start("RequestGateA")
	net.SendToServer()
end)

concommand.Add("br_sound_random", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Random")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_searching", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Searching")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_classd", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Classd")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_stop", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Stop")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_lost", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Lost")
		net.SendToServer()
	end
end)

--[[
function CalcView3DPerson( ply, pos, angles, fov )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false
	if thirdpersonenabled then
		local eyepos = ply:EyePos()
		local eyeangles = ply:EyeAngles()
		local point = ply:GetEyeTrace().HitPos
		local goup = 2
		if ply:Crouching() then
			goup = 20
		end
		view.drawviewer = true
		view.origin = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 20)
		view.angles = (point - view.origin):Angle()
		local endps = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 15)
		local tr = util.TraceLine( { start = eyepos, endpos = endps} )
		if tr.Hit then
			view.origin = tr.HitPos
		end
	end
	return view
end
hook.Add( "CalcView", "CalcView3DPerson", CalcView3DPerson )
]]
print("cl_init loads")