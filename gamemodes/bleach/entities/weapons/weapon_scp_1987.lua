AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_173")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Kill people"
SWEP.Instructions = "LMB to kill someone"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-1987-J"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AttackDelay = 0.25
SWEP.ISSCP = true
SWEP.droppable = false
SWEP.CColor = Color(0, 255, 0)
SWEP.SnapSound = Sound("snap.wav")
SWEP.teams = { 1 }
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.SpecialDelay = 30
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.NextAttackW = 0

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Think()
end
