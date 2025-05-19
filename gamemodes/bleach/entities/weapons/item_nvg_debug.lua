AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_nvg")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.WorldModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.PrintName		= "NVG Debug"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.teams					= {TEAM_GUARD, TEAM_CLASSD, TEAM_SCI, TEAM_CHAOS, TEAM_STAFF}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetSkin(1)
end
function SWEP:Think()
end
function SWEP:Reload()
end

SWEP.NVGenabled	= false
SWEP.NVG = {
	
	0.15, // contrast
	1.1, // colour
	0.05, // brightness
	0, // clr_r
	0, // clr_g
	0, // clr_b
	0, // vignette_alpha
	function() // effects
	end,
	function() // fog
		render.FogStart(1)
		render.FogEnd(1200)
		render.FogColor( 2, 6, 2 )
		render.FogMaxDensity( 0 )
		render.FogMode( MATERIAL_FOG_LINEAR )
		return true
	end
	
	/*
	0, // contrast
	1, // colour
	-0.1, // brightness
	0, // clr_r
	0, // clr_g
	0, // clr_b
	0, // vignette_alpha
	function() // effects
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		if dlight then
			dlight.pos = LocalPlayer():GetShootPos()
			dlight.r = 3
			dlight.g = 2
			dlight.b = 1
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 4000
			dlight.DieTime = CurTime() + 0.1
		end
	end,
	function() // fog
		render.FogStart(1)
		render.FogEnd(600)
		render.FogColor(0, 0, 0)
		render.FogMaxDensity(1)
		render.FogMode(MATERIAL_FOG_LINEAR)
		return true
	end
	*/
}

SWEP.NextChange = 0
function SWEP:PrimaryAttack()
	if self.NextChange < CurTime() then
		self.NVGenabled = !self.NVGenabled
		self.NextChange = CurTime() + 0.5
		if CLIENT then
			surface.PlaySound('pickitem2.ogg')
		end
	end
end

function SWEP:OnRemove()
end
function SWEP:Holster()
	return true
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end

function SWEP:DrawHUD()
	if self.NVGenabled == false then
		draw.Text( {
			text = "Click LMB to put on the NVG",
			//pos = { rx + 52, ry * 1.79 },
			pos = { ScrW() / 2, ScrH() - 15},
			font = "RadioFont",
			color = color_white,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		})
	end
end
