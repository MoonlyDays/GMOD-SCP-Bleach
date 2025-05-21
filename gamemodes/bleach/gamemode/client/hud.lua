HUD = {
    hideHud = {
        CHudHealth = true,
        CHudBattery = true,
        CHudAmmo = true,
        CHudSecondaryAmmo = true,
        CHudDeathNotice = true
    },

    objectiveTextVisible = false,
    roundSummaryVisible = false,

    roundSummary = {},

    blackoutScreenUntil = nil,
    blackoutScreenFadeSpeed = nil,
    blackoutScreenCurrent = 0,
    blackoutScreenTarget = 0
}

function HUD:BlackoutScreen(howMuch, blackoutTime, fadeSpeed)
    self.blackoutScreenAmount = howMuch
    self.blackoutScreenFadeSpeed = fadeSpeed
    self.blackoutScreenUntil = CurTime() + blackoutTime
end

function HUD:Draw()
    local ply = LocalPlayer()

    self:DrawBlackout()
    self:DrawPlayerStatus(ply)
end

function HUD:DrawBlackout()
    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255 * self.blackoutScreenAmount))
end

function HUD:DrawPlayerStatus(ply)
    local teamIndex = ply:Team();
    local roleName = ply:GetRole();
    local role = ROLES[roleName];
    local roleTitle = role and role.Title or team.GetName(teamIndex)

    local x = 10
    local y = ScrH() - 10 - height

    -- Team Name
    draw.RoundedBox(5, x, y, width, height, Color(0, 0, 10, 200))
    draw.ProgressBar(0, x, y,
            width - 120, 40,
            0, roleTitle, "ClassName",
            team.GetColor(teamIndex), Color(0, 0, 0)
    )

    local timeRemaining = math.Max(timerEndsAt - CurTime(), 0);

    draw.TextShadow({
        text = tostring(string.ToMinutesSeconds(timeRemaining)),
        pos = { width - 50, y + 21 },
        font = "TimeLeft",
        color = tclr,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    if ply:Alive() then
        draw.ProgressBar(5, x + 10, y + 60,
                width - 20, 30,
                0, ply:Health() .. " %", "HealthAmmo",
                Color(255, 0, 0), Color(0, 0, 0)
        )

        draw.ProgressBar(5, x + 10, y + 100,
                width - 20, 30,
                0, "Выносливость", "HealthAmmo",
                Color(100, 100, 170), Color(0, 0, 0)
        )
        draw.ProgressBar(5, x + 10, y + 140,
                width - 20, 30,
                0, "10 (+10)", "HealthAmmo",
                Color(190, 140, 0), Color(0, 0, 0)
        )
    end
end

hook.Add("HUDPaint", "DrawBreachHUD", function()
    HUD:Draw()
end)

hook.Add("HUDShouldDraw", "HideHUD", function(name)
    if HUD.hideHud[name] then
        return false
    end
end)
