AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_scp_500")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/sweps/scpsl/500/v_500.mdl"
SWEP.WorldModel = "models/weapons/scp500/scp500model.mdl"
SWEP.PrintName = "SCP-500"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.UseHands = true
SWEP.droppable = true
SWEP.teams = {2, 3, 5, 6}
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = 0
	self.Owner:EmitSound("breach/items/500/scp500deploy.wav")
end

function SWEP:DrawWorldModel()
	if not IsValid(self.Owner) then self:DrawModel() end
end

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Think()
	if self.Idle == 0 and self.IdleTimer <= CurTime() then -- Idle Sequence
		self:SendWeaponAnim(ACT_VM_IDLE)
		self.Idle = 1
	end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if self.Owner:Health() / self.Owner:GetMaxHealth() == 1.0 then
		if SERVER then
			self:SendWeaponAnim(ACT_VM_IDLE)
			self.Owner:PrintMessage(HUD_PRINTTALK, "You don't need to swallow the pill")
		end
	else
		if self.Owner:Health() / self.Owner:GetMaxHealth() <= 1.0 then
			if SERVER then
				self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() + 0)
				self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				self.Owner:EmitSound("breach/items/500/scp500use.wav")
				timer.Simple(1, function() self.Owner:SetHealth(self.Owner:GetMaxHealth()) end)
				timer.Simple(1, function() self.Owner:StripWeapon("item_scp_500") end)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if ent:IsPlayer() then
			if ent:Team() == TEAM_SCP then return end
			if ent:Team() == TEAM_SPECTATOR then return end
			if ent:GetPos():Distance(self.Owner:GetPos()) < 95 then
				if ent:Health() / ent:GetMaxHealth() <= 1.0 then
					ent:SetHealth(ent:GetMaxHealth())
					self.Owner:StripWeapon("item_scp_500")
				else
					self.Owner:PrintMessage(HUD_PRINTTALK, ent:Nick() .. " doesn't need to swallow the pill")
				end
			end
		end
	end
end

function SWEP:CanPrimaryAttack()
end