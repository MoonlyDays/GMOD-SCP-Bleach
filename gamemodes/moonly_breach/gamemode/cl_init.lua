include("shared.lua")
include("fonts.lua")
include("class_default.lua")
include("sh_player.lua")
include("cl_mtfmenu.lua")
include("cl_scoreboard.lua")
include("cl_sounds.lua")
include("cl_targetid.lua")
include("other/cl_weaponmovement.lua")
include("other/cl_thirdperson.lua")
include("other/cl_chatsound.lua")
include("other/f4menu.lua")
include("other/cl_hud_mic_vc.lua")
surface.CreateFont("173font", {
    font = "TargetID",
    extended = false,
    size = 22,
    weight = 700,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
})

clang = nil
ALL_LANGUAGES = {}
local files, _ = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA")
for _, v in pairs(files) do
    local path = "languages/" .. v
    if string.Right(v, 3) == "lua" then
        include(path)
        print("Loading language: " .. path)
    end
end

langtouse = CreateClientConVar("br_language", "english", true, false):GetString()
cvars.AddChangeCallback("br_language", function(convar_name, value_old, value_new)
    langtouse = value_new
    if ALL_LANGUAGES[langtouse] then
        clang = ALL_LANGUAGES[langtouse]
    end
end)

print("langtouse:")
print(langtouse)
if ALL_LANGUAGES[langtouse] then
    clang = ALL_LANGUAGES[langtouse]
else
    clang = ALL_LANGUAGES.english
end

mapFile = "mapconfigs/" .. game.GetMap() .. ".lua"
include(mapFile)
include("cl_hud.lua")
RADIO4SOUNDSHC = { { "breach/radio/chatter1", 39 }, { "breach/radio/chatter2", 72 }, { "breach/radio/chatter4", 12 }, { "breach/radio/franklin1", 8 }, { "breach/radio/franklin2", 13 }, { "breach/radio/franklin3", 12 }, { "breach/radio/franklin4", 19 }, { "breach/radio/ohgod", 25 } }
RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
disablehud = false
livecolors = false
function DropCurrentVest()
    if LocalPlayer():Alive() and LocalPlayer():Team() ~= TEAM_SPECTATOR then
        net.Start("DropCurrentVest")
        net.SendToServer()
    end
end

concommand.Add("br_spectate", function(ply, cmd, args)
    net.Start("SpectateMode")
    net.SendToServer()
end)

concommand.Add("br_roundrestart_cl", function(ply, cmd, args)
    if ply:IsSuperAdmin() then
        net.Start("RoundRestart")
        net.SendToServer()
    end
end)

concommand.Add("br_dropvest", function(ply, cmd, args)
    DropCurrentVest()
end)
concommand.Add("br_livecolors", function(ply, cmd, args)
    local sweetfx_enabled = clang.SWEETFX_enabled
    local sweetfx_disabled = clang.SWEETFX_disabled
    if livecolors then
        livecolors = false
        chat.AddText(sweetfx_disabled)
    else
        livecolors = true
        chat.AddText(sweetfx_enabled)
    end
end)

gamestarted = false
cltime = 0
drawinfodelete = 0
shoulddrawinfo = false
drawendmsg = nil
timefromround = 0
timer.Create("HeartbeatSound", 2, 0, function()
    if not LocalPlayer().Alive then
        return
    end
    if LocalPlayer():Alive() and LocalPlayer():Team() ~= TEAM_SPECTATOR then
        if LocalPlayer():Health() < 30 then
            LocalPlayer():EmitSound("breach/misc/heartbeat.ogg")
        end
    end
end)

function OnUseEyedrops(ply)
end

function StartTime()
    timer.Destroy("UpdateTime")
    timer.Create("UpdateTime", 1, 0, function()
        if cltime > 0 then
            cltime = cltime - 1
        end
    end)
end

endinformation = {}
last_capture_by_106 = 0
net.Receive("CapturedBy106", function(len)
    --surface.PlaySound("breach/PocketDimension/Laugh.ogg")
    surface.PlaySound("breach/PocketDimension/Enter.ogg")
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
    endinformation = { string.Replace(clang.lang_pldied, "{num}", infos.deaths), string.Replace(clang.lang_descaped, "{num}", infos.descaped), string.Replace(clang.lang_sescaped, "{num}", infos.sescaped), string.Replace(clang.lang_rescaped, "{num}", infos.rescaped), string.Replace(clang.lang_dcaptured, "{num}", infos.dcaptured), string.Replace(clang.lang_rescorted, "{num}", infos.rescorted), string.Replace(clang.lang_teleported, "{num}", infos.teleported), string.Replace(clang.lang_snapped, "{num}", infos.snapped), string.Replace(clang.lang_zombies, "{num}", infos.zombies) }
    if infos.secretf == true then
        table.ForceInsert(endinformation, clang.lang_secret_found)
    else
        table.ForceInsert(endinformation, clang.lang_secret_nfound)
    end
end)

net.Receive("RolesSelected", function(len)
    drawinfodelete = CurTime() + 25
    shoulddrawinfo = true
end)

