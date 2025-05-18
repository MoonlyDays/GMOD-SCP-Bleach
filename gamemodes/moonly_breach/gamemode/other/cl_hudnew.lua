---  Guthen's SCP HUD
---  version: 2.0.0
---  Dragon4k Edit 06.07.2023
local COMMAND_PREFIX = "guthscphud_"
local IS_BREACH_GAMEMODE = engine.ActiveGamemode() == "classic_breach_update"
local convar_breach_blinkdelay, last_breach_blink
if IS_BREACH_GAMEMODE then
	convar_breach_blinkdelay = GetConVar("br_time_blinkdelay")
	--  override blink net
	local function override_blink_net()
		net.Receive("PlayerBlink", function()
			--  Breach code
			local time = net.ReadFloat()
			Blink(time)
			--  reset blink time
			if LocalPlayer():Team() == TEAM_SCP then --  since Blink function ignore SCPs, we do the same
				last_breach_blink = nil
			else
				last_breach_blink = CurTime()
			end
		end)
	end

	hook.Add("PostGamemodeLoaded", "guthscphud:breach_blink_hud", override_blink_net)
	override_blink_net()
end

local enabled = true
local materials = {
	blink = Material("guthen_scp_hud/blinkicon.png"),
	health = Material("guthen_scp_hud/healthicon.png"),
	body = Material("guthen_scp_hud/bodyicon.png"),
	job = Material("guthen_scp_hud/jobicon.png"),
	time = Material("guthen_scp_hud/timeicon.png"),
	ammo = Material("guthen_scp_hud/ammoicon.png"),
	white_bar = Material("guthen_scp_hud/whitebar.jpg"),
	black_bar = Material("guthen_scp_hud/blackbar.jpg"),
}

--  auto-update convars
local function scale_and_floor(x, scale)
	return math.floor(x * scale)
end

local auto_convars = {
	--  position
	x = {
		default = 2.5,
		min = 0,
		max = 100,
		text = "In percent, how much screen-width should the horizontal padding occupies?",
		value = function(x) return ScrW() * x * 0.01 end,
	},
	y = {
		default = 5,
		min = 0,
		max = 100,
		text = "In percent, how much screen-height should the vertical padding occupies?",
		value = function(x) return ScrH() * (1.0 - x * 0.01) end,
	},
	scale = {
		default = 6,
		min = 1,
		max = 100,
		text = "Viewport scale for the HUD, affects most variables",
		value = function(x) return ScrW() * x * 0.0001 end,
	},
	outline_padding = {
		default = 3,
		text = "In pixels, how much padding should we let for the outline?",
		value = scale_and_floor,
	},
	font = {
		default = "TargetID",
		text = "Text font",
	},
	font_scale = {
		default = 0.9,
		text = "Text scale",
	},
	anim_speed = {
		default = 6,
		min = 1,
		max = 100,
		text = "Speed of change for all progress bars",
	},
	--  bar
	icon_size = {
		default = 32,
		text = "In pixels, the size of bar icons",
		value = scale_and_floor,
	},
	bar_inner_margin = {
		default = 10,
		text = "In pixels, how big the margin between the icon and its linked bar should be?",
		value = scale_and_floor,
	},
	bar_margin_vertical = {
		default = 22,
		text = "In pixels, how much the vertical margin between each info-bar should be?",
		value = scale_and_floor,
	},
	bar_margin_horizontal = {
		default = 20,
		text = "In pixels, how much the horizontal margin between each info-bar should be?",
		value = scale_and_floor,
	},
	bar_width = {
		default = 8,
		text = "In pixels, how wide the individual bar sprite should be?",
		value = scale_and_floor,
	},
	bar_height = {
		default = 14,
		text = "In pixels, how tall the individual bar sprite should be?",
		value = scale_and_floor,
	},
	bar_spacing = {
		default = 3,
		text = "In pixels, how big the gap between each individual bars should be?",
		value = scale_and_floor,
	},
	bar_count = {
		default = 16,
		min = 3,
		max = 50,
		text = "Number of individual bars to show for progress bars",
	},
}

