AddCSLuaFile()

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_457")
    SWEP.BounceWeaponIcon = false
end

SWEP.Base = "weapon_scp_base"
SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Burn"
SWEP.Instructions = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-457"
SWEP.NextThinkTime = 0

function SWEP:ExtinguishOwner()
    if not SERVER then
        return
    end

    if IsValid(self.fire) and IsEntity(self.fire) then
        self.fire:Remove()
    end
end

function SWEP:IgniteOwner()
    if not SERVER then
        return
    end

    self:Extinguish()
    self.fire = ents.Create("env_fire")
    self.fire:SetPos(self:GetPos())
    self.fire:SetKeyValue("health", "512")
    self.fire:SetKeyValue("firesize", "128")
    self.fire:SetKeyValue("fireattack", "0")
    self.fire:SetKeyValue("damagescale", "-1")
    self.fire:SetKeyValue("ignitionpoint", "1200")
    self.fire:Spawn()
    self.fire:Activate()
    self.fire:Fire("StartFire", "", 0)
    self.fire:SetParent(self)
end

function SWEP:OnRemove()
    if not SERVER then
        return
    end

    self:ExtinguishOwner()
end

function SWEP:Holster()
    if SERVER then
        self:ExtinguishOwner()
    end

    return true
end

function SWEP:CanTarget(ply)

    return IsValid(ply)
            and ply:IsPlayer()
            and ply:IsPlaying()
            and ply ~= self.Owner
            and ply:Team() ~= TEAMS.SCP
end

function SWEP:Think()
    if CLIENT then
        return
    end

    if self.NextThinkTime > CurTime() then
        return
    end

    self.NextThinkTime = CurTime() + 10
    self:IgniteOwner()

    for _, ent in pairs(ents.FindInSphere(self.Owner:GetPos(), 130)) do
        if self:CanTarget(ent) then
            ent:Ignite(6, 270)
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
