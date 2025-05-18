AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/scp_682_wep")
    SWEP.BounceWeaponIcon = false
end
SWEP.PrintName = "SCP-682"
SWEP.Author = "Xy"
SWEP.Category = "Xy's SWEPs"
SWEP.Instructions = "Primary to attack, Secondary for an adrenaline rush."
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.droppable = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.UseHands = false
SWEP.Contact = "uhh"
SWEP.Purpose = "Murder"
SWEP.NextAttackH = 2
SWEP.NextAttackW = 45
SWEP.NextLunge = 45
SWEP.AttackDelay1 = 2
SWEP.AttackDelay2 = 45
SWEP.IsFaster = false
SWEP.BoostEnd = 0
SWEP.OrigWalk = 200
SWEP.OrigRun = 300
SWEP.OrigMax = 400
SWEP.OrigJump = 200
function SWEP:Deploy()
    self.OrigWalk = self.Owner:GetWalkSpeed()
    self.OrigRun = self.Owner:GetRunSpeed()
    self.OrigMax = self.Owner:GetMaxSpeed()
    self.OrigJump = self.Owner:GetJumpPower()
    self.Owner:DrawViewModel(false)
    self.Owner:SetWalkSpeed(60)
    self.Owner:SetRunSpeed(60)
    self.Owner:SetMaxSpeed(60)
    self.Owner:SetJumpPower(0)
    return true
end
function SWEP:Holster()
    self.Owner:SetWalkSpeed(self.OrigWalk)
    self.Owner:SetRunSpeed(self.OrigRun)
    self.Owner:SetMaxSpeed(self.OrigMax)
    self.Owner:SetJumpPower(self.OrigJump)
    return true
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:RenderLight()
    if self.toggleLight ~= true then
        return
    end
    if CLIENT then
        if IsValid(scp_nightVision) == false then
            scp_nightVision = DynamicLight(self.Owner:EntIndex()) --Do not take 0, Used for NV. This should be
        end
        if (scp_nightVision) then
            --Welp. :|
            scp_nightVision.Pos = self.Owner:GetPos()
            scp_nightVision.r = 0
            scp_nightVision.g = 255
            scp_nightVision.b = 0
            scp_nightVision.Brightness = 0.85
            scp_nightVision.Size = 900
            scp_nightVision.DieTime = CurTime() + 0.25 --Don't let it stay please.
            scp_nightVision.Style = 0 -- https://developer.valvesoftware.com/wiki/Light_dynamic#Appearances
        end
    end
end

function SWEP:Think()
    if CLIENT then
        self:RenderLight()
    end
end

scp_toggleLight_cooldown = 0
function SWEP:Reload()
    if scp_toggleLight_cooldown >= CurTime() then
        return
    end
    if self.toggleLight then
        self.toggleLight = false
    else
        self.toggleLight = true
    end
    scp_toggleLight_cooldown = CurTime() + 2
end

function SWEP:PrimaryAttack()
    if self.NextAttackH > CurTime() then
        return
    end
    if preparing then
        return
    end

    self.NextAttackH = CurTime() + self.AttackDelay1
    if SERVER then
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
                if ent:Team() == TEAM_SCP then
                    return
                end
                if ent:Team() == TEAM_SPEC then
                    return
                end
                ent:Kill()
            else
                if ent:GetClass() == "func_breakable" then
                    ent:TakeDamage(100, self.Owner, self.Owner)
                elseif ent:IsNPC() then
                    ent:TakeDamage(20000, self.Owner, self.Owner)
                elseif ent:GetClass() == 'prop_dynamic' then
                    if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
                        ent:TakeDamage(math.Round(math.random(40, 65)), self.Owner, self.Owner)
                        ent:EmitSound(Sound('MetalGrate.BulletImpact'))
                    end
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
    if preparing then
        return
    end --Do nothing while in preparing mode
    if self.NextAttackW > CurTime() then
        if SERVER then
            self.Owner:PrintMessage(3, "Ability 'adrenaline rush' is still on cooldown!")
        end
        return
    end
    self.NextAttackW = CurTime() + self.AttackDelay2
    local ply = self.Owner

    ply:SetWalkSpeed(350)
    ply:SetRunSpeed(350)
    ply:SetMaxSpeed(350)
    ply:SetJumpPower(0)

    timer.Simple(10, function()
        ply:SetWalkSpeed(60)
        ply:SetRunSpeed(60)
        ply:SetMaxSpeed(60)
        ply:SetJumpPower(0)
    end)
    ply:EmitSound('roar.ogg')
end

function SWEP:DrawHUD()
    if disablehud == true then
        return
    end
    local specialstatus = ""
    local showtext = ""
    local lookcolor = Color(0, 255, 0)
    local showcolor = Color(17, 145, 66)
    if self.NextAttackW > CurTime() then
        specialstatus = "ready to use in " .. math.Round(self.NextAttackW - CurTime())
        showcolor = Color(145, 17, 62)
    else
        specialstatus = "ready to use"
    end
    showtext = "Special " .. specialstatus

    local NvKey = input.LookupBinding('+reload') --Get key for reload
    if type(NvKey) == 'no value' then
        NvKey = 'NOT BOUND'
    end

    draw.Text({
        text = "Press " .. NvKey .. " for nightvision",
        pos = { ScrW() / 2, ScrH() - 75 },
        font = "173font",
        color = showcolor,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })

    draw.Text({
        text = showtext,
        pos = { ScrW() / 2, ScrH() - 50 },
        font = "173font",
        color = showcolor,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })
end