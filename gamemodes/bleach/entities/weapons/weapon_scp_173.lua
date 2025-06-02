AddCSLuaFile()

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("breach/wep_173")
    SWEP.BounceWeaponIcon = false
end

SWEP.Base = "weapon_scp_base"
SWEP.Author = "Kanade"
SWEP.Contact = "Look at this gamemode in workshop and search for creators"
SWEP.Purpose = "Kill people"
SWEP.Instructions = "LMB to kill someone"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel = "models/vinrax/props/keycard.mdl"
SWEP.PrintName = "SCP-173"
SWEP.SpecialDelay = 30
SWEP.NextThinkTime = 0
SWEP.SnapSound = Sound("snap.wav")
SWEP.HasSpecialAttack = true

function SWEP:IsBeingLookedAtBy(ply)
    local yes = ply:GetAimVector():Dot((self.Owner:GetPos() - ply:GetPos() + Vector(70)):GetNormalized())
    return yes > 0.39
end

function SWEP:IsTargetedBy(ply)
    return IsValid(ply)
            and ply:IsPlayer()
            and ply:IsPlaying()
            and ply ~= self.Owner
            and ply:Team() ~= TEAMS.SCP
            and ply:CanBlink()
end

function SWEP:Think()
    if CLIENT then
        return
    end

    if self.NextThinkTime > CurTime() then
        return
    end

    self.NextThinkTime = CurTime() + 0.5
    local watching = 0
    local players = {}
    for _, ply in pairs(player.GetAll()) do
        if self:IsTargetedBy(ply) then
            local trEyes = util.TraceLine({
                start = ply:EyePos() + ply:EyeAngles():Forward() * 15,
                endpos = self.Owner:EyePos(),
            })

            local trCenter = util.TraceLine({
                start = ply:LocalToWorld(ply:OBBCenter()),
                endpos = self.Owner:LocalToWorld(self.Owner:OBBCenter()),
                filter = ply
            })

            if trEyes.Entity == self.Owner or trCenter.Entity == self.Owner then
                if self:IsBeingLookedAtBy(ply) and ply.IsBlinking == false then
                    watching = watching + 1
                    table.ForceInsert(players, ply)
                end
            end
        end
    end

    self.Owner:Freeze(watching > 0)
end

function SWEP:PerformAttack(ent)
    if not SERVER then
        return
    end

    BREACH:AddStat(STATS.SCP_173_SNAPPED, 1)
    ent:Kill()
    ent:EmitSound(self.SnapSound)
end

function SWEP:PerformSpecial()
    if not SERVER then
        return
    end

    BREACH:BroadcastSoundTo(self.Owner, "Horror2.ogg")
    local findEnts = ents.FindInSphere(self.Owner:GetPos(), 600)
    local foundPlayers = {}
    for _, ply in pairs(findEnts) do
        if self:IsTargetedBy(ply) then
            table.ForceInsert(foundPlayers, ply)
        end
    end

    if #foundPlayers > 0 then
        local message = table.Map(foundPlayers, function(ply)
            return ply:Nick()
        end)
        message = table.Join(message, ", ")
        self.Owner:PrintMessage(HUD_PRINTTALK, message)

        for _, ply in pairs(foundPlayers) do
            BREACH:BroadcastSoundTo(ply, "Horror2.ogg")
            ply:Blink(5)
        end
    end
end

function SWEP:DrawHUD()
    self:DrawAttackHUD()
    self:DrawSpecialHUD()
    self:DrawBlinkHUD()
end

function SWEP:DrawBlinkHUD()
    local showText = "Никто не палит"
    local available = true
    if self.Owner:IsFrozen() then
        showText = "Кто-то палит сука"
        available = false
    end
    self:DrawActionHUD(showText, available, 3)
end