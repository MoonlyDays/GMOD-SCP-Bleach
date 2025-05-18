----------------------------------------
--        > guthscpvoice.lua <        --
--         >  MADE BY GUTHEN <        --
----------------------------------------
local enabled = true
if not enabled then return hook.Remove("HUDPaint", "guthscpvoice:VoiceIcon") end
local icon = Material("breach/microphone.png")
local talkers = {}
local time, ratio = 0, 0
hook.Add("HUDPaint", "guthscpvoice:VoiceIcon", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local should = hook.Run("HUDShouldDraw", "guthscpvoice:VoiceIcon")
    if should == false then return end
    ratio = Lerp(FrameTime() * 5, ratio, talkers[ply] and talkers[ply].desired_ratio or 0)
    if talkers[ply] and talkers[ply].ratio <= .05 and talkers[ply].desired_ratio <= 0 then
        talkers[ply] = nil
        return
    end

    time = time + FrameTime() * ratio
    local _, y = chat.GetChatBoxPos()
    surface.SetMaterial(icon)
    surface.SetDrawColor(Color(255, 255, 255, ratio * 255))
    surface.DrawTexturedRect(ScrW() - 100, y, 80, 80, (time * 500) % 360)
end)

local dist_sqr = 512 ^ 2
local offset = 20
hook.Add("PostPlayerDraw", "guthscpvoice:VoiceIcon", function(ply)
    if not IsValid(ply) then return end
    if not talkers[ply] then return end
    local should = hook.Run("HUDShouldDraw", "guthscpvoice:PostPlayerDraw")
    if should == false then return end
    if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > dist_sqr then return end
    talkers[ply].ratio = Lerp(FrameTime() * 3, talkers[ply].ratio, talkers[ply].desired_ratio)
    if talkers[ply].ratio <= .05 and talkers[ply].desired_ratio <= 0 then
        talkers[ply] = nil
        return
    end

    talkers[ply].time = talkers[ply].time + FrameTime() * talkers[ply].ratio
    --  position
    local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
    local pos = bone and ply:GetBonePosition(bone) + Vector(0, 0, offset) or ply:GetPos() + Vector(0, 0, 100)
    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    cam.Start3D2D(pos, Angle(0, ang.y, 90), .2)
    surface.SetMaterial(icon)
    surface.SetDrawColor(Color(255, 255, 255, talkers[ply].ratio * 255))
    surface.DrawTexturedRectRotated(5, 5, 60, 60, (talkers[ply].time * 100) % 360)
    cam.End3D2D()
end)

hook.Add("PlayerStartVoice", "guthscpvoice:HUD", function(ply)
    talkers[ply] = {
        ratio = 0,
        desired_ratio = 1,
        time = 0,
    }
end)

hook.Add("PlayerEndVoice", "guthscpvoice:HUD", function(ply) talkers[ply].desired_ratio = 0 end)