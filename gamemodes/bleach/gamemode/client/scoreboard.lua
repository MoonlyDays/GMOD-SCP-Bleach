scoreBoardFrame = nil
function RanksEnabled()
    return GetConVar("br_scoreboardranks"):GetBool()
end

function ShowScoreBoard()
    scoreBoardFrame = vgui.Create("DFrame")
    scoreBoardFrame:Center()
    scoreBoardFrame:SetSize(ScrW(), ScrH())
    scoreBoardFrame:SetTitle("")
    scoreBoardFrame:SetVisible(true)
    scoreBoardFrame:SetDraggable(true)
    scoreBoardFrame:SetDeleteOnClose(true)
    scoreBoardFrame:SetDraggable(false)
    scoreBoardFrame:ShowCloseButton(false)
    scoreBoardFrame:Center()
    scoreBoardFrame:MakePopup()
    scoreBoardFrame.Paint = function(self, w, h)
    end

    local width = 25
    local mainPanel = vgui.Create("DPanel", scoreBoardFrame)
    mainPanel:SetSize(ScrW() / 1.5, ScrH() / 1.3)
    mainPanel:CenterHorizontal(0.5)
    mainPanel:CenterVertical(0.5)
    mainPanel.Paint = function(self, w, h)
    end

    local panelBg = vgui.Create("DPanel", mainPanel)
    panelBg:Dock(FILL)
    panelBg:DockMargin(8, 50, 8, 8)
    panelBg.Paint = function(self, w, h)
    end

    local scrollPanel = vgui.Create("DScrollPanel", panelBg)
    scrollPanel:Dock(FILL)

    local panelNameBg = vgui.Create("DPanel", scrollPanel)
    panelNameBg:Dock(TOP)
    panelNameBg:SetSize(0, width)
    panelNameBg.Paint = function(self, w, h)
    end

    local teams = {
        TEAMS.SCP,
        TEAMS.STAFF,
        TEAMS.MTF,
        TEAMS.SECURITY,
        TEAMS.CHAOS,
        TEAMS.CLASS_D,
        TEAMS.SCIENTIST,
        TEAMS.SPECTATOR,
    }

    local columns = {
        {
            name = "Ping",
            value = function(ply)
                return ply:Ping()
            end
        },
        {
            name = "Deaths",
            value = function(ply)
                return ply:Deaths()
            end
        },
    }

    local versionPanel = vgui.Create("DLabel", panelNameBg)
    versionPanel:Dock(LEFT)
    versionPanel:SetSize(200, 0)
    versionPanel:SetText("SCP Bleach by Moonly Days")
    versionPanel:SetFont("sb_names")
    versionPanel:SetTextColor(Color(255, 255, 255, 255))
    versionPanel:SetContentAlignment(4)
    versionPanel.Paint = function()
    end

    for i, column in ipairs(columns) do
        local panel = vgui.Create("DLabel", panelNameBg)
        panel:Dock(RIGHT)
        panel:SetSize(55, 0)
        panel:SetText(column.name)
        panel:SetFont("sb_names")
        panel:SetTextColor(Color(255, 255, 255, 255))
        panel:SetContentAlignment(5)
        panel.Paint = function()
        end
    end

    for _, teamIndex in pairs(teams) do
        local players = team.GetPlayers(teamIndex)
        if #players == 0 then
            continue
        end

        for _, ply in pairs(players) do
            local bgColor = team.GetColor(teamIndex)
            local fgColor = Color(255, 255, 255)
            if (bgColor.r + bgColor.g + bgColor.b) > 500 then
                fgColor = Color(0, 0, 0)
            end

            local playerPanel = vgui.Create("DPanel", scrollPanel)
            playerPanel:Dock(TOP)
            playerPanel:DockMargin(0, 5, 0, 0)
            playerPanel:SetSize(0, width)
            playerPanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, bgColor)
                draw.Text({
                    text = string.sub(ply:Nick(), 1, 16),
                    pos = { width + 2, h / 2 },
                    font = "sb_names",
                    color = fgColor,
                    xalign = TEXT_ALIGN_LEFT,
                    yalign = TEXT_ALIGN_CENTER
                })

                draw.RoundedBox(0, width + 150, 0, 125, h, Color(0, 0, 0, 120))
                draw.Text({
                    text = team.GetName(teamIndex),
                    pos = { width + 212, h / 2 },
                    font = "sb_names",
                    color = fgColor,
                    xalign = TEXT_ALIGN_CENTER,
                    yalign = TEXT_ALIGN_CENTER
                })
            end

            local Avatar = vgui.Create("AvatarImage", playerPanel)
            Avatar:SetSize(width, width)
            Avatar:SetPos(0, 0)
            Avatar:SetPlayer(v, 32)
        end
    end
end

function GM:ScoreboardShow()
    if IsValid(scoreBoardFrame) then
        scoreBoardFrame:Close()
    end
    ShowScoreBoard()
end

function GM:ScoreboardHide()
    if IsValid(scoreBoardFrame) then
        scoreBoardFrame:Close()
    end
end