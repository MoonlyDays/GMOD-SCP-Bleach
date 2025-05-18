-- Made by Kanade
if not Frame then Frame = nil end
surface.CreateFont("sb_names", {
	font = "Trebuchet18",
	size = 14,
	weight = 700
})

function RanksEnabled()
	return GetConVar("br_scoreboardranks"):GetBool()
end

function firstToUpper(str)
	return str:gsub("^%l", string.upper)
end

function role_GetPlayers(role)
	local all = {}
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			if not v.GetNClass then player_manager.RunClass(v, "SetupDataTables") end
			if v.GetNClass then if v:GetNClass() == role then table.ForceInsert(all, v) end end
		end
	end
	return all
end

function ShowScoreBoard()
	local ply = LocalPlayer()
	local allplayers = {}
	table.Add(allplayers, player.GetAll())
	local mtfs = {}
	table.Add(mtfs, role_GetPlayers(ROLE_MTFGUARD))
	table.Add(mtfs, role_GetPlayers(ROLE_MTFCOM))
	table.Add(mtfs, role_GetPlayers(ROLE_MTFNTF))
	local playerlist = {}
	table.ForceInsert(playerlist, {
		name = "SCPs",
		list = team.GetPlayers(TEAM_SCP),
		color = team.GetColor(TEAM_SCP),
		color2 = color_white
	})

	table.ForceInsert(playerlist, {
		name = "SCP035 in SCPs",
		list = role_GetPlayers(ROLE_SCP035),
		color = team.GetColor(TEAM_SCP),
		color2 = color_white
	})

	table.ForceInsert(playerlist, {
		name = "Mobile Task Force",
		list = mtfs,
		color = team.GetColor(TEAM_GUARD),
		color2 = color_white
	})

	table.ForceInsert(playerlist, {
		name = "Chaos Insurgency",
		list = role_GetPlayers(ROLE_CHAOS),
		color = Color(29, 81, 56),
		color2 = color_white
	})

	table.ForceInsert(playerlist, {
		name = "Class D Personell",
		list = role_GetPlayers(ROLE_CLASSD),
		color = team.GetColor(TEAM_CLASSD),
		color2 = color_white
	})

	table.ForceInsert(playerlist, {
		name = "Scientists",
		list = role_GetPlayers(ROLE_RES),
		color = team.GetColor(TEAM_SCI),
		color2 = color_white
	})

	table.ForceInsert(playerlist, {
		name = "Spectators",
		list = team.GetPlayers(TEAM_SPECTATOR),
		color = color_white,
		color2 = color_black
	})

	-- Sort all
	table.sort(playerlist[1].list, function(a, b) return a:Frags() > b:Frags() end)
	table.sort(playerlist[3].list, function(a, b) return a:Frags() > b:Frags() end)
	table.sort(playerlist[4].list, function(a, b) return a:Frags() > b:Frags() end)
	local color_main = 45
	Frame = vgui.Create("DFrame")
	Frame:Center()
	Frame:SetSize(ScrW(), ScrH())
	Frame:SetTitle("")
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:SetDeleteOnClose(true)
	Frame:SetDraggable(false)
	Frame:ShowCloseButton(false)
	Frame:Center()
	Frame:MakePopup()
	Frame.Paint = function(self, w, h) end
	local width = 25
	local mainpanel = vgui.Create("DPanel", Frame)
	mainpanel:SetSize(ScrW() / 1.5, ScrH() / 1.3)
	mainpanel:CenterHorizontal(0.5)
	mainpanel:CenterVertical(0.5)
	mainpanel.Paint = function(self, w, h)
		--draw.RoundedBox( 0, 0, 0, w, h, Color( color_main, color_main, color_main, 240 ) )
	end

	local panel_backg = vgui.Create("DPanel", mainpanel)
	panel_backg:Dock(FILL)
	panel_backg:DockMargin(8, 50, 8, 8)
	panel_backg.Paint = function(self, w, h)
		--draw.RoundedBox( 0, 0, 0, w, h, Color( color_main, color_main, color_main, 180 ) )
	end

	local DScrollPanel = vgui.Create("DScrollPanel", panel_backg)
	DScrollPanel:Dock(FILL)
	local color_dark = Color(35, 35, 35, 180)
	local color_light = Color(80, 80, 80, 180)
	local panelname_backg = vgui.Create("DPanel", DScrollPanel)
	panelname_backg:Dock(TOP)
	--if i != 1 then
	--	panelname_backg:DockMargin( 0, 15, 0, 0 )
	--end
	panelname_backg:SetSize(0, width)
	panelname_backg.Paint = function(self, w, h)
		--draw.RoundedBox( 0, 0, 0, w, h, color_dark )
	end

	local panelwidth = 55
	local sbpanels = {
		{
			name = clang.sb_ping,
			size = panelwidth
		},
		{
			name = clang.sb_deaths,
			size = panelwidth
		},
		{
			name = clang.sb_score,
			size = panelwidth
		}
	}

	if KarmaEnabled() then
		table.ForceInsert(sbpanels, {
			name = "Karma",
			size = panelwidth
		})
	end

	if RanksEnabled() then
		table.ForceInsert(sbpanels, {
			name = clang.sb_group,
			size = panelwidth * 2
		})
	end

	local MuteButtonFix = vgui.Create("DPanel", panelname_backg)
	MuteButtonFix:Dock(RIGHT)
	MuteButtonFix:SetSize(width - 2, width - 2)
	MuteButtonFix.Paint = function() end
	local sb_panel_version = vgui.Create("DImage", panelname_backg)
	sb_panel_version:Dock(LEFT)
	sb_panel_version:SetPos(1, 1)
	sb_panel_version:SetSize(230, 128)
	sb_panel_version:SetImage("breach/logo.png")
	for i, pnl in ipairs(sbpanels) do
		local ping_panel = vgui.Create("DLabel", panelname_backg)
		ping_panel:Dock(RIGHT)
		if i == 1 then ping_panel:DockMargin(0, 0, 25, 0) end
		ping_panel:SetSize(pnl.size, 0)
		ping_panel:SetText(pnl.name)
		ping_panel:SetFont("sb_names")
		ping_panel:SetTextColor(Color(255, 255, 255, 255))
		ping_panel:SetContentAlignment(5)
		ping_panel.Paint = function(self, w, h) end
		drawb = not drawb
	end

	local i = 0
	for key, tab in pairs(playerlist) do
		i = i + 1
		if #tab.list > 0 then
			-- players
			local panelwidth = 55
			local dark = true
			for k, v in pairs(tab.list) do
				local panels = {
					{
						name = clang.sb_ping,
						text = v:Ping(),
						color = color_white,
						size = panelwidth
					},
					{
						name = clang.sb_deaths,
						text = v:Deaths(),
						color = color_white,
						size = panelwidth
					},
					{
						name = clang.sb_score,
						text = v:Frags(),
						color = color_white,
						size = panelwidth
					},
				}

				if KarmaEnabled() then
					local tkarma = v:GetKarma()
					if tkarma == nil then tkarma = 999 end
					table.ForceInsert(panels, {
						name = "Karma",
						text = v:GetKarma(),
						color = color_white,
						size = panelwidth
					})
				end

				local rank = v:GetUserGroup()
				rank = firstToUpper(rank)
				if RanksEnabled() then
					table.ForceInsert(panels, {
						name = "Group",
						text = rank,
						color = color_white,
						size = panelwidth * 2
					})
				end

				local scroll_panel = vgui.Create("DPanel", DScrollPanel)
				scroll_panel:Dock(TOP)
				scroll_panel:DockMargin(0, 5, 0, 0)
				scroll_panel:SetSize(0, width)
				--scroll_panel.clr = team.GetColor(v:Team())
				scroll_panel.clr = tab.color
				if not v.GetNClass then player_manager.RunClass(v, "SetupDataTables") end
				scroll_panel.Paint = function(self, w, h)
					if not IsValid(v) or not v then
						Frame:Close()
						return
					end

					local txt = "ERROR"
					if not v.GetNClass then
						player_manager.RunClass(v, "SetupDataTables")
					else
						txt = GetLangRole(v:GetNClass())
					end

					local tcolor = scroll_panel.clr
					if LocalPlayer():Team() == TEAM_CHAOS or LocalPlayer():Team() == TEAM_CLASSD or LocalPlayer():Team() == TEAM_SPECTATOR then
						if v:Team() == TEAM_CHAOS then
							txt = GetLangRole(ROLE_CHAOS)
							tcolor = Color(29, 81, 56)
						end
					end

					if LocalPlayer():Team() == TEAM_CLASSD or LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS or LocalPlayer():Team() == TEAM_SCI then
						if v:Team() == TEAM_SCP then
							txt = clang.sb_scpobject
							tcolor = Color(237, 28, 63)
						end
					end

					if LocalPlayer():Team() == TEAM_CLASSD or LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS or LocalPlayer():Team() == TEAM_SCI then
						if v:GetNClass() == ROLE_SCP035 then
							txt = clang.sb_scpobject
							tcolor = Color(237, 28, 63)
						end
					end

					if LocalPlayer():Team() == TEAM_SCP or LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():GetNClass() == ROLE_SCP035 then
						if v:Team() == TEAM_SCP then
							txt = GetLangRole(v:GetNClass())
							tcolor = Color(237, 28, 63)
						end
					end

					if LocalPlayer():GetNClass() == ROLE_SCP035 then
						if v:GetNClass() == ROLE_SCP035 then
							txt = GetLangRole(v:GetNClass())
							tcolor = Color(237, 28, 63)
						end
					end

					draw.RoundedBox(0, 0, 0, w, h, tcolor)
					draw.Text({
						text = string.sub(v:Nick(), 1, 16),
						pos = {width + 2, h / 2},
						font = "sb_names",
						color = tab.color2,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER
					})

					draw.RoundedBox(0, width + 150, 0, 125, h, Color(0, 0, 0, 120))
					draw.Text({
						text = txt,
						pos = {width + 212, h / 2},
						font = "sb_names",
						color = tab.color2,
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER
					})

					local panel_x = w / 1.1175
					local panel_w = w / 14
				end

				local MuteButton = vgui.Create("DButton", scroll_panel)
				MuteButton:Dock(RIGHT)
				MuteButton:SetSize(width - 2, width - 2)
				MuteButton:SetText("")
				MuteButton.DoClick = function() v:SetMuted(not v:IsMuted()) end
				MuteButton.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255)) end
				local MuteIMG = vgui.Create("DImage", MuteButton)
				MuteIMG.img = "icon32/unmuted.png"
				MuteIMG:SetPos(MuteButton:GetPos())
				MuteIMG:SetSize(MuteButton:GetSize())
				MuteIMG:SetImage("icons32/unmuted.png")
				MuteIMG.Think = function(self, w, h)
					if not IsValid(v) then return end
					if v:IsMuted() then
						self.img = "icon32/muted.png"
					else
						self.img = "icon32/unmuted.png"
					end

					self:SetImage(self.img)
				end

				local drawb = true
				for i, pnl in ipairs(panels) do
					local ping_panel = vgui.Create("DLabel", scroll_panel)
					ping_panel:Dock(RIGHT)
					if i == 1 then ping_panel:DockMargin(0, 0, 25, 0) end
					ping_panel:SetSize(pnl.size, 0)
					ping_panel:SetText(pnl.text)
					ping_panel:SetFont("sb_names")
					ping_panel:SetTextColor(tab.color2)
					ping_panel:SetContentAlignment(5)
					if drawb then
						ping_panel.Paint = function(self, w, h)
							ping_panel:SetText(pnl.text)
							draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
						end
					end

					drawb = not drawb
				end

				local Avatar = vgui.Create("AvatarImage", scroll_panel)
				Avatar:SetSize(width, width)
				Avatar:SetPos(0, 0)
				Avatar:SetPlayer(v, 32)
			end
		end
	end
end

function GM:ScoreboardShow()
	ShowScoreBoard()
end

function GM:ScoreboardHide()
	if IsValid(Frame) then Frame:Close() end
end