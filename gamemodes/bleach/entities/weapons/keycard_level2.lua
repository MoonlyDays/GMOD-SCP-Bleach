SWEP.Base = "keycard_base"
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_keycard2")
    SWEP.BounceWeaponIcon = false
end

SWEP.Instructions = "If you hold it, you can open doors with level 2"
SWEP.PrintName = "Keycard Level 2"
SWEP.ClearanceLevel = 2
SWEP.keycard_skin = 1

function SWEP:GetBetterOne()
    local r = math.random(1, 100)
    if buttonstatus == 3 then
        if r < 50 then
            return "keycard_level3"
        else
            return "keycard_level2"
        end
    elseif buttonstatus == 4 then
        if r < 20 then
            return "keycard_level4"
        elseif r < 40 then
            return "keycard_level3"
        else
            return "keycard_level2"
        end
    end
    return "keycard_level2"
end