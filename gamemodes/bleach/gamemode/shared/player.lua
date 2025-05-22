local BREACH_PLAYER = {}
local PLAYER = FindMetaTable("Player")

function BREACH_PLAYER:SetupDataTables()
    self.Player:NetworkVar("String", "Role")
end

function PLAYER:Role()
    local roleName = self:GetRole()
    if roleName == "" then
        return nil
    end

    return ROLES[roleName]
end

function PLAYER:IsPlaying()
    return IsValid(self) and self:Alive() and not self:IsSpectating()
end

function PLAYER:CanBlink()
    if not self:IsPlaying() then
        return false
    end

    local role = self:Role()
    if role then
        return role.CanBlink or true
    end

    return false
end

function PLAYER:IsSpectating()
    return self:Team() == TEAMS.SPECTATOR
end

player_manager.RegisterClass("player_breach", BREACH_PLAYER, "player_default")