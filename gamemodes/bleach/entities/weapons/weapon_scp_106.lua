AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_106")
    SWEP.BounceWeaponIcon = false
end

SWEP.Base = "weapon_scp_base"
SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Destroy"
SWEP.Instructions = "LMB to hit something"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-106"
SWEP.EnterSound = Sound("PocketDimension/Enter.ogg")

function SWEP:PerformAttack(ent)
    if not SERVER then
        return
    end

    local pos = table.Random(MAP.POCKET_DIMENSION.ENTRANCES)
    BREACH:AddStat(STATS.SCP_106_CAPTURED, 1)
    self.Owner:SetHealth(self.Owner:Health() + 100)
    ent:SetPos(pos)
    ent:EmitSound(self.EnterSound)
end