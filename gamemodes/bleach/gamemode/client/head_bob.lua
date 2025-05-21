local HBAP = 0
local HBAY = 0
local HBAR = 0
local HBPX = 0
local HBPY = 0
local HBPZ = 0
local headBobEnabled = true

function CalcHeadBob(ply, pos, ang, fov)
    if not headBobEnabled then
        return
    end

    if ply:Team() == TEAMS.SPECTATOR then
        return
    end

    local view = {}
    view.pos = pos
    view.ang = ang
    view.fov = fov

    local speedMul = (ply:GetVelocity():Length() / 100) / 3
    if ply:IsOnGround() then
        if ply:KeyDown(IN_FORWARD) then
            if HBAP < 1.5 then
                HBAP = HBAP + 0.05 * speedMul
            end
        else
            if HBAP > 0 then
                HBAP = HBAP - 0.05 * speedMul
            end
        end

        if ply:KeyDown(IN_BACK) then
            if HBAP > -1.5 then
                HBAP = HBAP - 0.05 * speedMul
            end
        else
            if HBAP < 0 then
                HBAP = HBAP + 0.05 * speedMul
            end
        end

        if ply:KeyDown(IN_MOVELEFT) then
            if HBAR > -1.5 then
                HBAR = HBAR - 0.07 * speedMul
            end
        else
            if HBAR < 0 then
                HBAR = HBAR + 0.07 * speedMul
            end
        end

        if ply:KeyDown(IN_MOVERIGHT) then
            if HBAR < 1.5 then
                HBAR = HBAR + 0.07 * speedMul
            end
        else
            if HBAR > 0 then
                HBAR = HBAR - 0.07 * speedMul
            end
        end
    end

    view.ang.pitch = view.ang.pitch + HBAP * speedMul
    view.ang.roll = view.ang.roll + HBAR * 0.9 * speedMul
    view.pos.z = view.pos.z

    return GAMEMODE:CalcView(ply, view.pos, view.ang, view.fov)
end

hook.Add("CalcView", "HeadBobbing", CalcHeadBob)

concommand.Add("br_headbobbing", function(ply)
    if headBobEnabled then
        print("Head Bobbing disabled")
        headBobEnabled = false
    else
        print("Head Bobbing enabled")
        headBobEnabled = true
    end
end)