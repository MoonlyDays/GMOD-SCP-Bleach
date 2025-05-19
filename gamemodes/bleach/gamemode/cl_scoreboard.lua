Frame = nil
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

local sb_mat_muted = Material("icon32/muted.png", nil)
local sb_mat_unmuted = Material("icon32/unmuted.png", nil)
function ShowScoreBoard()
	--local sb_loading_start = SysTime()
	local playerlist = {}
	table.ForceInsert(playerlist, {
		name = "SCPs",
		skip = true,
		list = gteams.GetPlayers(TEAM_SCP),
		color = gteams.GetColor(TEAM_SCP),
		color2 = color_white
	})

	for k, v in pairs(ALLCLASSES) do
		local color_to_use = v.color
		if v.sc_color ~= nil then color_to_use = v.sc_color end
		table.ForceInsert(playerlist, {
			name = tostring(k),
			list = {},
			color = color_to_use,
			color2 = color_black
		})
	end

	for plist_k, plist in pairs(playerlist) do
		if plist.skip == nil or plist.skip == false then
			local whole_list = {}
			for roles_i, role in ipairs(ALLCLASSES[plist.name].roles) do
				for allpl_k, pl in pairs(player.GetAll()) do
					if pl.GetNClass ~= nil then if pl:Alive() and pl:GetNClass() == role.name then table.ForceInsert(whole_list, pl) end end
				end
			end

			plist.list = whole_list
		end
	end

	for plist_i, v in ipairs(playerlist) do
		for k2, pl in pairs(v.list) do
			pl.sb_disg_found = false
		end
	end

	local to_remove = {}
	for k, pl1 in pairs(playerlist) do
		for k2, pl in pairs(pl1.list) do
			if pl:GTeam() ~= TEAM_SCP and pl:GTeam() ~= TEAM_SPEC then
				local frole = FindRole(pl:GetNClass())
				if istable(frole) then
					if isstring(frole.disguised_sorting) then
						if ALLCLASSES[frole.disguised_sorting] ~= nil then
							for k3, pl2 in pairs(playerlist) do
								if pl.sb_disg_found == false and pl2.name == frole.disguised_sorting then
									table.ForceInsert(pl2.list, pl)
									table.ForceInsert(to_remove, {pl, pl1.name})
									pl.sb_disg_found = true
								end
							end
						end
					end
				end
			end
		end
	end

	for k, v in pairs(to_remove) do
		for plist_k, plist in pairs(playerlist) do
			if v[2] == plist.name then table.RemoveByValue(plist.list, v[1]) end
		end
	end

	table.ForceInsert(playerlist, {
		name = "Spectators",
		skip = true,
		list = gteams.GetPlayers(TEAM_SPEC),
		color = color_white,
		color2 = color_black
	})

	for k, v in pairs(playerlist) do
		table.sort(v.list, function(a, b) return a:GetNLevel() > b:GetNLevel() end)
	end

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
	Frame.Paint = function(self, w, h)
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 240 ) )
	end

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
			name = "Ping",
			size = panelwidth
		},
		{
			name = "Deaths",
			size = panelwidth
		},
		{
			name = "EXP",
			size = panelwidth
		},
		{
			name = "Level",
			size = panelwidth
		}
	}

	if RanksEnabled() then
		table.ForceInsert(sbpanels, {
			name = "Group",
			size = panelwidth * 2
		})
	end

	local MuteButtonFix = vgui.Create("DPanel", panelname_backg)
	MuteButtonFix:Dock(RIGHT)
	MuteButtonFix:SetSize(width - 2, width - 2)
	MuteButtonFix.Paint = function() end
	local sb_panel_version = vgui.Create("DLabel", panelname_backg)
	sb_panel_version:Dock(LEFT)
	sb_panel_version:SetSize(200, 0)
	sb_panel_version:SetText("version 03.04.2020 by Kanade")
	sb_panel_version:SetFont("sb_names")
	sb_panel_version:SetTextColor(Color(255, 255, 255, 255))
	sb_panel_version:SetContentAlignment(4)
	sb_panel_version.Paint = function() end
	for i, pnl in ipairs(sbpanels) do
		local sb_panel = vgui.Create("DLabel", panelname_backg)
		sb_panel:Dock(RIGHT)
		if i == 1 then sb_panel:DockMargin(0, 0, 25, 0) end
		sb_panel:SetSize(pnl.size, 0)
		sb_panel:SetText(pnl.name)
		sb_panel:SetFont("sb_names")
		sb_panel:SetTextColor(Color(255, 255, 255, 255))
		sb_panel:SetContentAlignment(5)
		sb_panel.Paint = function() end
		drawb = not drawb
	end

	local i = 0
	for key, tab in pairs(playerlist) do
		i = i + 1
		if #tab.list > 0 then
			-- players
			local panelwidth = 55
			for k, v in pairs(tab.list) do
				local nexp = 0
				if isfunction(v.GetNEXP) then nexp = v:GetNEXP() end
				local nlvl = 0
				if isfunction(v.GetNLevel) then nlvl = v:GetNLevel() end
				local panels = {
					{
						name = "Ping",
						text = v:Ping(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "Deaths",
						text = v:Deaths(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "EXP",
						text = nexp,
						color = color_white,
						size = panelwidth
					},
					{
						name = "Level",
						text = nlvl,
						color = color_white,
						size = panelwidth
					},
				}

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
				--scroll_panel.clr = gteams.GetColor(v:GTeam())
				scroll_panel.clr = tab.color
				if not v.GetNClass then player_manager.RunClass(v, "SetupDataTables") end
				scroll_panel.Paint = function(self, w, h)
					if not IsValid(v) or not v then
						Frame:Close()
						return
					end

					local txt = clang.class_unknown or "Unknown"
					local tcolor = tab.color
					local tcolor2 = color_white
					if (tab.color.r + tab.color.g + tab.color.b) > 500 then tcolor2 = color_black end
					txt = GetLangRole(v:GetNClass())
					for k2, role in pairs(ALLCLASSES["support"]["roles"]) do
						if v:GetNClass() == role.name then txt = "Mobile Task Force" end
					end

					local frole = FindRole(v:GetNClass())
					if istable(frole) then
						if v:GTeam() == TEAM_CHAOS then
							if LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_CLASSD then
								tcolor = Color(29, 81, 56)
								txt = frole.disguised_name .. " (Spy)"
							else
								if frole.disguised_color ~= nil then tcolor = frole.disguised_color end
								txt = frole.disguised_name
							end
						end
					end

					if v:GTeam() == TEAM_SCP then txt = "SCP Object" end
					draw.RoundedBox(0, 0, 0, w, h, tcolor)
					draw.Text({
						text = string.sub(v:Nick(), 1, 16),
						pos = {width + 2, h / 2},
						font = "sb_names",
						color = tcolor2,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER
					})

					draw.RoundedBox(0, width + 150, 0, 125, h, Color(0, 0, 0, 120))
					draw.Text({
						text = txt,
						pos = {width + 212, h / 2},
						font = "sb_names",
						color = tcolor2,
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
				MuteIMG.img = sb_mat_unmuted
				MuteIMG:SetPos(MuteButton:GetPos())
				MuteIMG:SetSize(MuteButton:GetSize())
				MuteIMG:SetMaterial(sb_mat_unmuted)
				MuteIMG.Think = function(self, w, h)
					if not IsValid(v) then return end
					if v:IsMuted() then
						self.img = sb_mat_muted
					else
						self.img = sb_mat_unmuted
					end

					self:SetMaterial(self.img)
				end

				local drawb = true
				local tcolor3 = color_white
				if (tab.color.r + tab.color.g + tab.color.b) > 500 then tcolor3 = color_black end
				for i, pnl in ipairs(panels) do
					local ping_panel = vgui.Create("DLabel", scroll_panel)
					ping_panel:Dock(RIGHT)
					if i == 1 then ping_panel:DockMargin(0, 0, 25, 0) end
					ping_panel:SetSize(pnl.size, 0)
					ping_panel:SetText(pnl.text)
					ping_panel:SetFont("sb_names")
					ping_panel:SetTextColor(tcolor3)
					ping_panel:SetContentAlignment(5)
					if drawb then
						ping_panel.Paint = function(self, w, h)
							if pnl.text == nil then return end
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
	--chat.AddText("Loading the scoreboard took " .. SysTime() - sb_loading_start .. " seconds")
end

function GM:ScoreboardShow()
	if IsValid(Frame) then Frame:Close() end
	ShowScoreBoard()
end

function GM:ScoreboardHide()
	if IsValid(Frame) then Frame:Close() end
end