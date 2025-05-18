local PANEL = {
    Init = function( self )
        self:SetSize( 1000, 720 )
        self:Center()
        self:SetVisible( true )

        local x, y = self:GetSize()

        surface.SetFont( "DermaLarge" )
        local titleX, titleY = surface.GetTextSize( "Classic Breach - Menu" )

        local title = vgui.Create( "DLabel", self )
        title:SetText( "Classic Breach - Menu" )
        title:SetSize( titleX, titleY )
        title:SetPos( 6, 6 )
        title:SetFont( "DermaLarge" )
        title:SetTextColor( Color( 255, 255, 255 ) )
        title:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

        local closebutton = vgui.Create( "DButton", self )
        closebutton:SetText( clang.f4close )
        closebutton:SetSize( 75, 25)
        closebutton:SetPos( x-81, 6 )
        closebutton.Paint = function( self, w, h )
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( 50, 50, 50, 255 )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
        closebutton.DoClick = function()    
            gui.EnableScreenClicker( false )
            SettingsMenuF4:Remove()
            SettingsMenuF4 = vgui.Create( "settingsmenuf4" )
            SettingsMenuF4:SetVisible( false )
        end

        // OLD
        /*
        // !! FOR EDITING ONLY !!, it enables the button to apply changes to the menu \\
        local removebutton = vgui.Create( "DButton", self )
        removebutton:SetText( "Remove" )
        removebutton:SetSize( 75, 25)
        removebutton:SetPos( x-162, 6 )
        removebutton.Paint = function( self, w, h )
            surface.SetDrawColor( 150, 150, 150, 50 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( 50, 50, 50, 150 )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
        removebutton.DoClick = function()    
            gui.EnableScreenClicker( false )
            SettingsMenuF4:Remove()
            SettingsMenuF4 = vgui.Create( "settingsmenuf4" )
            SettingsMenuF4:SetVisible( false )
        end
        */
        
        local pagesback = vgui.Create( "DPanel", self )
        pagesback:SetPos( 6, 37 )
        pagesback:SetSize( x-12, y-43 )
        pagesback.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( 0, 0, w, h )
        end

        -- classic breach logo in the corner
        local cbulogo = vgui.Create( "DImage", pagesback )
        cbulogo:SetPos( 5, y-43-115 )
        cbulogo:SetSize( 110, 110 )
        cbulogo:SetImage( "breach/cbulogo.png" )

        local pages = vgui.Create( "DColumnSheet", pagesback )
        pages:Dock( FILL)

        -- Settings tab
        local options = vgui.Create( "DPanel", pages )
        options:Dock( FILL )
        options.Paint = function( self, w, h )
            surface.SetDrawColor( 75, 75, 75, 75 )
            surface.DrawRect( 0, 0, w, h )
        end   
        pages:AddSheet( clang.f4settings, options, "icon16/wrench.png" )

        -- text above languages buttons
        local language_txt = vgui.Create( "DLabel", options)
        language_txt:SetPos( 100, 0 )
        language_txt:SetSize( 100, 30 )
        language_txt:SetTextColor( Color(255, 255, 255) )
        language_txt:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        language_txt:SetText( clang.f4settings_lang )

        -- english lang button
        local language_english_button = vgui.Create( "DButton", options )
        language_english_button:SetText( "English" )
        language_english_button:SetTextColor( Color(255,255,255) )
        language_english_button:SetPos( 30, 30 )
        language_english_button:SetSize( 100, 30 )
        language_english_button:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        language_english_button.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
        end
        language_english_button.DoClick = function()
            RunConsoleCommand("br_language", "english")
            Derma_Message("Language set to English", "", "OK")
        end

        -- polski lang button
        local language_polski_button = vgui.Create( "DButton", options )
        language_polski_button:SetText( "Polski" )
        language_polski_button:SetTextColor( Color(255,255,255) )
        language_polski_button:SetPos( 150, 30 )
        language_polski_button:SetSize( 100, 30 )
        language_polski_button:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        language_polski_button.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
        end
        language_polski_button.DoClick = function()
            RunConsoleCommand("br_language", "polski")
            Derma_Message("Language set to Polski", "", "OK")
        end

        -- text above spectate mode button
        local spectatemode_txt = vgui.Create( "DLabel", options)
        spectatemode_txt:SetPos( 80, 65 )
        spectatemode_txt:SetSize( 1000, 30 )
        spectatemode_txt:SetTextColor( Color(255, 255, 255) )
        spectatemode_txt:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        spectatemode_txt:SetText( clang.f4settings_spectmode )

        -- spectate mode button
        local spectatemode_button = vgui.Create( "DButton", options )
        spectatemode_button:SetText( "Spectate mode" )
        spectatemode_button:SetTextColor( Color(255,255,255) )
        spectatemode_button:SetPos( 90, 95 )
        spectatemode_button:SetSize( 100, 30 )
        spectatemode_button:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        spectatemode_button.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
        end
        spectatemode_button.DoClick = function()
            RunConsoleCommand("br_spectate")
        end

        -- text above sweetfx button
        local sweetfx_txt = vgui.Create( "DLabel", options)
        sweetfx_txt:SetPos( 60, 130 )
        sweetfx_txt:SetSize( 1000, 30 )
        sweetfx_txt:SetTextColor( Color(255, 255, 255) )
        sweetfx_txt:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        sweetfx_txt:SetText( clang.f4settings_sweetfx )

        -- sweetfx button
        local sweetfx_button = vgui.Create( "DButton", options )
        sweetfx_button:SetText( "SweetFX" )
        sweetfx_button:SetTextColor( Color(255,255,255) )
        sweetfx_button:SetPos( 90, 160 )
        sweetfx_button:SetSize( 100, 30 )
        sweetfx_button:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        sweetfx_button.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
        end
        sweetfx_button.DoClick = function()
            RunConsoleCommand("br_livecolors")
        end

        -- text above stopsounds button
        local stopsounds_txt = vgui.Create( "DLabel", options)
        stopsounds_txt:SetPos( 115, 195 )
        stopsounds_txt:SetSize( 1000, 30 )
        stopsounds_txt:SetTextColor( Color(255, 255, 255) )
        stopsounds_txt:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        stopsounds_txt:SetText( clang.f4settings_soundsfix )

        -- stopsounds button
        local stopsounds_button = vgui.Create( "DButton", options )
        stopsounds_button:SetText( "Stopsounds" )
        stopsounds_button:SetTextColor( Color(255,255,255) )
        stopsounds_button:SetPos( 90, 225 )
        stopsounds_button:SetSize( 100, 30 )
        stopsounds_button:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        stopsounds_button.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
        end
        stopsounds_button.DoClick = function()
            RunConsoleCommand("stopsound")
        end

        -- text above mat_specular 0 button
        local bwt_txt = vgui.Create( "DLabel", options)
        bwt_txt:SetPos( 70, 260 )
        bwt_txt:SetSize( 1000, 30 )
        bwt_txt:SetTextColor( Color(255, 255, 255) )
        bwt_txt:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        bwt_txt:SetText( clang.f4settings_bwt )
        
        -- mat_specular 0 button
        local brightweaponsandtexturesfix_button = vgui.Create( "DButton", options )
        brightweaponsandtexturesfix_button:SetText( "mat_specular 0" )
        brightweaponsandtexturesfix_button:SetTextColor( Color(255,255,255) )
        brightweaponsandtexturesfix_button:SetPos( 90, 290 )
        brightweaponsandtexturesfix_button:SetSize( 100, 30 )
        brightweaponsandtexturesfix_button:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        brightweaponsandtexturesfix_button.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
        end
        brightweaponsandtexturesfix_button.DoClick = function()
            BroadcastLua('render.RedownloadAllLightmaps(true)')
            BroadcastLua('RunConsoleCommand("mat_specular", 0)')
        end
        
        -- role 1/2 humans tab
        local instructions = vgui.Create( "DPanel", pages )
        instructions:Dock( FILL )
        instructions.Paint = function( self, w, h )
            surface.SetDrawColor( 75, 75, 75, 75 )
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet( clang.f4roles_humans, instructions )

        local humansroles = vgui.Create( "DImage", instructions )
        humansroles:SetPos( 1, 1 )
        humansroles:SetSize( 1920, 1107 )
        humansroles:SetImage( "breach/instructions.png" )

        -- role 2/2 scps tab
        local instructions1 = vgui.Create( "DPanel", pages )
        instructions1:Dock( FILL )
        instructions1.Paint = function( self, w, h )
            surface.SetDrawColor( 75, 75, 75, 75 )
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet( clang.f4roles_scps, instructions1 )

        local scproles = vgui.Create( "DImage", instructions1 )
        scproles:SetPos( 1, 1 )
        scproles:SetSize( 2000, 1152 )
        scproles:SetImage( "breach/instructions1.png" )

        -- credits tab
        local credits = vgui.Create( "DPanel", pages )
        credits:Dock( FILL )
        credits.Paint = function( self, w, h )
            surface.SetDrawColor( 75, 75, 75, 75 )
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet( clang.f4credits, credits )

        local creators = vgui.Create( "DImage", credits )
        creators:SetPos( 1, 1 )
        creators:SetSize( 2030, 1070 )
        creators:SetImage( "breach/credits.png" )

    end,

    Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 150 )
        surface.DrawRect( 0, 0, w, h )
        surface.DrawOutlinedRect( 2, 2, w-4, h-4 )
    end    
}
vgui.Register( "settingsmenuf4", PANEL  )