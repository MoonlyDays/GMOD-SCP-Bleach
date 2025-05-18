if CLIENT then
	local on = false -- default off
	local function toggle()
		local thirdperson_enabled = clang.thirdperson_enabled
		local thirdperson_disabled = clang.thirdperson_disabled
		on = not on
		if on == true then
			--print( 'enabled' )
			LocalPlayer():PrintMessage(HUD_PRINTTALK, thirdperson_enabled)
		else
			--print( 'disabled')
			LocalPlayer():PrintMessage(HUD_PRINTTALK, thirdperson_disabled)
		end
	end

	hook.Add("ShouldDrawLocalPlayer", "ThirdPersonDrawPlayer", function() if on and LocalPlayer():Alive() then return true end end)
	hook.Add("CalcView", "ThirdPersonView", function(ply, pos, angles, fov)
		if on and ply:Alive() then
			local view = {}
			view.origin = pos - (angles:Forward() * 70) + (angles:Right() * 20) + (angles:Up() * 5)
			--view.origin = pos - ( angles:Forward() * 70 )
			view.angles = ply:EyeAngles() + Angle(1, 1, 0)
			view.fov = fov
			return GAMEMODE:CalcView(ply, view.origin, view.angles, view.fov)
		end
	end)

	concommand.Add("br_thirdperson_toggle", toggle)
end