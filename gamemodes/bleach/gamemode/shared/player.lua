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

player_manager.RegisterClass("player_breach", BREACH_PLAYER, "player_default")