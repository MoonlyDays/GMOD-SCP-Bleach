local mply = FindMetaTable("Player")
function mply:CLevelGlobal()
	local biggest = 1
	for k, wep in pairs(self:GetWeapons()) do
		if IsValid(wep) then if wep.clevel then if wep.clevel > biggest then biggest = wep.clevel end end end
	end
	return biggest
end

function mply:CLevel()
	local wep = self:GetActiveWeapon()
	if IsValid(wep) then if wep.clevel then return wep.clevel end end
	return 1
end

function mply:GetKarma()
	if not self.GetNKarma then player_manager.RunClass(self, "SetupDataTables") end
	if not self.GetNKarma then
		return 999
	else
		return self:GetNKarma()
	end
end