local config = {}
local function get_autoconvar_value(name)
	local data = auto_convars[name]
	assert(data ~= nil and data.convar, ("guthscphud: auto-convar %q wasn't found!"):format(name))
	--  get value depending on type
	local value = nil
	if isnumber(data.default) then
		--  compute custom value
		value = data.convar:GetFloat()
		if data.value then value = data.value(value, config.scale) end
	else
		value = data.convar:GetString()
	end
	return value
end

concommand.Add(COMMAND_PREFIX .. "reset", function()
	local count = 0
	for k, v in pairs(auto_convars) do
		v.convar:Revert()
		count = count + 1
	end

	print(("Reset %d convars from GuthSCP HUD"):format(count))
end)

--  update config
local function update_config()
	config.scale = get_autoconvar_value("scale")
	--  evaluate config
	for k, v in pairs(auto_convars) do
		if k == "scale" then continue end
		config[k] = get_autoconvar_value(k)
	end

	--  pre-compute
	config.full_bar_width = config.bar_width * config.bar_count + config.bar_spacing * (config.bar_count - 1) + config.outline_padding * 2
	config.full_bar_height = config.bar_height + config.outline_padding * 2
	config.full_bar_inner_padding = config.icon_size + config.outline_padding * 2 + config.bar_inner_margin
end

hook.Add("OnScreenSizeChanged", "guthscphud:update_config", update_config)
--  create auto-convars
for k, v in pairs(auto_convars) do
	local name = COMMAND_PREFIX .. k
	v.convar = CreateClientConVar(name, v.default, true, false, v.text, v.min, v.max)
	cvars.AddChangeCallback(name, update_config, "guthscphud:update_config")
end

update_config()
--  convars
convar_show_job_name = CreateClientConVar(COMMAND_PREFIX .. "show_job_name", "1", true, true, "Show job & Name of SCP HUD : 1 = Enable, 0 = Disable")
--  utility functions
local color = color_white
local function draw_icon(material, x, y)
	--  draw outline
	local outline_size = config.icon_size + config.outline_padding * 2
	surface.DrawOutlinedRect(x - config.outline_padding, y - config.outline_padding, outline_size, outline_size)
	--  draw icon
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, config.icon_size, config.icon_size)
end

local function draw_num_bar(icon, material, num, x, y)
	--  draw icon
	draw_icon(icon, x, y)
	x = x + config.full_bar_inner_padding
	--  draw outline
	local spacing = config.bar_width + config.bar_spacing
	surface.DrawOutlinedRect(x - config.outline_padding, y - config.outline_padding, config.full_bar_width, config.full_bar_height)
	--  draw bars
	if num > 0 then
		surface.SetMaterial(material)
		for i = 1, num do
			surface.DrawTexturedRect(x + (i - 1) * spacing, y, config.bar_width, config.bar_height)
		end
	end
end

