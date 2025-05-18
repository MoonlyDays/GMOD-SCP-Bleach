
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycardomni")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Open certain doors"
SWEP.Instructions	= "If you hold it, you can open doors with every level"

SWEP.ViewModelFOV	= 66
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/wania/c_keycard.mdl"
SWEP.WorldModel		= "models/breach/keycard.mdl"
SWEP.UseHands		= true
SWEP.PrintName		= "Keycard Omni"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

function SWEP:GetBetterOne()
	local r = math.random(1,100)
	if r < 25 then
		return "ent_aaaaaaaaaaaaaaaaaaa"
	else
		return "keycard_omni"
	end
end
SWEP.droppable				= true
SWEP.clevel					= 5
SWEP.teams					= {2,3,5,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( true )
	self.Owner:GetViewModel():SetSkin(10)
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetSkin(5)
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