AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_049")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Cure"
SWEP.Instructions = "LMB to cure someone"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-049"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AttackDelay = 0.25
SWEP.ISSCP = true
SWEP.droppable = false
SWEP.teams = { TEAM_SCP }
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
    if not self:CanPrimaryAttack() then
        return
    end

    if not IsFirstTimePredicted() then
        return
    end

    if self.NextAttackTime > CurTime() then
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

            local curPos = ent:GetPos();
            ent:SpawnAs("scp_049_2");
            ent:SetPos(curPos)
            BREACH:AddStat(STATS.SCP_049_CURED, 1)
        else
            if ent:GetClass() == "func_breakable" then
                ent:TakeDamage(100, self.Owner, self.Owner)
            end
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
    return BREACH.currentState == ROUND_STATES.ACTIVE
end
