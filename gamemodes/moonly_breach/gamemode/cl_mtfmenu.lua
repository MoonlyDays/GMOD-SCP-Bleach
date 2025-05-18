surface.CreateFont("MTF_Main", {
    font = "Trebuchet24",
    size = 21,
    weight = 750
})

if not MTFMenuFrame then
    MTFMenuFrame = nil
end
nextmenudelete = 0
showmenu = false
function GM:KeyPress(ply, key)
    if key == IN_ZOOM then
        OpenMenu()
    end
end

function GM:KeyRelease(ply, key)
    if key == IN_ZOOM then
        CloseMTFMenu()
    end
end

function CloseMTFMenu()
    if ispanel(MTFMenuFrame) then
        if MTFMenuFrame.Close then
            MTFMenuFrame:Close()
        end
    end
end

function OpenMenu()
    if IsValid(MTFMenuFrame) then
        return
    end
    local ply = LocalPlayer()
    if not (ply:Team() == TEAM_GUARD or ply:Team() == TEAM_CHAOS) then
        return
    end
    local clevel = LocalPlayer():CLevelGlobal()
    MTFMenuFrame = vgui.Create("DFrame")
    MTFMenuFrame:SetTitle("")
    MTFMenuFrame:SetSize(400, 375)
    MTFMenuFrame:Center()
    MTFMenuFrame:SetDraggable(true)
    MTFMenuFrame:SetDeleteOnClose(true)
    MTFMenuFrame:SetDraggable(false)
    MTFMenuFrame:ShowCloseButton(true)
    MTFMenuFrame:MakePopup()
    MTFMenuFrame.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(75, 75, 75))
    end

    local maininfo = vgui.Create("DLabel", MTFMenuFrame)
    maininfo:SetText(clang.mtfmanager)
    maininfo:Dock(TOP)
    maininfo:SetFont("MTF_Main")
    maininfo:SetContentAlignment(5)
    --maininfo:DockMargin( 245, 8, 8, 175	)
    maininfo:SetSize(0, 24)
    maininfo.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(90, 90, 95))
    end

    local button_dropvest = vgui.Create("DButton", MTFMenuFrame)
    button_dropvest:SetText(clang.dropvest)
    button_dropvest:Dock(TOP)
    button_dropvest:SetFont("MTF_Main")
    button_dropvest:SetContentAlignment(5)
    button_dropvest:DockMargin(0, 5, 0, 0)
    button_dropvest:SetSize(0, 32)
    button_dropvest.DoClick = function()
        RunConsoleCommand("br_dropvest")
        MTFMenuFrame:Close()
    end

    if clevel > 3 then
        local button_gatea = vgui.Create("DButton", MTFMenuFrame)
        button_gatea:SetText(clang.requestgatea)
        button_gatea:Dock(TOP)
        button_gatea:SetFont("MTF_Main")
        button_gatea:SetContentAlignment(5)
        button_gatea:DockMargin(0, 5, 0, 0)
        button_gatea:SetSize(0, 32)
        button_gatea.DoClick = function()
            RunConsoleCommand("br_requestgatea")
            MTFMenuFrame:Close()
        end
    end

    local button_escort = vgui.Create("DButton", MTFMenuFrame)
    button_escort:SetText(clang.requestescort)
    button_escort:Dock(TOP)
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment(5)
    button_escort:DockMargin(0, 5, 0, 0)
    button_escort:SetSize(0, 32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_requestescort")
        MTFMenuFrame:Close()
    end

    local button_escort = vgui.Create("DButton", MTFMenuFrame)
    button_escort:SetText(clang.sound_random)
    button_escort:Dock(TOP)
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment(5)
    button_escort:DockMargin(0, 5, 0, 0)
    button_escort:SetSize(0, 32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_sound_random")
        MTFMenuFrame:Close()
    end

    local button_escort = vgui.Create("DButton", MTFMenuFrame)
    button_escort:SetText(clang.sound_searching)
    button_escort:Dock(TOP)
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment(5)
    button_escort:DockMargin(0, 5, 0, 0)
    button_escort:SetSize(0, 32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_sound_searching")
        MTFMenuFrame:Close()
    end

    local button_escort = vgui.Create("DButton", MTFMenuFrame)
    button_escort:SetText(clang.sound_classdfound)
    button_escort:Dock(TOP)
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment(5)
    button_escort:DockMargin(0, 5, 0, 0)
    button_escort:SetSize(0, 32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_sound_classd")
        MTFMenuFrame:Close()
    end

    local button_escort = vgui.Create("DButton", MTFMenuFrame)
    button_escort:SetText(clang.sound_stop)
    button_escort:Dock(TOP)
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment(5)
    button_escort:DockMargin(0, 5, 0, 0)
    button_escort:SetSize(0, 32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_sound_stop")
        MTFMenuFrame:Close()
    end

    local button_escort = vgui.Create("DButton", MTFMenuFrame)
    button_escort:SetText(clang.sound_targetlost)
    button_escort:Dock(TOP)
    button_escort:SetFont("MTF_Main")
    button_escort:SetContentAlignment(5)
    button_escort:DockMargin(0, 5, 0, 0)
    button_escort:SetSize(0, 32)
    button_escort.DoClick = function()
        RunConsoleCommand("br_sound_lost")
        MTFMenuFrame:Close()
    end
end