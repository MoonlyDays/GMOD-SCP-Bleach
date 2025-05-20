CLASS_MENU = nil
selectedClass = nil
selectedColor = nil

function OpenClassMenu()
    -- Already open.
    if IsValid(CLASS_MENU) then
        return
    end

    local ply = LocalPlayer()
    local ourLevel = LocalPlayer():GetLevel()
    selectedClass = ALL_CLASSES["support"]["roles"][1]
    selectedColor = ALL_CLASSES["support"]["color"]
    if selectedColor == nil then
        selectedColor = Color(255, 255, 255)
    end

    local width = ScrW() / 1.5
    local height = ScrH() / 1.5
    CLASS_MENU = vgui.Create("DFrame")
    CLASS_MENU:SetTitle("")
    CLASS_MENU:SetSize(width, height)
    CLASS_MENU:Center()
    CLASS_MENU:SetDraggable(true)
    CLASS_MENU:SetDeleteOnClose(true)
    CLASS_MENU:SetDraggable(false)
    CLASS_MENU:ShowCloseButton(true)
    CLASS_MENU:MakePopup()
    CLASS_MENU.Paint = function(_, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(90, 90, 95))
    end

    local panelMainInfo = vgui.Create("DLabel", CLASS_MENU)
    panelMainInfo:SetText("Class Manager")
    panelMainInfo:SetTextColor(Color(255, 255, 255, 255))
    panelMainInfo:Dock(TOP)
    panelMainInfo:SetFont("MTF_Main")
    panelMainInfo:SetContentAlignment(5)
    panelMainInfo:SetSize(0, 28)
    panelMainInfo.Paint = function(_, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(90, 90, 95))
    end

    local panelRight = vgui.Create("DPanel", CLASS_MENU)
    panelRight:Dock(FILL)
    panelRight:DockMargin(width / 2 - 5, 0, 0, 0)
    panelRight.Paint = function(self, w, h)
    end

    local panelSelectedClassHeader = vgui.Create("DPanel", panelRight)
    panelSelectedClassHeader:Dock(TOP)
    panelSelectedClassHeader:SetSize(0, height / 2.5)
    panelSelectedClassHeader.Paint = function(self, w, h)
    end

    local selectedModel
    if selectedClass.showmodel == nil then
        selectedModel = table.Random(selectedClass.models)
    else
        selectedModel = selectedClass.showmodel
    end

    local panelSelectedClassModel = vgui.Create("DPanel", panelSelectedClassHeader)
    panelSelectedClassModel:Dock(LEFT)
    panelSelectedClassModel:SetSize(width / 6)
    panelSelectedClassModel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
    end

    selectedClassModel = vgui.Create("DModelPanel", panelSelectedClassModel)
    selectedClassModel:Dock(FILL)
    selectedClassModel:SetFOV(50)
    selectedClassModel:SetModel(selectedModel)
    function selectedClassModel:LayoutEntity(entity)
        entity:SetAngles(Angle(0, 18, 0))
    end

    local ent = selectedClassModel:GetEntity()
    if selectedClass.pmcolor ~= nil then
        function ent:GetPlayerColor()
            return Vector(selectedClass.pmcolor.r / 255, selectedClass.pmcolor.g / 255, selectedClass.pmcolor.b / 255)
        end
    end

    local sclass_name = vgui.Create("DPanel", panelSelectedClassHeader)
    sclass_name:Dock(TOP)
    sclass_name:SetSize(0, 50)
    sclass_name.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, selectedColor)
        draw.Text({
            text = GetLangRole(selectedClass.name),
            font = "MTF_Secondary",
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
            pos = { w / 2, h / 2 }
        })
    end

    local sclass_name = vgui.Create("DPanel", panelSelectedClassHeader)
    sclass_name:Dock(FILL)
    sclass_name:SetSize(0, 50)
    sclass_name.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(86, 88, 90))
        local atso = w / 13
        local starpos = w / 16
        draw.Text({
            text = "Health: " .. selectedClass.health,
            font = "MTF_Third",
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER,
            pos = { 12, starpos }
        })

        draw.Text({
            text = "Walk speed: " .. math.Round(240 * selectedClass.walkspeed),
            font = "MTF_Third",
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER,
            pos = { 12, starpos + atso }
        })

        draw.Text({
            text = "Run speed: " .. math.Round(240 * selectedClass.runspeed),
            font = "MTF_Third",
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER,
            pos = { 12, starpos + (atso * 2) }
        })

        draw.Text({
            text = "Jump Power: " .. math.Round(200 * selectedClass.jumppower),
            font = "MTF_Third",
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER,
            pos = { 12, starpos + (atso * 3) }
        })

        if isstring(selectedClass.disguised_name) then
            draw.Text({
                text = "Disguised as: " .. selectedClass.disguised_name,
                font = "MTF_Third",
                color = Color(183, 23, 65, 255),
                xalign = TEXT_ALIGN_LEFT,
                yalign = TEXT_ALIGN_CENTER,
                pos = { 12, starpos + (atso * 4) }
            })
        end

        local lvl = selectedClass.level
        local clr = Color(255, 0, 0)
        if ourLevel >= lvl then
            clr = Color(0, 255, 0)
        end
        if lvl == 6 then
            lvl = "Omni"
        end
        if lvl == 0 then
            lvl = "None"
        end
        draw.Text({
            text = "Clearance level: " .. lvl,
            font = "MTF_Third",
            color = clr,
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER,
            pos = { 12, h - starpos }
        })
    end

    local sclass_downpanel = vgui.Create("DPanel", panelRight)
    sclass_downpanel:Dock(FILL)
    sclass_downpanel:SetSize(0, height / 2.5)
    sclass_downpanel.Paint = function(self, w, h)
        local atso = w / 18
        local starpos = w / 12
        local numw = 0
        for k, v in pairs(selectedClass.showweapons) do
            draw.Text({
                text = "- " .. v,
                font = "MTF_Third",
                xalign = TEXT_ALIGN_LEFT,
                yalign = TEXT_ALIGN_CENTER,
                pos = { 12, starpos + (numw * atso) }
            })

            numw = numw + 1
        end
    end

    local maininfo = vgui.Create("DLabel", sclass_downpanel)
    maininfo:SetText("Equipment")
    maininfo:SetTextColor(Color(255, 255, 255, 255))
    maininfo:Dock(TOP)
    maininfo:SetFont("MTF_Main")
    maininfo:SetContentAlignment(5)
    --maininfo:DockMargin( 245, 8, 8, 175	)
    maininfo:SetSize(0, 28)
    maininfo.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, selectedColor)
    end

    -- LEFT PANELS
    local panel_left = vgui.Create("DPanel", CLASS_MENU)
    panel_left:Dock(FILL)
    panel_left:DockMargin(0, 0, width / 2 - 5, 0)
    panel_left.Paint = function(self, w, h)
    end
    local scroller = vgui.Create("DScrollPanel", panel_left)
    scroller:Dock(FILL)
    if ALL_CLASSES == nil then
        return
    end
    for key, v in pairs(ALL_CLASSES) do
        local name_security = vgui.Create("DLabel", scroller)
        name_security:SetText(v.name)
        name_security:SetFont("MTF_Main")
        name_security:SetTextColor(Color(255, 255, 255, 255))
        name_security:SetContentAlignment(5)
        name_security:Dock(TOP)
        name_security:SetSize(0, 45)
        name_security:DockMargin(0, 0, 0, 0)
        name_security.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
            draw.RoundedBox(2, 1, 1, w - 2, h - 2, v.color)
        end

        for i, cls in ipairs(v.roles) do
            local model
            if cls.showmodel == nil then
                model = table.Random(cls.models)
            else
                model = cls.showmodel
            end

            local class_panel = vgui.Create("DButton", scroller)
            class_panel:SetText("")
            class_panel:SetMouseInputEnabled(true)
            class_panel.DoClick = function()
                selectedClass = cls
                selectedColor = v.color
                selectedClassModel:SetModel(model)
            end

            --class_panel:SetText( cls.name )
            --class_panel:SetFont("MTF_Main")
            class_panel:Dock(TOP)
            class_panel:SetSize(0, 60)
            if i ~= 1 then
                class_panel:DockMargin(0, 4, 0, 0)
            end
            local level = "Clearance Level: "
            if cls.level == 6 then
                level = level .. "Omni"
            elseif cls.level == 0 then
                level = level .. "None"
            else
                level = level .. cls.level
            end

            --local enabled = true
            --if enabled == true then enabled = "Yes" else enabled = "No" end
            class_panel.Paint = function(self, w, h)
                if selectedClass == cls then
                    draw.RoundedBox(0, 0, 0, w, h, Color(v.color.r - 20, v.color.g - 20, v.color.b - 20))
                else
                    draw.RoundedBox(0, 0, 0, w, h, Color(v.color.r - 50, v.color.g - 50, v.color.b - 50))
                end

                draw.Text({
                    text = GetLangRole(cls.name),
                    font = "MTF_Main",
                    xalign = TEXT_ALIGN_LEFT,
                    yalign = TEXT_ALIGN_CENTER,
                    pos = { 70, h / 3.5 }
                })

                draw.Text({
                    text = level,
                    font = "MTF_Main",
                    xalign = TEXT_ALIGN_LEFT,
                    yalign = TEXT_ALIGN_CENTER,
                    pos = { 70, h / 1.4 }
                })
                --[[
                draw.Text( {
                    text = "Enabled: " .. enabled,
                    font = "MTF_Main",
                    xalign = TEXT_ALIGN_RIGHT,
                    yalign = TEXT_ALIGN_CENTER,
                    pos = { w - 15, h / 2 }
                } )
                ]]
            end

            local class_modelpanel = vgui.Create("DPanel", class_panel)
            class_modelpanel:Dock(LEFT)
            class_modelpanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(v.color.r - 25, v.color.g - 25, v.color.b - 25))
            end
            local class_model = vgui.Create("DModelPanel", class_modelpanel)
            class_model:Dock(FILL)
            class_model:SetFOV(35)
            class_model:SetModel(model)
            function class_model:LayoutEntity(entity)
                entity:SetAngles(Angle(0, 18, 0))
            end

            local ent = class_model:GetEntity()
            if cls.pmcolor ~= nil then
                function ent:GetPlayerColor()
                    return Vector(cls.pmcolor.r / 255, cls.pmcolor.g / 255, cls.pmcolor.b / 255)
                end
            end

            if ent:LookupBone("ValveBiped.Bip01_Head1") ~= nil then
                local eyepos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
                eyepos:Add(Vector(0, 0, 2))
                class_model:SetLookAt(eyepos)
                class_model:SetCamPos(eyepos - Vector(-24, 0, 0))
                ent:SetEyeTarget(eyepos - Vector(-24, 0, 0))
            end
        end
    end
    --button_escort:SetFont("MTF_Main")
    --button_escort:SetContentAlignment( 5 )
    --button_escort:DockMargin( 0, 5, 0, 0	)
    --button_escort:SetSize(0,32)
    --button_escort.DoClick = function()
    --	RunConsoleCommand("br_requestescort")
    --	CLASSMENU:Close()
    --end
    --[[
    local button_escort = vgui.Create( "DButton", CLASSMENU )
    button_escort:SetText( "Sound: Random" )
    button_escort:Dock( TOP )
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment( 5 )
    button_escort:DockMargin( 0, 5, 0, 0	)
    button_escort:SetSize(0,32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_sound_random")
        CLASSMENU:Close()
    end
    ]]
end