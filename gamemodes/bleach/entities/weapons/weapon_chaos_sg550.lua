AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/gfx/vgui/sg550")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Steam"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.ViewModelFOV = 57
SWEP.ViewModelFlip = false
SWEP.HoldType = "ar2"
SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.PrintName = "SG550"
SWEP.Base = "weapon_breach_base"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.Spawnable = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Sound = Sound("Weapon_SG550.Single")
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 2.6
SWEP.Primary.Cone = 0.0001
SWEP.Primary.Delay = 0.25
SWEP.Secondary.Ammo = "none"
SWEP.DeploySpeed = 1
SWEP.Damage = 19
SWEP.HeadshotMultiplier = 1.7
SWEP.UseHands = true
SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX = true
SWEP.droppable = true
SWEP.teams = { TEAM_GUARD, TEAM_CLASS_D, TEAM_SCIENTIST, TEAM_CHAOS, TEAM_STAFF}
SWEP.IDK = 1000
SWEP.ZoomFov = 30
SWEP.HasScope = true
SWEP.DrawCustomCrosshair = true