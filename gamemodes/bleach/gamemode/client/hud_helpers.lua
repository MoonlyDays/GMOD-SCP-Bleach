function draw.ProgressBar(radius, x, y, width, height, percentage, text, font, colorBg, colorFg)
    draw.RoundedBox(radius, x, y, width, height, colorFg)
    draw.RoundedBox(radius, x, y, width * percentage, height, colorBg)
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