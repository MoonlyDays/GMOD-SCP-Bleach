AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/m249")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Steam"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.HoldType = "ar2"
SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.PrintName = "M249"
SWEP.Base = "weapon_breach_base"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.Primary.ClipSize = 120
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Sound = Sound("Weapon_M249.Single")
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 2
SWEP.Primary.Cone = 0.05
SWEP.Primary.Delay = 0.10
SWEP.Secondary.Ammo = "none"
SWEP.DeploySpeed = 1
SWEP.Damage = 8
SWEP.HeadshotMultiplier = 1.7
SWEP.UseHands = true
SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX = true
SWEP.droppable = true
SWEP.teams = {2, 3, 5, 6}
SWEP.IDK = 90
SWEP.ZoomFov = 90
SWEP.HasScope = false
SWEP.DrawCustomCrosshair = true