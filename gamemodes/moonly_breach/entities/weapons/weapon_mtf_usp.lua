AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/usp45")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "pistol"
SWEP.ViewModel 		= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_usp.mdl"
SWEP.PrintName		= "USP-45"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 2
SWEP.Spawnable		= true

SWEP.betterone = "weapon_mtf_deagle"
SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Cone			= 0.05
SWEP.Primary.Delay			= 0.25

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 12
SWEP.HeadshotMultiplier		= 1.6
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= false

SWEP.droppable				= true
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 125
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= true
