SWEP.Base = "keycard_base"
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_keycard3")
    SWEP.BounceWeaponIcon = false
end

SWEP.Instructions = "If you hold it, you can open doors with level 3"
SWEP.PrintName = "Keycard Level 3"
SWEP.clevel = 3
SWEP.keycard_skin = 2
function SWEP:GetBetterOne()
    local r = math.random(1, 100)
    if buttonstatus == 3 then
        if r < 50 then
            return "keycard_level4"
        else
            return "keycard_level3"
        end
    elseif buttonstatus == 4 then
        if r < 20 then
            return "keycard_level5"
        elseif r < 40 then
            return "keycard_level4"
        else
            return "keycard_level3"
        end
    end
    return "keycard_level3"
end