AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_medkit")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Heal yourself or other people"
SWEP.Instructions = [[Primary - heal yourself
Secondary - heal others]]
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/sweps/scpsl/medkit/v_medkit.mdl"
SWEP.WorldModel = "models/vinrax/props/firstaidkit.mdl"
SWEP.PrintName = "First Aid kit"
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
	self.Owner:EmitSound("breach/items/medkit/medkitdeploy.wav")
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
	if self.Owner:Health() / self.Owner:GetMaxHealth() <= 0.9 then
		if SERVER then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() + 0)
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Owner:EmitSound("breach/items/medkit/medkituse.ogg")
			timer.Simple(3, function() self.Owner:StripWeapon("item_medkit") end)
			local function SetHP()
				self.Owner:SetHealth(self.Owner:Health() + 50)
				if self.Owner:Health() / self.Owner:GetMaxHealth() >= 1.0 then self.Owner:SetHealth(self.Owner:GetMaxHealth()) end
			end

			timer.Simple(2.9, SetHP)
		end
	else
		if SERVER then self.Owner:PrintMessage(HUD_PRINTTALK, "You don't need healing yet") end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if ent:IsPlayer() then
			if ent:Team() == TEAM_SCP then return end
			if ent:Team() == TEAM_SPECTATOR then return end
			if ent:GetPos():Distance(self.Owner:GetPos()) < 95 then
				if ent:Health() / ent:GetMaxHealth() <= 0.9 then
					ent:SetHealth(ent:Health() + 50)
					if ent:Health() / ent:GetMaxHealth() >= 1.0 then ent:SetHealth(ent:GetMaxHealth()) end
					self.Owner:StripWeapon("item_medkit")
				else
					self.Owner:PrintMessage(HUD_PRINTTALK, ent:Nick() .. " doesn't need healing yet")
				end
			end
		end
	end
end

function SWEP:CanPrimaryAttack()
end