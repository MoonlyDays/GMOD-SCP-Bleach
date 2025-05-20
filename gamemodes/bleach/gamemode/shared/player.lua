AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()
    self.Player:NetworkVar("String", "Role")
    self.Player:NetworkVar("Float", "Stamina")
end

function PLAYER:GetGlobalClearance()
end

function PLAYER:GetActiveClearance()
end

player_manager.RegisterClass("player_breach", PLAYER, "player_default")