net.Receive("PrepStart", function(len)
    cltime = net.ReadInt(8)
    chat.AddText(string.Replace(clang.preparing, "{num}", cltime))
    StartTime()
    drawendmsg = nil
    hook457delete = CurTime() + 0.5
    hook.Add("Tick", "Stop457Sounds", function()
        if hook457delete ~= nil then
            if hook457delete < CurTime() then
                hook457delete = nil
                hook.Remove("Tick", "Stop457Sounds")
            end

            if LocalPlayer():GetNClass() == ROLE_SCP457 then
                RunConsoleCommand("stopsound")
            end
        end
    end)

    timer.Destroy("SoundsOnRoundStart")
    timer.Create("SoundsOnRoundStart", 1, 1, SoundsOnRoundStart)
    timefromround = CurTime() + 10
    RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
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
        if ply == LocalPlayer() then
            DropCurrentVest()
        end
        return true
    end
end)

-- Blinking system
local brightness = 0
local f_fadein = 0.25
local f_fadeout = 0.000075
local f_end = 0
local f_started = false
function tick_flash()
    if LocalPlayer().Team == nil then
        return
    end
    if LocalPlayer():Team() ~= TEAM_SPECTATOR then
        for k, v in pairs(ents.FindInSphere(OUTSIDE_SOUNDS, 300)) do
            if v == LocalPlayer() then
                StartOutisdeSounds()
            end
        end
    end

    if shoulddrawinfo then
        if CurTime() > drawinfodelete then
            shoulddrawinfo = false
            drawinfodelete = 0
        end
    end

    if f_started then
        if CurTime() > f_end then
            brightness = brightness + f_fadeout
            if brightness < 0 then
                f_end = 0
                brightness = 0
                f_started = false
                --print("blink end")
            end
        else
            if brightness < 1 then
                brightness = brightness - f_fadein
            end
        end
    end
end

hook.Add("Tick", "htickflash", tick_flash)
net.Receive("PlayerBlink", function(len)
    local time = net.ReadFloat()
    Blink(time)
end)

net.Receive("SlowPlayerBlink", function(len)
    local time = net.ReadFloat()
    Blink(time)
end)

function SlowFadeBlink(time)
    f_fadein = 0.0075
    f_fadeout = 0.0075
    f_started = true
    f_end = CurTime() + time
end

function Blink(time)
    f_fadein = 0.25
    f_fadeout = 0.000075
    f_started = true
    f_end = CurTime() + time
    --print("blink start")
end

local mat_color = Material("pp/colour") -- used outside of the hook for performance
hook.Add("RenderScreenspaceEffects", "blinkeffects", function()
    --if f_started == false then return end
    local contrast = 1
    local colour = 1
    if livecolors then
        contrast = 1.2
        colour = 1.6
    end

    if LocalPlayer():Health() < 30 and LocalPlayer():Alive() then
        colour = math.Clamp((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 5, 0, 2)
        DrawMotionBlur(0.27, 0.5, 0.01)
        DrawSharpen(1, 2)
        DrawToyTown(3, ScrH() / 1.8)
    end

    render.UpdateScreenEffectTexture()
    mat_color:SetTexture("$fbtexture", render.GetScreenEffectTexture())
    mat_color:SetFloat("$pp_colour_brightness", brightness)
    mat_color:SetFloat("$pp_colour_contrast", contrast)
    mat_color:SetFloat("$pp_colour_colour", colour)
    render.SetMaterial(mat_color)
    render.DrawScreenQuad()
end)

local dropnext = 0
function GM:PlayerBindPress(ply, bind, pressed)
    if bind == "+menu" then
        if dropnext > CurTime() then
            return true
        end
        dropnext = CurTime() + 0.5
        net.Start("DropWeapon")
        net.SendToServer()
        if LocalPlayer().channel ~= nil then
            LocalPlayer().channel:EnableLooping(false)
            LocalPlayer().channel:Stop()
            LocalPlayer().channel = nil
        end
        return true
    elseif bind == "+menu_context" then
        thirdpersonenabled = not thirdpersonenabled
    end
end

concommand.Add("br_requestescort", function()
    if not ((LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) or LocalPlayer():Team() == TEAM_CHAOS) then
        return
    end
    net.Start("RequestEscorting")
    net.SendToServer()
end)

concommand.Add("br_requestgatea", function()
    if not ((LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) or LocalPlayer():Team() == TEAM_CHAOS) then
        return
    end
    if LocalPlayer():CLevelGlobal() < 4 then
        return
    end
    net.Start("RequestGateA")
    net.SendToServer()
end)

concommand.Add("br_sound_random", function()
    if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
        net.Start("Sound_Random")
        net.SendToServer()
    end
end)

concommand.Add("br_sound_searching", function()
    if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
        net.Start("Sound_Searching")
        net.SendToServer()
    end
end)

concommand.Add("br_sound_classd", function()
    if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
        net.Start("Sound_Classd")
        net.SendToServer()
    end
end)

concommand.Add("br_sound_stop", function()
    if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
        net.Start("Sound_Stop")
        net.SendToServer()
    end
end)

concommand.Add("br_sound_lost", function()
    if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
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
		local endps = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 20) + (eyeangles:Right() * 15)
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