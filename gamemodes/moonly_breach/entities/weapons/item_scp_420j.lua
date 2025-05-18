AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_scp_420j")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/bt/c_scp_420j.mdl"
SWEP.WorldModel		= "models/weapons/bt/w_scp_420j.mdl"
SWEP.PrintName		= "SCP-420-J"
SWEP.Slot			= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.UseHands		= true

SWEP.droppable				= true
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
	if not IsFirstTimePredicted() then return end
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Idledelay = CurTime() + 0.5
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Think()
	if not IsFirstTimePredicted() then return end
	if self.Idledelay <= CurTime() and self.LoopLockidle == false then
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CLIENT then surface.PlaySound( "breach/music/Mandeville.ogg" ) end
	self.Owner.n420endtime = CurTime() + 15
	if !SERVER then return end
	local function WypierdalanieBlanta()
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_2)
	end
	timer.Simple( 5, WypierdalanieBlanta )
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	self.Owner:EmitSound("breach/items/420j/lighter_sound.wav")
	local function SetHP()
		self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 15, 0,  self.Owner:GetMaxHealth() ) )
		self.Owner:StripWeapon( self:GetClass() )
	end
	timer.Simple( 6.5, SetHP )
end

function SWEP:SecondaryAttack()
end

function SWEP:PlayerShouldDie()
	self.OnUse()
end