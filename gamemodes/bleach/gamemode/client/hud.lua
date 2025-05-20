local hideHud = {
    CHudHealth = true,
    CHudBattery = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudDeathNotice = true
}

function GM:DrawDeathNotice()
end

hook.Add("HUDShouldDraw", "HideHUD", function(name)
    if hideHud[name] then
        return false
    end
end)

hook.Add("HUDPaint", "Breach_DrawHUD", function()

    local ply = LocalPlayer();
    draw.PlayerStatusBox(ply, 450, 190)
end)

function draw.PlayerStatusBox(ply, width, height)
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

function draw.ProgressBar(radius, x, y, width, height, percentage, text, font, colorBg, colorFg)
    draw.RoundedBox(radius, x, y, width, height, colorBg)
    draw.RoundedBox(radius, x, y, width * percentage, height, colorFg)
    draw.TextShadow({
        text = text,
        pos = { width / 2 + 15, y + height / 2 - 1 },
        font = font,
        color = Color(255, 255, 255),
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)
end

function draw.Circle(x, y, radius, seg, fraction)
    local cir = {}
    table.insert(cir, {
        x = x,
        y = y,
        u = 0.5,
        v = 0.5
    })

    for i = 0, seg do
        local a = math.rad((i / seg) * -fraction)
        table.insert(cir, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })
    end

    local a = math.rad(0) -- This is needed for non absolute segment counts
    table.insert(cir, {
        x = x + math.sin(a) * radius,
        y = y + math.cos(a) * radius,
        u = math.sin(a) / 2 + 0.5,
        v = math.cos(a) / 2 + 0.5
    })

    surface.DrawPoly(cir)
end

function DrawInfo(pos, txt, clr)
    pos = pos:ToScreen()
    draw.TextShadow({
        text = txt,
        pos = { pos.x, pos.y },
        font = "HealthAmmo",
        color = clr,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)
end

function DrawRectInfo(pos1, pos2, clr)
    render.SetColorMaterial()
    render.DrawBox(Vector(0, 0, 0), Angle(0, 0, 0), pos1, pos2, clr, true)
end