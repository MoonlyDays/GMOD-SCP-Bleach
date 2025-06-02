AddCSLuaFile()

if CLIENT then
    SWEP.BounceWeaponIcon = false
end

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.IsSCP = true
SWEP.Droppable = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Automatic = false

SWEP.NextAttackTime = 0
SWEP.NextSpecialTime = 0
SWEP.AttackDelay = 0.25
SWEP.SpecialDelay = 4

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if self.NextAttackTime > CurTime() then
        return
    end

    if not IsFirstTimePredicted() then
        return
    end

    self.NextAttackTime = CurTime() + self.AttackDelay
    if not SERVER then
        return
    end

    local ent = nil
    local tr = util.TraceHull({
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 100),
        filter = self.Owner,
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10),
        mask = MASK_SHOT_HULL
    })

    ent = tr.Entity
    if IsValid(ent) then
        if ent:IsPlayer() then
            if ent:Team() == TEAMS.SCP then
                return
            end
            if ent:Team() == TEAMS.SPECTATOR then
                return
            end

            self:PerformAttack(ent)
        else
            if ent:GetClass() == "func_breakable" then
                ent:TakeDamage(100, self.Owner, self.Owner)
            end
        end
    end
end

function SWEP:SecondaryAttack()
    if self.NextSpecialTime > CurTime() then
        return
    end

    if not IsFirstTimePredicted() then
        return
    end

    self.NextSpecialTime = CurTime() + self.SpecialDelay
    if not SERVER then
        return
    end

    self:PerformSpecial()
end

function SWEP:PerformAttack(poorSoul)
end

function SWEP:PerformSpecial()
end

function SWEP:DrawHUD()
    self:DrawAttackHUD()
    self:DrawSpecialHUD()
end

function SWEP:DrawAttackHUD()
    local showText = "Готов к атаке"
    local available = true
    if not self:CanPrimaryAttack() then
        showText = "падажжи"
        available = false
    end

    self:DrawActionHUD(showText, available, 1)
end

function SWEP:DrawSpecialHUD()
    local showText = "Особое умение готово " .. self.NextSpecialTime
    local available = true
    if not self:CanSecondaryAttack() then
        showText = "Особое умение не готово"
        available = false
    end

    self:DrawActionHUD(showText, available, 2)
end

function SWEP:DrawActionHUD(text, available, offsetY)
    local showColor = Color(255, 0, 0)
    if available then
        showColor = Color(0, 255, 0)
    end

    draw.Text({
        text = text,
        pos = { ScrW() / 2, ScrH() - offsetY * 30 },
        font = "173font",
        color = showColor,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })
end