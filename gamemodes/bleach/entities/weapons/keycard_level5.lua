SWEP.Base = "keycard_base"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_keycard5")
	SWEP.BounceWeaponIcon = false
end

SWEP.Instructions = "If you hold it, you can open doors with level 5"
SWEP.PrintName = "Keycard Level 5"
SWEP.clevel = 5
SWEP.keycard_skin = 4
function SWEP:GetBetterOne()
	local r = math.random(1, 100)
	if buttonstatus == 3 then
		if r < 30 then
			return "keycard_omni"
		else
			return "keycard_level5"
		end
	elseif buttonstatus == 4 then
		if r < 45 then
			return "keycard_omni"
		else
			return "keycard_level5"
		end
	end
	return "keycard_level4"
end