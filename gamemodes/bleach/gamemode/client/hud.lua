local hide = {
    CHudHealth = true,
    CHudBattery = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudDeathNotice = true
}

function GM:DrawDeathNotice(x, y)
end

hook.Add("HUDShouldDraw", "HideHUD", function(name)
    if hide[name] then
        return false
    end
end)

endmessages = {
    {
        main = clang.lang_end1,
        txt = clang.lang_end2,
        clr = gteams.GetColor(TEAM_SCP)
    },
    {
        main = clang.lang_end1,
        txt = clang.lang_end3,
        clr = gteams.GetColor(TEAM_SCP)
    }
}

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

hook.Add("Tick", "966check", function()
    local hide = true
    if LocalPlayer().GTeam == nil then
        return
    end
    if LocalPlayer():GTeam() == TEAM_SCP then
        hide = false
    end
    for k, v in pairs(LocalPlayer():GetWeapons()) do
        if istable(v.NVG) then
            if v.NVGenabled == true then
                hide = false
            end
        end
    end

    for k, v in pairs(player.GetAll()) do
        if not v.GetNClass then
            player_manager.RunClass(v, "SetupDataTables")
        end
        if v.GetNClass == nil then
            return
        end
        if v:GetNClass() == ROLES.ROLE_SCP966 then
            v:SetNoDraw(hide)
        end
    end
end)