local vector_one = Vector(1, 1, 1)
local function draw_string_bar(icon, text, x, y)
	--  draw icon
	draw_icon(icon, x, y)
	x = x + config.full_bar_inner_padding
	--  draw outline
	surface.DrawOutlinedRect(x - config.outline_padding, y - config.outline_padding, config.full_bar_width, config.full_bar_height)
	local offset = Vector(x, y + config.bar_height * .5, 0)
	local matrix = Matrix()
	matrix:Translate(offset)
	matrix:Scale(vector_one * math.Round(config.scale * config.font_scale, 1))
	matrix:Translate(-offset)
	--  draw text
	cam.PushModelMatrix(matrix)
	draw.SimpleText(text, config.font, x, y + config.bar_height * .5, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	cam.PopModelMatrix()
end

local function lerp_to_bar_value(value, target)
	return math.min(Lerp(FrameTime() * config.anim_speed, value, target * config.bar_count), config.bar_count)
end

--  draw hud
local x, y = 0, 0
local health, armor, ammo = 0, 0, 0
local function next_row()
	y = y - (config.icon_size + config.bar_margin_vertical)
end

local function next_column()
	x = x + config.full_bar_width + config.full_bar_inner_padding + config.bar_margin_horizontal
	y = config.y - config.icon_size
end

local function draw_blink()
	--  find compatibilities
	local has_found = true
	local blink = 0.0
	--  breach gamemode
	if IS_BREACH_GAMEMODE then
		if last_breach_blink then blink = 1.0 - (CurTime() - last_breach_blink) / convar_breach_blinkdelay:GetFloat() end
	else
		has_found = false
	end

	if not has_found then return end
	--  draw blink
	next_row()
	draw_num_bar(materials.blink, materials.white_bar, math.Round(blink * config.bar_count), x, y)
end

hook.Add("HUDPaint", "guthscphud:draw", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	--if ply:Team() == TEAM_SPECTATOR then return end
	surface.SetDrawColor(color)
	--  coordinates
	x, y = config.x, config.y - config.icon_size
	--  ammo
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon:GetPrimaryAmmoType() > -1 then
		ammo = lerp_to_bar_value(ammo, weapon:Clip1() / weapon:GetMaxClip1())
		draw_num_bar(materials.ammo, materials.black_bar, math.Round(ammo), ScrW() - config.x - config.full_bar_width - config.full_bar_inner_padding, y)
	end

	--  health
	health = lerp_to_bar_value(health, ply:Alive() and ply:Health() / ply:GetMaxHealth() or 0)
	draw_num_bar(materials.health, materials.black_bar, math.Round(health), x, y)
	--  scp-173 blink
	draw_blink()
	--  breach round time
	if IS_BREACH_GAMEMODE then
		next_row()
		local time = tostring(string.ToMinutesSeconds(cltime))
		draw_string_bar(materials.time, time, x, y)
	end

	--  name & job
	if convar_show_job_name:GetBool() then
		next_column()
		--  draw job
		local job = "[DATA EXPUNGED]"
		if IS_BREACH_GAMEMODE then job = GetLangRole(ply:GetNClass()) end
		draw_string_bar(materials.job, job, x, y)
	end
end)

--  remove defaults huds
local remove_huds = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudAmmo"] = true,
	["CHudDeathNotice"] = true,
}

hook.Add("HUDShouldDraw", "guthscphud:remove_defaults", function(name) if remove_huds[name] then return false end end)
if not enabled then
	hook.Remove("HUDPaint", "guthscphud:draw")
	hook.Remove("HUDShouldDraw", "guthscphud:remove_defaults")
end

-- CODE FROM BREACH --
surface.CreateFont("ImpactBig", {
	font = "Impact",
	size = 45,
	weight = 700
})

surface.CreateFont("ImpactSmall", {
	font = "Impact",
	size = 30,
	weight = 700
})

