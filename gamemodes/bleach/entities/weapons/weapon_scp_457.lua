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
SWEP.ISSCP = true
SWEP.droppable = false
SWEP.teams = { TEAM_SCP }
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.NextCheck = 0
SWEP.SpecialDelay = 4
SWEP.CColor = Color(0, 255, 0)
function SWEP:OnRemove()
    if SERVER then
        if IsValid(self.fire457) then
            self.fire457:Remove()
        end
        if self.Owner:IsPlayer() == true then
            if self.Owner:GetNClass() ~= ROLES.ROLE_SCP457 then
                self.Owner:UnIgnitePlayer()
            end
        end
    end
end

function SWEP:Holster()
    if SERVER then
        if IsValid(self.fire457) then
            self.fire457:Remove()
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
    if SERVER then
        if self.NextCheck < CurTime() then
            self.Owner:IgnitePlayer()
            self.NextCheck = CurTime() + 10
        end

        for k, v in pairs(ents.FindInSphere(self.Owner:GetPos(), 130)) do
            if v:IsPlayer() then
                if v:GTeam() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_SPECTATOR and v:GTeam() ~= TEAM_SCP and v:Team() ~= TEAM_SCP and v:Alive() then
                    v:Ignite(6, 270)
                    if self.Owner.nextexp == nil then
                        self.Owner.nextexp = 0
                    end
                    if self.Owner.nextexp < CurTime() then
                        self.Owner:AddExp(1)
                        self.Owner.nextexp = CurTime() + 1
                    end
                end
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
        if IsValid(self.fire457) then
            self.fire457:Remove()
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
        self.fire457 = ents.Create("env_fire")
        if not self.fire457 or not self.fire457:IsValid() then
            return false
        end
        self.fire457:SetPos(tr.HitPos)
        self.fire457:SetKeyValue("health", "512")
        self.fire457:SetKeyValue("firesize", "128")
        self.fire457:SetKeyValue("fireattack", "1")
        self.fire457:SetKeyValue("damagescale", "16")
        self.fire457:SetKeyValue("ignitionpoint", "0")
        self.fire457:Spawn()
        self.fire457:Activate()
        self.fire457:Fire("StartFire", "", 0)
        self.fire457.owner = self.Owner
        self.fire457.scpFire = true
        self.NextSpecial = CurTime() + self.SpecialDelay
        self:SetNWInt("NextSpecial", self.NextSpecial)
    end
    return true
end

SWEP.NextSpecial = 0
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
    if disablehud == true then
        return
    end
    local specialstatus = ""
    local showtext = ""
    local lookcolor = Color(0, 255, 0)
    local showcolor = Color(17, 145, 66)
    local gnextspecial = self:GetNWInt("NextSpecial", 0)
    if gnextspecial > CurTime() then
        specialstatus = "ready to use in " .. math.Round(gnextspecial - CurTime())
        showcolor = Color(145, 17, 62)
    else
        specialstatus = "ready to use"
    end

    showtext = "Special " .. specialstatus
    draw.Text({
        text = showtext,
        pos = { ScrW() / 2, ScrH() - 25 },
        font = "173font",
        color = showcolor,
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