AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_939")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = "SCP-939"
SWEP.ViewModelFOV = 56
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "None"
SWEP.Primary.Sound = "breach/939/bite.ogg"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 5
SWEP.Secondary.Ammo = "None"
SWEP.ISSCP = true
SWEP.droppable = false
SWEP.CColor = Color(0, 255, 0)
SWEP.teams = {1}
SWEP.Weight = 3
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.IconLetter = "w"
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self.Owner:DrawWorldModel(false)
		self.Owner:DrawViewModel(false)
	end
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
end

SWEP.NextPrimary = 0
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if not SERVER then return end
	local tr = util.TraceHull({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
		maxs = Vector(10, 10, 10),
		mins = Vector(-10, -10, -10),
		filter = self.Owner,
		mask = MASK_SHOT
	})

	local ent = tr.Entity
	if IsValid(ent) then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_SPECTATOR then return end
			if ent:Team() == TEAM_SCP then return end
			self.Owner:EmitSound(self.Primary.Sound)
			ent:TakeDamage(math.random(20, 50), self.Owner, self.Owner)
			--self.Owner:SetHealth(self.Owner:Health() + 30) --disabled coz 939 is so op ;p
		else
			if ent:GetClass() == "func_breakable" then ent:TakeDamage(100, self.Owner, self.Owner) end
		end
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local showtext = clang.readytoattack
	local showcolor = Color(0, 255, 0)
	if self.NextPrimary > CurTime() then
		showtext = clang.nextattack .. "" .. math.Round(self.NextPrimary - CurTime())
		showcolor = Color(255, 0, 0)
	end

	draw.Text({
		text = showtext,
		pos = {ScrW() / 2, ScrH() - 30},
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end