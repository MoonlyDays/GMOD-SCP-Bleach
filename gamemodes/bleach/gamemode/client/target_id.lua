local filterEnts = {}

function GM:HUDDrawTargetID()
    if true then
        return false
    end
    local client = LocalPlayer()

    if not trace.Hit then
        return
    end
    if not trace.HitNonWorld then
        return
    end
    local text = clang.class_unknown or "Unknown"
    local font = "TargetID"
    local ply = trace.Entity
    local clr = color_white
    local clr2 = color_white
    if ply:IsPlayer() then
        if not ply.GetNClass then
            player_manager.RunClass(ply, "SetupDataTables")
        end
    end
    if ply == client then
        return
    end
    if ply:IsPlayer() then
        if ply:Alive() == false then
            return
        end
        --if ply:GetPos():Distance(client:GetPos()) > 370 then return end
        if ply:Team() == TEAMS.SPECTATOR then
            return
        end
        if ply:GetNClass() == ROLES.ROLE_SCP966 then
            local hide = true
            for k, v in pairs(client:GetWeapons()) do
                if istable(v.NVG) then
                    if v.NVGenabled == true then
                        hide = false
                    end
                end
            end

            if client:GTeam() == TEAM_SCP then
                hide = false
            end
            if hide == true then
                return
            end
        end

        --if ply:GTeam() == TEAM_SCP then
        text = GetLangRole(ply:GetNClass())
        clr = gteams.GetColor(ply:GTeam())
        --end
        if ply:GTeam() == TEAM_CHAOS then
            clr = Color(29, 81, 56)
        end
        local frole = FindRole(ply:GetNClass())
        if istable(frole) then
            if ply:GTeam() == TEAM_CHAOS then
                if LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_CLASS_D then
                    clr = Color(29, 81, 56)
                    text = frole.disguised_name .. " (Spy)"
                else
                    if frole.disguised_color ~= nil then
                        clr = frole.disguised_color
                    end
                    text = frole.disguised_name
                end
            end
        end
    else
        return
    end

    local x = ScrW() / 2
    local y = ScrH() / 2 + 30
    draw.Text({
        text = ply:Nick() .. " (" .. ply:Health() .. "%)",
        pos = { x, y },
        font = "TargetID",
        color = clr2,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })

    draw.Text({
        text = text,
        pos = { x, y + 16 },
        font = "TargetID",
        color = clr,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })
end