local mat_gasmask = Material("breach/gasmask_overlay.png")
local info1 = Material("breach/info_mtf.png")
hook.Add("HUDPaint", "Breach_DrawHUD", function()
    for _, v in pairs(LocalPlayer():GetWeapons()) do
        if v.GasMaskOn == true then
            local mask_brightness = 100
            surface.SetDrawColor(mask_brightness, mask_brightness, mask_brightness, 255)
            surface.SetMaterial(mat_gasmask)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        end
    end

    if disablehud == true then
        return
    end
    for k, v in pairs(player.GetAll()) do
        if not v.GetNClass then
            player_manager.RunClass(v, "SetupDataTables")
        end
        if v.GetNClass == nil then
            return
        end
        if v:GetNClass() == ROLES.ROLE_SCP457 then
            local dlight = DynamicLight(v:EntIndex())
            if dlight then
                dlight.pos = v:GetShootPos()
                dlight.r = 165
                dlight.g = 100
                dlight.b = 10
                dlight.brightness = 1
                dlight.Decay = 1000
                dlight.Size = 256
                dlight.DieTime = CurTime() + 100
            end
        end
    end

    if shoulddrawinfo == true and LocalPlayer():Alive() and LocalPlayer():GTeam() ~= TEAM_SPECTATOR then
        local getrl = LocalPlayer():GetNClass()
        for k, v in pairs(ROLES) do
            if v == getrl then
                getrl = k
            end
        end

        for k, v in pairs(clang.starttexts) do
            if k == getrl then
                getrl = v
                break
            end
        end

        local align = 32
        local tcolor = gteams.GetColor(LocalPlayer():GTeam())
        if LocalPlayer():GTeam() == TEAM_CHAOS then
            tcolor = Color(29, 81, 56)
        end
        if getrl[1] ~= nil then
            draw.TextShadow({
                text = getrl[1],
                pos = { ScrW() / 2, ScrH() / 15 },
                font = "ImpactBig",
                color = tcolor,
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_CENTER,
            }, 2, 255)
        end

        for i, txt in ipairs(getrl[2]) do
            draw.TextShadow({
                text = txt,
                pos = { ScrW() / 2, ScrH() / 15 + 10 + (align * i) },
                font = "ImpactSmall",
                color = Color(255, 255, 255),
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_CENTER,
            }, 2, 255)
        end

        if roundtype ~= nil then
            draw.TextShadow({
                text = string.Replace(clang.roundtype, "{type}", roundtype),
                pos = { ScrW() / 2, ScrH() - 25 },
                font = "ImpactSmall",
                color = Color(255, 130, 0),
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_CENTER,
            }, 2, 255)
        end
    end

    if isnumber(drawendmsg) then
        local ndtext = clang.endmessages[drawendmsg]
        --print(drawendmsg)
        if clang.endmessages[drawendmsg] then
            shoulddrawinfo = false
            draw.TextShadow({
                text = clang.lang_round_end_main,
                pos = { 15, 15 },
                font = "ImpactBig",
                color = Color(0, 255, 0),
                xalign = TEXT_ALIGN_LEFT,
                yalign = TEXT_ALIGN_TOP,
            }, 2, 255)

            draw.TextShadow({
                text = ndtext,
                pos = { 15, 60 },
                font = "ImpactSmall",
                color = Color(255, 255, 255),
                xalign = TEXT_ALIGN_LEFT,
                yalign = TEXT_ALIGN_TOP,
            }, 2, 255)

            for i, txt in ipairs(endinformation) do
                draw.TextShadow({
                    text = txt,
                    pos = { 15, 95 + (35 * i) },
                    font = "ImpactSmall",
                    color = color_white,
                    xalign = TEXT_ALIGN_LEFT,
                    yalign = TEXT_ALIGN_TOP,
                }, 2, 255)
            end
        else
            drawendmsg = nil
        end
    else
        if isnumber(shoulddrawescape) then
            if CurTime() > lastescapegot then
                shoulddrawescape = nil
            end
            if clang.escapemessages[shoulddrawescape] then
                local tab = clang.escapemessages[shoulddrawescape]
                draw.TextShadow({
                    text = tab.main,
                    pos = { ScrW() / 2, ScrH() / 15 },
                    font = "ImpactBig",
                    color = tab.clr,
                    xalign = TEXT_ALIGN_CENTER,
                    yalign = TEXT_ALIGN_CENTER,
                }, 2, 255)

                draw.TextShadow({
                    text = string.Replace(tab.txt, "{t}", string.ToMinutesSecondsMilliseconds(esctime)),
                    pos = { ScrW() / 2, ScrH() / 15 + 45 },
                    font = "ImpactSmall",
                    color = Color(255, 255, 255),
                    xalign = TEXT_ALIGN_CENTER,
                    yalign = TEXT_ALIGN_CENTER,
                }, 2, 255)

                draw.TextShadow({
                    text = tab.txt2,
                    pos = { ScrW() / 2, ScrH() / 15 + 75 },
                    font = "ImpactSmall",
                    color = Color(255, 255, 255),
                    xalign = TEXT_ALIGN_CENTER,
                    yalign = TEXT_ALIGN_CENTER,
                }, 2, 255)
            end
        end
    end

    local ply = LocalPlayer()
    if ply:Alive() == false then
        return
    end
    if ply:GTeam() == TEAM_SPECTATOR then
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
                    pos = { sx + sw / 2, 15 },
                    font = "HealthAmmo",
                    color = Color(255, 255, 255),
                    xalign = TEXT_ALIGN_CENTER,
                    yalign = TEXT_ALIGN_CENTER,
                }, 2, 255)
            end
        end
        --return
    end

    local wep = nil
    local ammo = -1
    local ammo2 = -1
    local width = 350
    local height = 120
    local role_width = width - 25
    local x, y
    x = 10
    y = ScrH() - height - 10
    local hl = math.Clamp(LocalPlayer():Health(), 1, LocalPlayer():GetMaxHealth()) / LocalPlayer():GetMaxHealth()
    if hl < 0.06 then
        hl = 0.06
    end
    local name = "None"
    if not ply.GetNClass and ply.GetClassID then
        player_manager.RunClass(ply, "SetupDataTables")
    elseif LocalPlayer():GTeam() ~= TEAM_SPECTATOR then
        name = GetLangRole(ply:GetNClass())
    else
        local obs = ply:GetObserverTarget()
        if IsValid(obs) then
            if obs.GetNClass ~= nil then
                name = GetLangRole(obs:GetNClass())
                ply = obs
            else
                name = GetLangRole(ply:GetNClass())
            end
        else
            name = GetLangRole(ply:GetNClass())
        end
    end

    local color = gteams.GetColor(ply:GTeam()) or Color(255, 255, 255)
    if ply:GTeam() == TEAM_CHAOS then
        color = Color(29, 81, 56)
    end
    draw.RoundedBox(0, x, y, width, height, Color(0, 0, 10, 200))
    draw.RoundedBox(0, x, y, role_width - 70, 30, color)
    draw.TextShadow({
        text = name,
        pos = { role_width / 2 - 30, y + 12.5 },
        font = "ClassName",
        color = Color(255, 255, 255),
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    }, 2, 255)

    local tclr = Color(255, 255, 255)
    draw.TextShadow({
        text = tostring(string.ToMinutesSeconds(cltime)),
        pos = { width - 68, y + 4 },
        font = "TimeLeft",
        color = tclr,
        xalign = TEXT_ALIGN_TOP,
        yalign = TEXT_ALIGN_TOP,
    }, 2, 255)

    -- Health bar
    draw.RoundedBox(0, 25, y + 40, width - 30, 27, Color(50, 0, 0, 255))
    draw.RoundedBox(0, 25, y + 40, (width - 30) * hl, 27, Color(255, 0, 0, 255))
    draw.TextShadow({
        text = ply:Health(),
        pos = { width - 20, y + 40 },
        font = "HealthAmmo",
        color = Color(255, 255, 255),
        xalign = TEXT_ALIGN_RIGHT,
        yalign = TEXT_ALIGN_RIGHT,
    }, 2, 255)

    local ammotext = nil
    local wep = nil
    if ply:GetActiveWeapon() ~= nil and #ply:GetWeapons() > 0 then
        wep = ply:GetActiveWeapon()
        if wep then
            if wep.Clip1 == nil then
                return
            end
            if wep:Clip1() > -1 then
                ammo1 = wep:Clip1()
                ammo2 = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
                ammotext = ammo1 .. " + " .. ammo2
            end
        end
    end

    if not ammotext then
        return
    end
    local am = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1()) / wep:GetMaxClip1()
    draw.RoundedBox(0, 25, y + 75, width - 30, 27, Color(20, 20, 5, 222))
    draw.RoundedBox(0, 25, y + 75, (width - 30) * am, 27, Color(205, 155, 0, 255))
    draw.TextShadow({
        text = ammotext,
        pos = { width - 20, y + 75 },
        font = "HealthAmmo",
        color = Color(255, 255, 255),
        xalign = TEXT_ALIGN_RIGHT,
        yalign = TEXT_ALIGN_RIGHT,
    }, 2, 255)
end)