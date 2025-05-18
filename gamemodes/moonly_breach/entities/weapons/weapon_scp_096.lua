AddCSLuaFile()
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_096")
    SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = "SCP096"
SWEP.Author = "Spy-Klon[GER]"
SWEP.Instructions = "Left click to attack" --Left click to bite, Right click to bark, Reload to Growl."
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "Other"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Distance = 100
SWEP.Primary.Delay = 1
SWEP.HoldType = "normal"
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.ISSCP = true
SWEP.droppable = false
SWEP.teams = {1}
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_arms_scp096.mdl"
SWEP.WorldModel = ""
SWEP.Nightvision = false
SWEP.NextReload = CurTime()
local bellen = "breach/096/attack1.wav"
local bite = "breach/096/attack1.wav"
local knurren = "breach/096/attack1.wav"
local atak = "breach/096/attack1.wav"
function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:IsLookingAt(ply)
    local yes = ply:GetAimVector():Dot((self.Owner:GetPos() - ply:GetPos() + Vector(70)):GetNormalized())
    return yes > 0.39
end

SWEP.DrawRed = 0
function SWEP:Think()
    if CLIENT then self.DrawRed = CurTime() + 0.1 end
    if postround then return end
    local watching = 1
    for k, v in pairs(player.GetAll()) do
        if IsValid(v) and v:Team() ~= TEAM_SPECTATOR and v:Alive() and v ~= self.Owner and v.canblink then
            local tr_eyes = util.TraceLine({
                start = v:EyePos() + v:EyeAngles():Forward() * 15,
                --start = v:LocalToWorld( v:OBBCenter() ),
                --start = v:GetPos() + (self.Owner:EyeAngles():Forward() * 5000),
                endpos = self.Owner:EyePos(),
            })

            --filter = v
            local tr_center = util.TraceLine({
                start = v:LocalToWorld(v:OBBCenter()),
                endpos = self.Owner:LocalToWorld(self.Owner:OBBCenter()),
                filter = v
            })

            if tr_eyes.Entity == self.Owner or tr_center.Entity == self.Owner then
                --self.Owner:PrintMessage(HUD_PRINTTALK, tostring(tr_eyes.Entity) .. " : " .. tostring(tr_center.Entity) .. " : " .. tostring(tr_center.Entity))
                if self:IsLookingAt(v) and v.isblinking == false then
                    watching = watching + 1
                    --if self:GetPos():Distance(v:GetPos()) > 100 then
                    --self.Owner:PrintMessage(HUD_PRINTTALK, v:Nick() .. " patrzy na Ciebie")
                    --end
                end
            end
        end
    end

    if watching > 1 then
        self.Owner:SetWalkSpeed(410)
        self.Owner:SetRunSpeed(470)
    else
        self.Owner:SetWalkSpeed(110)
        self.Owner:SetRunSpeed(130)
    end
end

function SWEP:PrimaryAttack()
    if preparing or postround then return end
    if not IsFirstTimePredicted() then return end
    local tr = self.Owner:GetEyeTrace().Entity
    if not tr:IsValid() then return end
    if tr:GetPos():Distance(self.Owner:GetPos()) > self.Primary.Distance then return end
    --if not tr:IsPlayer() then return end
    if SERVER then
        if tr:GetClass() == "func_breakable" then tr:TakeDamage(100, self.Owner, self.Owner) end
        if tr:IsPlayer() then
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            if tr:Team() == TEAM_SCP then return end
            if tr:Team() == TEAM_SPECTATOR then return end
            self.Owner:EmitSound(atak)
            timer.Simple(3, function() self.Owner:EmitSound(bite) end)
            tr:TakeDamage(math.random(40, 60))
            self.Owner:SetHealth(self.Owner:Health() + 40)
        end

        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    end
end