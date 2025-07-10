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

    if IsValid(self.fireEntity) and IsEntity(self.fireEntity) then
        self.fireEntity:Remove()
    end
end

function SWEP:IgniteOwner()
    if not SERVER then
        return
    end

    self:Extinguish()
    self.fireEntity = ents.Create("env_fire")
    self.fireEntity:SetPos(self:GetPos())
    self.fireEntity:SetKeyValue("health", "512")
    self.fireEntity:SetKeyValue("firesize", "128")
    self.fireEntity:SetKeyValue("fireattack", "0")
    self.fireEntity:SetKeyValue("damagescale", "-1")
    self.fireEntity:SetKeyValue("ignitionpoint", "1200")
    self.fireEntity:Spawn()
    self.fireEntity:Activate()
    self.fireEntity:Fire("StartFire", "", 0)
    self.fireEntity:SetParent(self)
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
            ent:Ignite(10, 270)
        end
    end
end
