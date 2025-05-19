DEFINE_BASECLASS("player_default")
local PLAYER = {}
function PLAYER:SetupDataTables()
	self.Player:NetworkVar("String", 0, "NClass")
	self.Player:NetworkVar("Int", 0, "NEXP")
	self.Player:NetworkVar("Int", 1, "NLevel")
	self.Player:NetworkVar("Int", 2, "NGTeam")
	if SERVER then print("Setting up datatables for " .. self.Player:Nick()) end
end

player_manager.RegisterClass("class_breach", PLAYER, "player_default")