AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_049")
    SWEP.BounceWeaponIcon = false
end

SWEP.Base = "weapon_scp_base"
SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Cure"
SWEP.Instructions = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-049-2"
SWEP.NextThinkTime = 0

function SWEP:PerformAttack(ent)
    if not SERVER then
        return
    end

    ent:TakeDamage(35)
end