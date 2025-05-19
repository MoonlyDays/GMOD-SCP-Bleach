SWEP.Base = "keycard_base"

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycardk")
	SWEP.BounceWeaponIcon = false
end

SWEP.Instructions	= "If you hold it, you can open doors with every level"
SWEP.PrintName		= "Keycard Kanade"
SWEP.clevel			= 5
SWEP.keycard_skin	= 6

function SWEP:GetBetterOne()
	return "keycard_kanade"
end
