if SERVER then
    AddCSLuaFile( "settingsmenu.lua" )
    util.AddNetworkString( "f4menu" )

    hook.Add( "ShowSpare2", "F4MenuHook", function( ply )
        net.Start( "f4menu" )
        net.Send( ply )
    end )
end

if CLIENT then
    include( "settingsmenu.lua" )

    net.Receive( "f4menu", function()
        if( !SettingsMenuF4 ) then
            SettingsMenuF4 = vgui.Create( "settingsmenuf4" )
            SettingsMenuF4:SetVisible( false )
        end 

        if( SettingsMenuF4:IsVisible() ) then
            SettingsMenuF4:SetVisible(  false )
            gui.EnableScreenClicker( false )
        else 
            SettingsMenuF4:SetVisible( true )
            gui.EnableScreenClicker( true ) 
        end      
    end)
end    
