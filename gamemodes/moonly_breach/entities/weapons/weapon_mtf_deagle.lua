AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/deserteagle")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Steam"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.HoldType = "pistol"
SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.PrintName = "Deagle"
SWEP.Base = "weapon_breach_base"
SWEP.DrawCrosshair = false
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Sound = Sound("Weapon_DEagle.Single")
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 3.2
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.35
SWEP.Secondary.Ammo = "none"
SWEP.DeploySpeed = 1
SWEP.Damage = 30
SWEP.HeadshotMultiplier = 1.6
SWEP.UseHands = true
SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX = false
SWEP.droppable = true
SWEP.teams = {2, 3, 5, 6}
SWEP.IDK = 125
SWEP.ZoomFov = 90
SWEP.HasScope = false
SWEP.DrawCustomCrosshair = true