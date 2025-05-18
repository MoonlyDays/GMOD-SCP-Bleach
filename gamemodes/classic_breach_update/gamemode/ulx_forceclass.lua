if not ulx or not ULib then
	print("ULX or ULib not found")
else
	local class_names = {}
	for _, class in pairs(ALLCLASSES) do
		table.insert(class_names, class.name)
	end

	local scp_names = {}
	for _, scp in pairs(SCPCLASSES) do
		table.insert(scp_names, scp.name)
	end

	function ulx.forcescp(plyc, plyt, scp, silent)
		if not scp then return end
		for k, v in pairs(SCPCLASSES) do
			if v.name == scp then
				v.func(plyt)
				if silent then
					ulx.fancyLogAdmin(plyc, true, "#A force spawned #T as " .. scp, plyt)
				else
					ulx.fancyLogAdmin(plyc, "#A force spawned #T as " .. scp, plyt)
				end

				break
			end
		end
	end

	local forcescp = ulx.command("Breach Admin", "ulx force_scp", ulx.forcescp, "!forcescp")
	forcescp:addParam{
		type = ULib.cmds.PlayerArg
	}

	forcescp:addParam{
		type = ULib.cmds.StringArg,
		hint = "SCP name",
		completes = scp_names,
		ULib.cmds.takeRestOfLine
	}

	forcescp:addParam{
		type = ULib.cmds.BoolArg,
		invisible = true
	}

	forcescp:setOpposite("ulx silent force_scp", {_, _, _, true}, "!sforcescp")
	forcescp:defaultAccess(ULib.ACCESS_SUPERADMIN)
	forcescp:help("Sets player to specific SCP and spawns him")
	function ulx.forceclass(plyc, plyt, class, silent)
		if not class then return end
		for k, v in pairs(ALLCLASSES) do
			if v.name == class then
				v.func(plyt)
				if silent then
					ulx.fancyLogAdmin(plyc, true, "#A force spawned #T as " .. class, plyt)
				else
					ulx.fancyLogAdmin(plyc, "#A force spawned #T as " .. class, plyt)
				end

				break
			end
		end
	end

	local forceclass = ulx.command("Breach Admin", "ulx force_class", ulx.forceclass, "!forceclass")
	forceclass:addParam{
		type = ULib.cmds.PlayerArg
	}

	forceclass:addParam{
		type = ULib.cmds.StringArg,
		hint = "Class name",
		completes = class_names,
		ULib.cmds.takeRestOfLine
	}

	forceclass:addParam{
		type = ULib.cmds.BoolArg,
		invisible = true
	}

	forceclass:setOpposite("ulx silent force_class", {_, _, _, true}, "!sforceclass")
	forceclass:defaultAccess(ULib.ACCESS_SUPERADMIN)
	forceclass:help("Sets player to specific class and spawns him")
end