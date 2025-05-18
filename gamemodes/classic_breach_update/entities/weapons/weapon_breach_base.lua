AddCSLuaFile()

SWEP.Author			= "Kanade"
SWEP.Contact		= "Steam"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "smg"
SWEP.ViewModel		= "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel		= "models/weapons/w_smg_p90.mdl"
SWEP.PrintName		= "Breach Base"
SWEP.Base			= "weapon_base"
SWEP.DrawCrosshair	= false
SWEP.Weight			= 5


SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Sound			= Sound("Weapon_P90.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.07

SWEP.Secondary.Sound		= nil
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.Delay		= 0.3
SWEP.Secondary.DefaultClip	= -1

SWEP.ScopeSound				= Sound("Default.Zoom")

SWEP.DeploySpeed			= 1
SWEP.HeadshotMultiplier		= 2

SWEP.Damage					= 14
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= false

SWEP.SavedAmmo				= 0
SWEP.IDK					= 125
SWEP.HeadshotMultiplier		= 2
SWEP.DamageDistanceMul		= 1

// Sights
SWEP.MinFov					= 40
SWEP.ZoomFov				= 90
SWEP.IsScoping				= false
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= true
SWEP.NeedtoScope			= false

// Silencer
SWEP.HasSilencer			= nil
SWEP.SilencerModel 			= nil
SWEP.NormalModel			= nil
SWEP.IsSilenced				= false

function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

function SWEP:Equip()
	if SERVER and IsValid(self.Owner) and self.Primary.Ammo != "none" then
		if self.Owner.gettingammo then
			//print(self.Owner.gettingammo)
			self:SetClip1(self.Owner.gettingammo)
			self.Owner.gettingammo = 0
		end
	end
end

function SWEP:Initialize()
	self.IsSilenced = false
	self:SetHoldType( self.HoldType )
	self:SetDeploySpeed(self.DeploySpeed)
end

function SWEP:PreDrop()
	//if SERVER and IsValid(self.Owner) and self.Primary.Ammo != "none" then
	//	self.SavedAmmo = self:Clip1()
	//end
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	timer.Destroy("needtoscope" .. self.Owner:SteamID())
	self.IsReloading = false
	if self.HasSilencer then
		if self.IsSilenced then
			self.Weapon:EmitSound(self.Secondary.Sound, 50,100,0.5)
		else
			self.Weapon:EmitSound(self.Primary.Sound)
		end
	else
		self.Weapon:EmitSound(self.Primary.Sound)
	end
	local cone = 0.01
	if self.IsScoping then
		cone = self.Primary.Cone / 2
	else
		cone = self.Primary.Cone
	end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	self:TakePrimaryAmmo( self.Primary.NumShots )
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, cone )
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetNextSecondaryFire() > CurTime() then return end
	timer.Destroy("needtoscope" .. self.Owner:SteamID())
	if self.HasScope then
		if self.IsScoping then
			self.IsScoping = false
			if SERVER then
				self.Owner:SetFOV(90, 0.2)
			else
				self:EmitSound(self.ScopeSound)
			end
		else
			self.IsScoping = true
			if SERVER then
				self.Owner:SetFOV(self.ZoomFov, 0.2)
			else
				self:EmitSound(self.ScopeSound)
			end
		end
		//self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
	else
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay)
	end
	if self.HasSilencer then
		self:AttachSilencer()
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay)
	end
end

function SWEP:AttachSilencer()
	if self.IsSilenced then
		self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
		if not (IsFirstTimePredicted() or game.SinglePlayer()) then return end
		self.WorldModel = self.NormalModel
		self.IsSilenced = false
	else
		self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
		if not (IsFirstTimePredicted() or game.SinglePlayer()) then return end
		self.WorldModel = self.SilencerModel
		self.IsSilenced = true
	end
end

