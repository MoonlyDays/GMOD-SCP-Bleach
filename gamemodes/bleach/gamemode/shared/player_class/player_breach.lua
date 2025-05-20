AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()
    BaseClass.SetupDataTables(self)

    self.Player:NetworkVar("Int", 0, "Team")
    self.Player:NetworkVar("String", 0, "Role")
end

player_manager.RegisterClass("player_sandbox", PLAYER, "player_default")