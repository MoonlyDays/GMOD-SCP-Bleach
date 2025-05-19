AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_gasmask")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Find a way to go"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/props_junk/cardboard_box004a.mdl"
SWEP.WorldModel = "models/props_junk/cardboard_box004a.mdl"
SWEP.PrintName = "Gasmask"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.droppable = true
SWEP.teams = { TEAM_GUARD, TEAM_CLASSD, TEAM_SCI, TEAM_CHAOS, TEAM_STAFF }
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
    self:SetSkin(1)
end

SWEP.NextCough = 0
SWEP.LastCough = 0
function SWEP:Think()
    --[[
    if SERVER then
        if self.NextCough > CurTime() then return end
        self.LastCough = self.LastCough + 1
        if self.LastCough > 3 then self.LastCough = 1 end
        //print(self.LastCough)
        self.Owner:EmitSound("D9341/Cough"..self.LastCough..".ogg")
        self.NextCough = CurTime() + 3
    end
]]
end

function SWEP:Reload()
end

SWEP.GasMaskOn = false
SWEP.NextChange = 0
function SWEP:PrimaryAttack()
    if self.NextChange < CurTime() then
        --print("gasmask check")
        self.GasMaskOn = not self.GasMaskOn
        self.NextChange = CurTime() + 0.5
        if CLIENT then
            surface.PlaySound('pickitem2.ogg')
        end
    end
end

function SWEP:OnRemove()
end

function SWEP:Holster()
    return true
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
end

function SWEP:DrawHUD()
    if self.GasMaskOn == false then
        draw.Text({
            text = "Click LMB to put on the gasmask",
            --pos = { rx + 52, ry * 1.79 },
            pos = { ScrW() / 2, ScrH() - 15 },
            font = "RadioFont",
            color = color_white,
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
        })
    end
end