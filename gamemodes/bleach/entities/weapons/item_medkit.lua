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
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/firstaidkit.mdl"
SWEP.WorldModel = "models/vinrax/props/firstaidkit.mdl"
SWEP.PrintName = "First Aid kit"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.betterone = "item_ultramedkit"
SWEP.droppable = true
SWEP.teams = { TEAM_GUARD, TEAM_CLASS_D, TEAM_SCIENTIST, TEAM_CHAOS, TEAM_STAFF }
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
    if not IsValid(self.Owner) then
        self:DrawModel()
    end
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if self.Owner:GTeam() == TEAM_SCP then
        return
    end
    if self.Owner:Health() / self.Owner:GetMaxHealth() <= 0.8 then
        if SERVER then
            self.Owner:SetHealth(self.Owner:GetMaxHealth())
            self.Owner:StripWeapon("item_medkit")
        end
    else
        if SERVER then
            self.Owner:PrintMessage(HUD_PRINTTALK, "You don't need healing yet")
        end
    end
end

function SWEP:SecondaryAttack()
    if SERVER then
        local ent = self.Owner:GetEyeTrace().Entity
        if ent:IsPlayer() then
            if ent:GTeam() == TEAM_SCP then
                return
            end
            if ent:GTeam() == TEAM_SPECTATOR then
                return
            end
            if ent:GetPos():Distance(self.Owner:GetPos()) < 95 then
                if ent:Health() / ent:GetMaxHealth() <= 0.8 then
                    ent:SetHealth(ent:GetMaxHealth())
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