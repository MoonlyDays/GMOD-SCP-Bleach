HUD = HUD or {
    hideHud = {
        CHudHealth = true,
        CHudBattery = true,
        CHudAmmo = true,
        CHudSecondaryAmmo = true,
        CHudDeathNotice = true
    },

    roundState = ROUND_STATES.WAITING_FOR_PLAYERS,
    timeRemaining = 0,
    objectiveTextVisible = false,
    roundSummary = nil,
    roundEndReason = "",
    stamina = MAX_STAMINA,

    blinkTimer = 0,
    currentBlackoutPriority = 0,
    blackoutScreenFadeSpeed = 0,
    blackoutScreenCurrent = 0,
    blackoutScreenTarget = 0
}

function HUD:BlackoutScreen(priority, howMuch, blackoutTime, fadeInSpeed, fadeOutSpeed)
    if priority < self.currentBlackoutPriority then
        return
    end

    self.blackoutScreenTarget = howMuch
    self.blackoutScreenFadeSpeed = fadeInSpeed
    self.currentBlackoutPriority = 0

    if fadeInSpeed <= 0 then
        self.blackoutScreenCurrent = howMuch
    end

    if blackoutTime > 0 then
        self.currentBlackoutPriority = priority
        timer.Create("BlackoutTime", blackoutTime, 1, function()
            self:BlackoutScreen(self.currentBlackoutPriority, 0, 0, fadeOutSpeed)
        end)
    end
end

function HUD:Draw()
    local ply = LocalPlayer()

    self:PostProcess()
    self:DrawBlackout()
    self:DrawPlayerStatus(ply, 450, 190)
    self:DrawObjective(ply)
    self:DrawRoundSummary(ply)
end

function GM:DrawDeathNotice()
end

function HUD:DrawObjective(ply)
    if not self.objectiveTextVisible then
        return
    end

    local role = ply:Role()
    if not role then
        return
    end

    draw.TextShadow({
        text = "Вы " .. role.Title,
        pos = { ScrW() / 2, 100 },
        font = "ImpactBig",
        color = team.GetColor(ply:Team()),
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    local y = 110
    local align = 32
    for i, txt in pairs(role.Objective) do
        draw.TextShadow({
            text = txt,
            pos = { ScrW() / 2, y + (align * i) },
            font = "ImpactSmall",
            color = Color(255, 255, 255),
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
        }, 2, 255)
    end
end

function HUD:PostProcess()
end

function HUD:DrawRoundSummary(ply)
    if not self.roundSummary then
        return
    end

    draw.TextShadow({
        text = "Игра Окончена!",
        pos = { ScrW() / 2, 100 },
        font = "ImpactBig",
        color = Color(255, 0, 0),
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    draw.TextShadow({
        text = HUD.roundEndReason,
        pos = { ScrW() / 2, 150 },
        font = "ImpactSmall",
        color = Color(255, 150, 150),
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    local stats = {
        { "Погибло {num} игроков", STATS.PLAYERS_DIED },
        { "Сбежало {num} классов D", STATS.CLASS_D_ESCAPED },
        { "Сбежало {num} SCP", STATS.SCP_ESCAPED },
        { "Сбежало {num} сотрудников комплекса", STATS.STAFF_ESCAPED },
        { "SCP-106 захватил {num} жертв в Карманное Измерение", STATS.SCP_106_CAPTURED },
        { "{num} щей были сломаны руками SCP-173", STATS.SCP_173_SNAPPED },
        { "SCP-049 \"излечил\" {num} пациентов", STATS.SCP_049_CURED },
        { "SCP-1987 сделал 87 укусов {num} целям", STATS.SCP_1987_BIT }
    }

    for i, stat in pairs(stats) do
        draw.TextShadow({
            text = string.Replace(stat[1], "{num}", tostring(self.roundSummary[stat[2]])),
            pos = { ScrW() / 2, 180 + i * 40 },
            font = "ImpactSmall",
            color = Color(255, 255, 255),
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
        }, 2, 255)
    end
end

function HUD:DrawBlackout()
    if self.blackoutScreenCurrent ~= self.blackoutScreenTarget then
        self.blackoutScreenCurrent = Approach(
                self.blackoutScreenCurrent,
                self.blackoutScreenTarget,
                FrameTime() * self.blackoutScreenFadeSpeed
        )
    end

    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255 * self.blackoutScreenCurrent))
end

function HUD:DrawPlayerStatus(ply, width, height)
    local teamIndex = ply:Team();
    local role = ply:Role();
    local roleTitle = role and role.Title or team.GetName(teamIndex)

    local x = 10
    local y = ScrH() - 10 - height

    local colorBg = Color(0, 0, 10, 200)
    local roleWidth = width - 120
    local roleHeight = 40

    -- Team Name

    if ply:IsPlaying() and ply:CanBlink() then
        if self.blinkTimer > 0 then
            self.blinkTimer = self.blinkTimer - FrameTime()
        end

        draw.RoundedBox(0, x, y - 5, width, 10, colorBg)
        draw.RoundedBox(0, x, y - 5, Fraction(self.blinkTimer, br_time_blink_delay:GetInt()) * width, 5, Color(255, 255, 255))
    end

    draw.RoundedBox(0, x, y, width, height, colorBg)
    draw.RoundedBox(0, x, y, width, roleHeight, colorBg)
    draw.RoundedBox(0, x, y, roleWidth, roleHeight, team.GetColor(teamIndex))
    draw.TextShadow({
        text = roleTitle,
        pos = { x + roleWidth / 2, y + roleHeight / 2 },
        font = "ClassName",
        color = Color(255, 255, 255),
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    draw.TextShadow({
        text = tostring(string.ToMinutesSeconds(self.timeRemaining)),
        pos = { width - 50, y + 21 },
        font = "TimeLeft",
        color = tclr,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    if ply:Alive() and ply:Team() ~= TEAMS.SPECTATOR then
        draw.ProgressBar(3, x + 10, y + 60,
                width - 20, 30,
                Fraction(ply:Health(), ply:GetMaxHealth()), ply:Health() .. " HP", "HealthAmmo",
                Color(255, 0, 0), colorBg
        )

        draw.ProgressBar(3, x + 10, y + 100,
                width - 20, 30,
                Fraction(self.stamina, MAX_STAMINA), Percent(self.stamina, MAX_STAMINA), "HealthAmmo",
                Color(100, 100, 170), colorBg
        )

        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep:GetMaxClip1() > 0 then
            draw.ProgressBar(3, x + 10, y + 140,
                    width - 20, 30,
                    Fraction(wep:Clip1(), wep:GetMaxClip1()), wep:Clip1() .. " (+" .. ply:GetAmmoCount(wep:GetPrimaryAmmoType()) .. ")", "HealthAmmo",
                    Color(190, 140, 0), colorBg
            )
        end
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
