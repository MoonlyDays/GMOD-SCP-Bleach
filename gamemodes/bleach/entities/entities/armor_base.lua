AddCSLuaFile()
ENT.PrintName = "Base Armor"
ENT.Author = "Kanade"
ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
    self.Entity:SetModel("models/combine_vests/militaryvest.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_NONE)
    self.Entity:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end
end

function ENT:Use(ply)
    if not ply:CanUseItems() then
        return
    end

    if ply.UsingArmor then
        ply:PrintMessage(HUD_PRINTTALK, 'You already have a vest, type "dropvest" in the chat to drop it')
        return
    end

    if SERVER then
        ply:EquipArmor(self.ArmorType)
        self:Remove()
    end

    if CLIENT then
        chat.AddText('You are now wearing an armor, type "dropvest" in the chat to drop it')
    end
end

function ENT:Draw()
    self:DrawModel()

    local ply = LocalPlayer()
    if ply:GetPos():Distance(self:GetPos()) > 180 then
        return
    end

    if not IsValid(self) then
        return
    end

    cam.Start2D()
    draw.WorldText(self:GetPos() + Vector(0, 0, 15), self.PrintName, Color(255, 255, 255))
    cam.End2D()
end