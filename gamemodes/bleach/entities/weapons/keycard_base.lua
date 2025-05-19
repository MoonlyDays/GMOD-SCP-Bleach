if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_keycard4")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Open certain doors"
SWEP.Instructions = "If you hold it, you can open doors with level 4"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/breach/keycard_new.mdl"
SWEP.WorldModel = "models/breach/keycard_new.mdl"
SWEP.PrintName = "Keycard Level 4"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
function SWEP:GetBetterOne()
    local r = math.random(1, 100)
    if buttonstatus == 3 then
        if r < 50 then
            return "keycard_level5"
        else
            return "keycard_level4"
        end
    elseif buttonstatus == 4 then
        if r < 16 then
            return "keycard_omni"
        elseif r < 40 then
            return "keycard_level5"
        else
            return "keycard_level4"
        end
    end
    return "keycard_level4"
end

SWEP.droppable = true
SWEP.clevel = 4
SWEP.teams = { TEAM_GUARD, TEAM_CLASSD, TEAM_SCI, TEAM_CHAOS, TEAM_STAFF }
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.BoneAttachment = "ValveBiped.Bip01_R_Hand"
SWEP.WorldModelPositionOffset = Vector(7, -1.5, -2.9)
SWEP.WorldModelAngleOffset = Angle(-20, 180, 190)
function SWEP:Deploy()
    --self.Owner:DrawViewModel( false )
    self:SetHoldType("pistol")
    self:SetSkin(self.keycard_skin)
end

function SWEP:PreDrawViewModel(vm, wep, ply)
    vm:SetSkin(self.keycard_skin)
end

function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
    if not IsValid(self.Owner) then
        return
    end
    local angs = self.Owner:EyeAngles()
    ang.pitch = -ang.pitch
    return pos + angs:Forward() * 14 + angs:Right() * -3.5 + angs:Up() * -6, ang + Angle(0, 180, -45)
end

function SWEP:DrawWorldModel()
    if CLIENT then
        if LocalPlayer():GTeam() == TEAM_SPEC then
            return false
        end
    end
    if not IsValid(self.Owner) then
        self:DrawModel()
    else
        if not IsValid(self.WM) then
            self.WM = ClientsideModel(self.WorldModel)
            self.WM:SetNoDraw(true)
        end

        local boneid = self.Owner:LookupBone(self.BoneAttachment)
        if not boneid then
            return
        end
        local matrix = self.Owner:GetBoneMatrix(boneid)
        if not matrix then
            return
        end
        local newpos, newang = LocalToWorld(self.WorldModelPositionOffset, self.WorldModelAngleOffset, matrix:GetTranslation(), matrix:GetAngles())
        self.WM:SetPos(newpos)
        self.WM:SetAngles(newang)
        self.WM:SetupBones()
        self.WM:SetSkin(self.keycard_skin)
        self.WM:DrawModel()
    end
end

function SWEP:Initialize()
    self:SetHoldType("pistol")
    self:SetSkin(self.keycard_skin)
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
end