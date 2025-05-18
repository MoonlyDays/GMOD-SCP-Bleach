AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/mp5")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Steam"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.HoldType = "smg"
SWEP.ViewModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.PrintName = "MP5"
SWEP.Base = "weapon_breach_base"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 1.7
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = 0.08
SWEP.Secondary.Ammo = "none"
SWEP.DeploySpeed = 1
SWEP.Damage = 9
SWEP.HeadshotMultiplier = 1.6
SWEP.UseHands = true
SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX = false
SWEP.droppable = true
SWEP.teams = {2, 3, 5, 6}
SWEP.IDK = 120
SWEP.ZoomFov = 90
SWEP.HasScope = false
SWEP.DrawCustomCrosshair = true