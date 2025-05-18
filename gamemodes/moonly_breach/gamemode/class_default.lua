AddCSLuaFile()
DEFINE_BASECLASS("player_default")
local PLAYER = {}
PLAYER.DisplayName = "Player"
PLAYER.WalkSpeed = 1
PLAYER.RunSpeed = 1
PLAYER.CrouchedWalkSpeed = 0.3
PLAYER.DuckSpeed = 0.3
PLAYER.UnDuckSpeed = 0.3
PLAYER.JumpPower = 200
PLAYER.CanUseFlashlight = true
PLAYER.MaxHealth = 100
PLAYER.StartHealth = 100
PLAYER.StartArmor = 0
PLAYER.DropWeaponOnDie = false
PLAYER.TeammateNoCollide = false
PLAYER.AvoidPlayers = true
PLAYER.UseVMHands = true
function PLAYER:Loadout()
end

function PLAYER:SetupDataTables()
	local pl = self.Player
	pl:NetworkVar("String", 0, "NClass")
	pl:NetworkVar("Int", 1, "NKarma")
	if SERVER then
		print("Setting up datatables for " .. pl:Nick())
		pl:SetNClass("Spectator")
		local num
		if SaveKarma() then
			num = tonumber(pl:GetPData("breach_karma", StartingKarma()))
		else
			num = SaveKarma()
		end

		pl:SetNKarma(num)
		pl.Karma = num
	end
end

player_manager.RegisterClass("class_default", PLAYER, "player_default")