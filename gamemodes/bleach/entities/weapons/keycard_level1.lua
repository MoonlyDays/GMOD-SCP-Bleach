SWEP.Base = "keycard_base"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_keycard1")
	SWEP.BounceWeaponIcon = false
end

SWEP.Instructions = "If you hold it, you can open doors with level 1"
SWEP.PrintName = "Keycard Level 1"
SWEP.clevel = 1
SWEP.keycard_skin = 0
function SWEP:GetBetterOne()
	local r = math.random(1, 100)
	if buttonstatus == 3 then
		if r < 50 then
			return "keycard_level2"
		else
			return "keycard_level1"
		end
	elseif buttonstatus == 4 then
		if r < 20 then
			return "keycard_level3"
		elseif r < 40 then
			return "keycard_level2"
		else
			return "keycard_level1"
		end
	end
	return "keycard_level1"
end