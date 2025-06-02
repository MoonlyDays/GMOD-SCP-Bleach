AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_457")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Burn"
SWEP.Instructions = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-457"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
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
SWEP.NextAbilityCheck = 0
SWEP.SpecialDelay = 4
SWEP.CColor = Color(0, 255, 0)
SWEP.NextSpecial = 0

function SWEP:OnRemove()
    if not SERVER then
        return
    end

    if IsValid(self.Fire457) then
        self.Fire457:Remove()
    end

    if self.Owner:IsPlayer() == true then
        if self.Owner:GetNClass() ~= ROLES.ROLE_SCP457 then
            self.Owner:UnIgnitePlayer()
        end
    end
end

function SWEP:Holster()
    if SERVER then
        if IsValid(self.Fire457) then
            self.Fire457:Remove()
        end
        if self.Owner:IsPlayer() == true then
            self.Owner:UnIgnitePlayer()
        end
    end
    return true
end

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
    self:SetNWInt("NextSpecial", 0)
end

function SWEP:Think()
    if not SERVER then
        return
    end

    if self.NextAbilityCheck < CurTime() then
        self.Owner:IgnitePlayer()
        self.NextAbilityCheck = CurTime() + 10
    end

    for k, v in pairs(ents.FindInSphere(self.Owner:GetPos(), 130)) do
        if v:IsPlayer() then
            if v:Team() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_SCP and v:Team() ~= TEAM_SCP and v:Alive() then
                v:Ignite(6, 270)
            end
        end
    end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if preparing or postround then
        return
    end
    if not IsFirstTimePredicted() then
        return
    end
    if SERVER then
        local ent = self.Owner:GetEyeTrace().Entity
        if ent:GetPos():Distance(self.Owner:GetPos()) < 125 then
            if ent:GetClass() == "func_breakable" then
                ent:TakeDamage(1000, self.Owner, self.Owner)
            end
        end
    end
end

function SWEP:CreateFire()
    if preparing then
        return false
    end
    --local tr = self.Owner:GetEyeTrace()
    local tr = util.TraceLine({
        start = self.Owner:GetPos(),
        endpos = self.Owner:GetPos() + Angle(90, 0, 0):Forward() * 10000
    })

    if tr.HitSky == true or tr.Hit == false or tr.HitWorld == false or self.Owner:GetPos():Distance(tr.HitPos) > 300 then
        return false
    end
    if SERVER then
        if IsValid(self.Fire457) then
            self.Fire457:Remove()
        end
        --[[
        self.fire457 = ents.Create("env_steam")
        if !self.fire457 or !self.fire457:IsValid() then return false end
        self.fire457:SetPos(tr.HitPos)
        self.fire457:SetKeyValue("EndSize", "30")
        self.fire457:SetKeyValue("InitialState", "1")
        self.fire457:SetKeyValue("JetLength", "160")
        self.fire457:SetKeyValue("Rate", "26")
        self.fire457:SetKeyValue("RollSpeed", "10")
        self.fire457:SetKeyValue("Speed", "100")
        self.fire457:SetKeyValue("SpreadSpeed", "20")
        self.fire457:SetKeyValue("StartSize", "10")
        self.fire457:Spawn()
        self.fire457:Activate()
        self.fire457:Fire("StartFire","",0)
        self.fire457.owner = self.Owner
        self.fire457.scpFire = true
        ]]
        sound.Play("ambient/fire/ignite.wav", tr.HitPos, 72, 100)
        self.Fire457 = ents.Create("env_fire")
        if not self.Fire457 or not self.Fire457:IsValid() then
            return false
        end
        self.Fire457:SetPos(tr.HitPos)
        self.Fire457:SetKeyValue("health", "512")
        self.Fire457:SetKeyValue("firesize", "128")
        self.Fire457:SetKeyValue("fireattack", "1")
        self.Fire457:SetKeyValue("damagescale", "16")
        self.Fire457:SetKeyValue("ignitionpoint", "0")
        self.Fire457:Spawn()
        self.Fire457:Activate()
        self.Fire457:Fire("StartFire", "", 0)
        self.Fire457.owner = self.Owner
        self.Fire457.scpFire = true
        self.NextSpecial = CurTime() + self.SpecialDelay
        self:SetNWInt("NextSpecial", self.NextSpecial)
    end
    return true
end

function SWEP:SecondaryAttack()
    if SERVER then
        if self.NextSpecial > CurTime() then
            return
        end
        if self:CreateFire() == true then
            self:CreateFire()
        end
    end
end

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:DrawHUD()
    local specialStatus = ""
    local showText = ""
    local lookColor = Color(0, 255, 0)
    local showColor = Color(17, 145, 66)
    local nextSpecial = self:GetNWInt("NextSpecial", 0)
    if nextSpecial > CurTime() then
        specialStatus = "ready to use in " .. math.Round(nextSpecial - CurTime())
        showColor = Color(145, 17, 62)
    else
        specialStatus = "ready to use"
    end

    showText = "Special " .. specialStatus
    draw.Text({
        text = showText,
        pos = { ScrW() / 2, ScrH() - 25 },
        font = "173font",
        color = showColor,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })

    local x = ScrW() / 2.0
    local y = ScrH() / 2.0
    local scale = 0.3
    surface.SetDrawColor(self.CColor.r, self.CColor.g, self.CColor.b, 255)
    local gap = 5
    local length = gap + 20 * scale
    surface.DrawLine(x - length, y, x - gap, y)
    surface.DrawLine(x + length, y, x + gap, y)
    surface.DrawLine(x, y - length, x, y - gap)
    surface.DrawLine(x, y + length, x, y + gap)
end