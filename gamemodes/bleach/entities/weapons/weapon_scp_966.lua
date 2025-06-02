AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_966")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Kill humans"
SWEP.Instructions = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-966"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.HoldType = "normal"
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

SWEP.Next966Sound = 0
SWEP.Sounds966 = {
    { "966/Echo1.ogg", 6.175 },
    { "966/Echo2.ogg", 8.139 },
    { "966/Echo2.ogg", 7.437 },
    { "966/Idle1.ogg", 2.483 },
    { "966/Idle2.ogg", 6.177 },
    { "966/Idle3.ogg", 7.036 },
}

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Reload()
end

function SWEP:Think()
    if self.Next966Sound > CurTime() then
        return
    end

    local randomSound = table.Random(self.Sounds966)
    self.Owner:EmitSound(randomSound[1], 65, 100, 0.6)
    self.Next966Sound = CurTime() + randomSound[2] + 1
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then
        return
    end

    if self.NextAttackTime > CurTime() then
        return
    end

    self.NextAttackTime = CurTime() + self.AttackDelay
    if SERVER then
        local ent = nil
        local hullsize = 10
        local tr = util.TraceHull({
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 160),
            filter = self.Owner,
            mins = Vector(-hullsize, -hullsize, -hullsize),
            maxs = Vector(hullsize, hullsize, hullsize),
            mask = MASK_SHOT_HULL
        })

        ent = tr.Entity
        if IsValid(ent) then
            if ent:IsPlayer() then
                if ent:Team() == TEAMS.SPECTATOR then
                    return
                end
                if ent:Team() == TEAMS.SCP then
                    return
                end
                if ent:Alive() then
                    ent:TakeDamage(22, self.Owner, self.Owner)
                    self.Owner:EmitSound("damage_966.ogg")
                end
            else
                if ent:GetClass() == "func_breakable" then
                    ent:TakeDamage(22, self.Owner, self.Owner)
                    self.Owner:EmitSound("damage_966.ogg")
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
    return true
end