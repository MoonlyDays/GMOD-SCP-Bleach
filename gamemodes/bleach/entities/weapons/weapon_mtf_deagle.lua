AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/deserteagle")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 50
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "revolver"
SWEP.ViewModel 		= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_deagle.mdl"
SWEP.PrintName		= "Deagle"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 2
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Sound			= Sound("Weapon_DEagle.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 5
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 0.225

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 34
SWEP.HeadshotMultiplier		= 1.7
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= false

SWEP.droppable				= true
SWEP.teams					= {TEAM_GUARD, TEAM_CLASSD, TEAM_SCI, TEAM_CHAOS, TEAM_STAFF}
SWEP.IDK					= 125
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= true