if CLIENT then
	local scope = surface.GetTextureID("gmod/scope.vmt")
	function SWEP:DrawHUD()
		if disablehud == true then return end
		if self.HasScope and self.IsScoping and self.ZoomFov <= self.MinFov then
			surface.SetDrawColor( 0, 0, 0, 255 )
			
			local scrW = ScrW()
			local scrH = ScrH()
			local x = scrW / 2.0
			local y = scrH / 2.0
			local length = scrH
			
			surface.DrawLine( x - length, y, x, y )
			surface.DrawLine( x + length, y, x, y )
			surface.DrawLine( x, y - length, x, y )
			surface.DrawLine( x, y + length, x, y )
			length = 50
			
			local sh = scrH / 2
			local w = (x - sh) + 2
			surface.DrawRect(0, 0, w, scrH)
			surface.DrawRect(x + sh - 2, 0, w, scrH)
			surface.DrawLine( 0, 0, scrW, 0 )
			surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )
			surface.SetDrawColor(Color(0,255,0))
			surface.SetTexture(scope)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRectRotated(x, y, ScrW() / 1.5, ScrH(), 0)
		elseif self.DrawCustomCrosshair and self.HasScope and self.IsScoping == false and self.ZoomFov > self.MinFov then
			local cone = 0.01
			if self.IsScoping then
				cone = self.Primary.Cone / 2
			else
				cone = self.Primary.Cone
			end
			local x = math.floor(ScrW() / 2.0)
			local y = math.floor(ScrH() / 2.0)
			local scale = math.max(0.2,  10 * cone)
			
			local LastShootTime = self:LastShootTime()
			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
			surface.SetDrawColor(Color(0,255,0))
			local gap = math.floor(20 * scale) * neutralnum(LocalPlayer():GetVelocity():Length() / self.IDK)
			local length = math.floor(gap + 25 * scale)
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )
		elseif self.DrawCustomCrosshair then
			local cone = 0.01
			if self.IsScoping then
				cone = self.Primary.Cone / 2
			else
				cone = self.Primary.Cone
			end
			local x = math.floor(ScrW() / 2.0)
			local y = math.floor(ScrH() / 2.0)
			local scale = math.max(0.2,  10 * cone)
			
			local LastShootTime = self:LastShootTime()
			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
			surface.SetDrawColor(Color(0,255,0))
			local gap = math.floor(20 * scale) * neutralnum(LocalPlayer():GetVelocity():Length() / self.IDK)
			local length = math.floor(gap + 25 * scale)
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )
		end
	end
	
	function SWEP:AdjustMouseSensitivity()
		if self.IsScoping and self.ZoomFov <= self.MinFov then
			return 0.2
		else
			return nil
		end
	end
	
end

function neutralnum(num)
	if num > 1 then return num end
	if num <= 1 then return 1 end
end

function SWEP:Reload()
	if self.HasSilencer then
		if self.IsSilenced then
			self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED )
		else
			self.Weapon:DefaultReload( ACT_VM_RELOAD )
		end
	else
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
	end
	if self.HasScope then
		if self.IsScoping then
			if self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 and self:Clip1() < self.Primary.ClipSize then 
				timer.Create("needtoscope" .. self.Owner:SteamID(), self.Owner:GetViewModel():SequenceDuration(), 1, function()
					if IsValid(self) and IsValid(self.Owner) then
						self.IsScoping = true
						self.Owner:SetFOV(self.ZoomFov, 0.2)
					end
				end)
				self.IsScoping = false
				self.Owner:SetFOV(90, 0.2)
			end
		end
	end
end

function SWEP:Think()
end

function SWEP:Holster( wep )
	return true
end

function SWEP:Deploy()
	self.IsScoping = false
	if self.HasSilencer then
		if self.IsSilenced then
			self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
		else
			self:SendWeaponAnim(ACT_VM_DRAW)
		end
	else
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
	self.startedreloading = false
	self:SetDeploySpeed(self.DeploySpeed)
	return true
end

function SWEP:ShootEffects()
	if self.HasSilencer then
		if self.IsSilenced then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		else
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		end
	else
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	end
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:ShootBullet( damage, recoil, num_bullets, aimcone )
	local meme = neutralnum(self.Owner:GetVelocity():Length() / 25)
	local gap = aimcone + (meme / (self.IDK * 4))
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.HullSize	= 1.25
	bullet.Src 		= self.Owner:GetShootPos()			-- Source
	bullet.Dir 		= self.Owner:GetAimVector()			-- Dir of bullet
	bullet.Spread 	= Vector( gap, gap, 0 )				-- Aim Cone
	bullet.Tracer	= 5									-- Show a tracer on every x bullets 
	bullet.Force	= 1									-- Amount of force to give to phys objects
	bullet.Damage	= self.Damage
	bullet.AmmoType = self.Primary.Ammo
	
	self:ShootEffects()
	
	bullet.Callback = function( attacker, tr, dmginfo)
		if attacker:IsPlayer() then
			if SERVER then
				if tr.Entity:GetClass() == "prop_vehicle_prisoner_pod" or tr.Entity:IsVehicle() then
					if tr.Entity:GetDriver() ~= NULL then
						tr.Entity:GetDriver():TakeDamageInfo(dmginfo)
					end
				end
			end
			
		end
	end
	
   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = (recoil * 0.6) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )
   end
	
	self.Owner:FireBullets( bullet )
  
end

function SWEP:TakePrimaryAmmo( num )
	if ( self.Weapon:Clip1() <= 0 ) then 
		if ( self:Ammo1() <= 0 ) then return end
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	return end
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	
end

function SWEP:CanPrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return false end
	if ( self.Weapon:Clip1() <= 0 ) then
	
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:Reload()
		return false
		
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	return true
end

function SWEP:CanSecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return false end
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	return true
end

function SWEP:OnRemove()
	self:SetHoldType(self.HoldType)
end

function SWEP:OwnerChanged()
end

function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end

function SWEP:Ammo2()
	return self.Owner:GetAmmoCount( self.Weapon:GetSecondaryAmmoType() )
end

function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end
