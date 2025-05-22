AddCSLuaFile()
ENT.Type = "anim"
ENT.AmmoID = 0
ENT.AmmoType = "Pistol"
ENT.PName = "Base Ammo"
ENT.AmmoAmount = 1
ENT.MaxUses = 2
ENT.Model = Model("models/items/boxsrounds.mdl")

function ENT:Initialize()
    self:SetModel(self.Model)
    self.Entity:SetMoveType(MOVETYPE_NONE)
    self.Entity:SetSolid(SOLID_BBOX)
    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end
    if self.ColorFix then
        self:SetColor(self.ColorFix)
    end
end

function ENT:Use(ply)
    if not ply:CanUseItems() then
        return
    end

    local hasWep = false
    for _, wep in pairs(ply:GetWeapons()) do
        if wep.Primary and wep.Primary.Ammo == self.AmmoType then
            hasWep = true
            break
        end
    end

    if not hasWep then
        ply:PrintMessage(HUD_PRINTCENTER, "No suitable weapon for this ammo type (" .. self.AmmoType .. ")")
        return
    end

    ply.PickedAmmo = ply.PickedAmmo or {}
    if activator.MaxUses ~= nil then
        if self.AmmoID > #activator.MaxUses then
            for i = 1, self.AmmoID do
                if activator.MaxUses[i] == nil then
                    if i == self.AmmoID then
                        table.ForceInsert(activator.MaxUses, 1)
                        activator:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
                        self:Remove()
                    else
                        table.ForceInsert(activator.MaxUses, 0)
                    end
                end
            end
        else
            if activator.MaxUses[self.AmmoID] >= self.MaxUses then
                activator:PrintMessage(HUD_PRINTCENTER, "You cannot pick-up more ammo")
                return
            else
                activator.MaxUses[self.AmmoID] = activator.MaxUses[self.AmmoID] + 1
                activator:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
                self:Remove()
            end
        end
    else
        activator.MaxUses = {}
        if self.AmmoID ~= 1 then
            for i = 1, self.AmmoID do
                if i == self.AmmoID then
                    table.ForceInsert(activator.MaxUses, 1)
                else
                    table.ForceInsert(activator.MaxUses, 0)
                end
            end
        else
            table.ForceInsert(activator.MaxUses, 1)
        end

        activator:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
        self:Remove()
    end
end

function ENT:Draw()
    self:DrawModel()

    local ply = LocalPlayer()
    if ply:GetPos():Distance(self:GetPos()) > 100 then
        return
    end

    if not IsValid(self) then
        return
    end

    draw.WorldText(self:GetPos() + Vector(0, 0, 15), self.PName, Color(255, 255, 255))
end
