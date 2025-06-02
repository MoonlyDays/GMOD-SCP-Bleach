local BREACH_PLAYER = {}
local PLAYER = FindMetaTable("Player")

function BREACH_PLAYER:SetupDataTables()
    self.Player:NetworkVar("String", "Role")
    self.Player:NetworkVar("String", "VisibleRole")
end

function PLAYER:ActiveClearanceLevel()
    local wep = self:GetActiveWeapon()
    if wep and wep.ClearanceLevel then
        return wep.ClearanceLevel
    end

    return 0
end

function PLAYER:GlobalClearanceLevel()
    local highest = 0
    for _, wep in pairs(self:GetWeapons()) do
        if wep.ClearanceLevel and highest < wep.ClearanceLevel then
            highest = wep.ClearanceLevel
        end
    end
    return highest
end

function PLAYER:Role()
    local roleName = self:GetRole()
    if roleName == "" then
        return nil
    end

    return ROLES[roleName]
end

function PLAYER:IsPlaying()
    return IsValid(self)  and self:Alive() and not self:IsSpectating()
end

function PLAYER:CanEscape()
    if not self:IsPlaying() then
        return false
    end

    local role = self:Role()
    if role and role.CanEscape ~= nil then
        return role.CanEscape
    end
    return true
end

function PLAYER:CanBlink()
    if not self:IsPlaying() then
        return false
    end

    local role = self:Role()
    if role and role.CanBlink ~= nil then
        return role.CanBlink
    end
    return true
end

function PLAYER:IsSpectating()
    return self:Team() == TEAMS.SPECTATOR
end

player_manager.RegisterClass("player_breach", BREACH_PLAYER, "player_default")