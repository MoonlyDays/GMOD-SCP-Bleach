-- SCP DEAD ANNOUNCEMENTS
local SOUND_173CON = "breach/intercom/173Contain.ogg"
local SOUND_106CON = "breach/intercom/106Contain.ogg"
local SOUND_049CON = "breach/intercom/049Contain.ogg"
local SOUND_096CON = "breach/intercom/096Contain.ogg"
local SOUND_939CON = "breach/intercom/939Contain.ogg"

hook.Add( "DoPlayerDeath", "173Contain", function( ply )
  if ply:GetNClass() ~= ROLE_SCP173 then return end  --  check player is a SCP
  
  BroadcastLua( "surface.PlaySound( \"" .. SOUND_173CON .. "\" )" )
end )

hook.Add( "DoPlayerDeath", "106Contain", function( ply )
  if ply:GetNClass() ~= ROLE_SCP106 then return end  --  check player is a SCP
    
  BroadcastLua( "surface.PlaySound( \"" .. SOUND_106CON .. "\" )" )
end )

hook.Add( "DoPlayerDeath", "049Contain", function( ply )
  if ply:GetNClass() ~= ROLE_SCP049 then return end  --  check player is a SCP
      
  BroadcastLua( "surface.PlaySound( \"" .. SOUND_049CON .. "\" )" )
end )

hook.Add( "DoPlayerDeath", "096Contain", function( ply )
  if ply:GetNClass() ~= ROLE_SCP096 then return end  --  check player is a SCP
    
  BroadcastLua( "surface.PlaySound( \"" .. SOUND_096CON .. "\" )" )
end )

hook.Add( "DoPlayerDeath", "939Contain", function( ply )
  if ply:GetNClass() ~= ROLE_SCP939 then return end  --  check player is a SCP
    
  BroadcastLua( "surface.PlaySound( \"" .. SOUND_939CON .. "\" )" )
end )