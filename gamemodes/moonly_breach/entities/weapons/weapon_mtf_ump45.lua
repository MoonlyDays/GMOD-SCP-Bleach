AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/ump45")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Steam"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.HoldType = "smg"
SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.PrintName = "UMP45"
SWEP.Base = "weapon_breach_base"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.betterone = "weapon_mtf_p90"
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 2
SWEP.Primary.Cone = 0.013
SWEP.Primary.Delay = 0.08
SWEP.Secondary.Ammo = "none"
SWEP.DeploySpeed = 1
SWEP.Damage = 10
SWEP.HeadshotMultiplier = 1.6
SWEP.UseHands = true
SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX = false
SWEP.droppable = true
SWEP.teams = {2, 3, 5, 6}
SWEP.IDK = 105
SWEP.ZoomFov = 90
SWEP.HasScope = false
SWEP.DrawCustomCrosshair = true