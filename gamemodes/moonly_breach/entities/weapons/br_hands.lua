AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_hands")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Dragon4k"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Hands"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.PrintName = "Hands"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.droppable = false
SWEP.teams = {2, 3, 5, 6}
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
	if not IsValid(self.Owner) then self:DrawModel() end
end

SWEP.Lang = nil
function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetSkin(0)
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
end