-- RADIO
surface.CreateFont("RadioFont", {
	font = "Impact",
	extended = false,
	size = 26,
	weight = 7000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

function GM:DrawDeathNotice(x, y)
end

function Getrl()
	local rl = LocalPlayer():GetNClass()
	if LocalPlayer():Team() == TEAM_CHAOS then
		if roundtype == "Trouble in SCP Town" then
			return 12
		elseif roundtype == "Assault" then
			return 13
		else
			return 11
		end
	end

	if rl == ROLE_SCP173 then return 1 end
	if rl == ROLE_SCP106 then return 2 end
	if rl == ROLE_SCP049 then return 3 end
	if rl == ROLE_SCP457 then return 15 end
	if rl == ROLE_SCP035 then return 14 end
	if rl == ROLE_MTFGUARD then
		if roundtype == "Trouble in SCP Town" then
			return 5
		elseif roundtype == "Zombie Plague" then
			return 16
		else
			return 4
		end
	end

	if rl == ROLE_MTFCOM then return 6 end
	if rl == ROLE_MTFNTF then return 7 end
	if rl == ROLE_CLASSD then return 8 end
	if rl == ROLE_RES then return 9 end
	if rl == ROLE_SCP0492 then return 10 end
	if rl == ROLE_SPEC then return 18 end
	if rl == ROLE_SCP0082 then return 17 end
	return 18
end

endmessages = {
	{
		main = clang.lang_end1,
		txt = clang.lang_end2,
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = clang.lang_end1,
		txt = clang.lang_end3,
		clr = team.GetColor(TEAM_SCP)
	}
}

function DrawInfo(pos, txt, clr)
	pos = pos:ToScreen()
	draw.TextShadow({
		text = txt,
		pos = {pos.x, pos.y},
		font = "HealthAmmo",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}, 2, 255)
end

local info1 = Material("breach/info_mtf.png")
hook.Add("HUDPaint", "Breach_DrawHUD", function()
	if disablehud == true then return end
	if POS_914B_BUTTON ~= nil and isstring(buttonstatus) then if LocalPlayer():GetPos():Distance(POS_914B_BUTTON) < 200 then DrawInfo(POS_914B_BUTTON, buttonstatus, Color(255, 255, 255)) end end
	if shoulddrawinfo == true then
		local getrl = Getrl()
		local align = 32
		local tcolor = team.GetColor(LocalPlayer():Team())
		if LocalPlayer():Team() == TEAM_CHAOS then tcolor = Color(29, 81, 56) end
		draw.TextShadow({
			text = clang.starttexts[getrl][1],
			pos = {ScrW() / 2, ScrH() / 15},
			font = "ImpactBig",
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255)

		for i, txt in ipairs(clang.starttexts[getrl][2]) do
			draw.TextShadow({
				text = txt,
				pos = {ScrW() / 2, ScrH() / 15 + 10 + (align * i)},
				font = "ImpactSmall",
				color = Color(255, 255, 255),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255)
		end

		if roundtype ~= nil then
			draw.TextShadow({
				text = string.Replace(clang.roundtype, "{type}", roundtype),
				pos = {ScrW() / 2, ScrH() - 25},
				font = "ImpactSmall",
				color = Color(255, 130, 0),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255)
		end
	end

	if isnumber(drawendmsg) then
		local ndtext = clang.lang_end2
		if drawendmsg == 2 then ndtext = clang.lang_end3 end
		--if clang.endmessages[drawendmsg] then
		shoulddrawinfo = false
		draw.TextShadow({
			text = clang.lang_end1,
			pos = {ScrW() / 2, ScrH() / 15},
			font = "ImpactBig",
			color = Color(0, 255, 0),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255)

		draw.TextShadow({
			text = ndtext,
			pos = {ScrW() / 2, ScrH() / 15 + 45},
			font = "ImpactSmall",
			color = Color(255, 255, 255),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255)

		for i, txt in ipairs(endinformation) do
			draw.TextShadow({
				text = txt,
				pos = {ScrW() / 2, ScrH() / 8 + (35 * i)},
				font = "ImpactSmall",
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255)
		end
		--else
		--	drawendmsg = nil
		--end
	else
		if isnumber(shoulddrawescape) then
			if CurTime() > lastescapegot then shoulddrawescape = nil end
			if clang.escapemessages[shoulddrawescape] then
				local tab = clang.escapemessages[shoulddrawescape]
				draw.TextShadow({
					text = tab.main,
					pos = {ScrW() / 2, ScrH() / 15},
					font = "ImpactBig",
					color = tab.clr,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255)

				draw.TextShadow({
					text = string.Replace(tab.txt, "{t}", string.ToMinutesSecondsMilliseconds(esctime)),
					pos = {ScrW() / 2, ScrH() / 15 + 45},
					font = "ImpactSmall",
					color = Color(255, 255, 255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255)

				draw.TextShadow({
					text = tab.txt2,
					pos = {ScrW() / 2, ScrH() / 15 + 75},
					font = "ImpactSmall",
					color = Color(255, 255, 255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255)
			end
		end
	end

	local ply = LocalPlayer()
	if ply:Alive() == false then return end
	if ply:Team() == TEAM_SPECTATOR then
		local ent = ply:GetObserverTarget()
		if IsValid(ent) then
			if ent:IsPlayer() then
				local sw = 350
				local sh = 35
				local sx = ScrW() / 2 - (sw / 2)
				local sy = 0
				draw.RoundedBox(0, sx, sy, sw, sh, Color(50, 50, 50, 255))
				draw.TextShadow({
					text = string.sub(ent:Nick(), 1, 17),
					pos = {sx + sw / 2, 15},
					font = "HealthAmmo",
					color = Color(255, 255, 255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255)
			end
		end
	end
end)

print("Guthen's SCP HUD loaded !")