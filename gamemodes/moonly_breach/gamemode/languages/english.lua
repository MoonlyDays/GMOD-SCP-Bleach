english = {}
english.roundtype = "Round type: {type}"
english.preparing = "Prepare, round will start in {num} seconds"
english.round = "Game is live, good luck!"
english.lang_pldied = "{num} player(s) died"
english.lang_descaped = "{num} Class D(s) escaped"
english.lang_sescaped = "{num} SCP(s) escaped"
english.lang_rescaped = "{num} Researcher(s) escaped"
english.lang_dcaptured = "Chaos Insurgency captured {num} Class D(s)"
english.lang_rescorted = "MTF escorted {num} Researcher(s)"
english.lang_teleported = "SCP - 106 caputred {num} victim(s) to the Pocket Dimension "
english.lang_snapped = "{num} neck(s) were snapped by SCP173"
english.lang_zombies = 'SCP - 049 "cured the disease" {num} time(s) '
english.lang_secret_found = "Secret has been found"
english.lang_secret_nfound = "Secret has not been found"
english.starttexts = {
	{
		--1
		"You are the SCP - 173",
		{"Your objective is to escape the facility", "You cannot move when someone is looking at you", "Remember, humans are blinking", "LMB - break victim neck", "RMB - activate special skill: blind everyone around"}
	},
	{
		--2
		"You are the SCP - 106",
		{"Your objective is to escape the facility", "When you touch someone, they will teleport to your pocket dimension", "LMB - teleport victim to pocket dimension"}
	},
	{
		--3
		"You are the SCP - 049",
		{"Your objective is to escape the facility", "If you touch someone, they will become SCP-049-2", "LMB - infect victim into a zombie"}
	},
	{
		--4
		"You are a Security Guard",
		{"Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class D or SCP that you will find", "Listen to MTF Commander's orders and stick to your team"}
	},
	{
		--5 roundtype: trouble in scp town
		"You are a Security Guard",
		{"Your objective is to kill every Chaos Insurgency Spy", "Don't trust everyone"}
	},
	{
		--6
		"You are an Security Chief",
		{"Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class Ds or SCPs that you will find", "Give orders to Guards to simplify the task"}
	},
	{
		--7
		"You are a MTF Unit Nine-Tailed Fox",
		{"Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class D or SCP that you will find", "Go to the facility and help Guards to embrace a chaos"}
	},
	{
		--8
		"You are a Class D",
		{"Your objective is to escape from the facility", "You need to cooperate with other Class Ds", "Search for keycards and be aware of MTF and SCPs"}
	},
	{
		--9
		"You are a Researcher",
		{"Your objective is to escape from the facility", "You need to find a MTF Guard that will help you", "Be on the look out of Class Ds as they might try to kill you"}
	},
	{
		--10
		"You are the SCP - 049 - 2",
		{"Your objective is to escape the facility", "Cooperate with SCP-049", "LMB - attack", "RMB - stronger attack"}
	},
	{
		--11
		"You are the Chaos Insurgency Commander",
		{"Your objective is to kill all MTF Guards and capture the Class D", "Escort them to the helipad outisde of the facility", "You have to kill anyone who will stop you", "Give orders to Choas Insurgency to simplify the task"}
	},
	{
		--12
		"You are the Chaos Insurgency Soldier",
		{"Your objective is to kill all MTF Guards and capture the Class D", "They are unaware of your disguise", "Don't destroy your disguise", "If you find any class ds, try to escort them to the helipad"}
	},
	{
		--13 roundtype: trouble in scp town
		"You are the Chaos Insurgency Spy",
		{"Your objective is to kill every MTF Guard", "They are in the facility, go there and kill them", "They are unaware of your disguise", "Don't destroy your disguise", "Try to cooperate with your teammates"}
	},
	{
		--14 roundtype: assault 
		"You are the Chaos Insurgency Soldier",
		{"Twoim celem jest zabicie ochroniarzy MTF", "They are in the facility, go there and kill them", "Try to cooperate with your teammates"}
	},
	{
		--15
		"You are the SCP - 035",
		{"Your objective is to escape the facility", "Help Class D Personell and SCP", "DON'T KILL CLASS D AND SCP AS SCP 035", "You have Keycard 3 and Deagle"}
	},
	{
		--16
		"You are the SCP - 457",
		{"Your objective is to escape then facility", "You are always burning", "If you are close enough to a human, you will burn them"}
	},
	{
		--17 roundtype: zombie plague
		"You are a MTF Guard",
		{"Your objective is to kill every SCP-008-2", "At the end of preparing, some MTFs will get infected"}
	},
	{
		--18
		"You are the SCP - 008 - 2",
		{"Your objective is to infect every MTF Guard", "If you attack someone, they will become 008-2 aswell"}
	},
	{
		--19
		"You are a Spectator",
		{'Use command "br_spectate" to come back'}
	},
	{
		--20
		"You are the SCP - 096",
		{"Your objective is to escape the facility", "You move extremely fast when someone is looking at you", "LMB - attack"}
	},
	{
		--21
		"You are the SCP - 939",
		{"Your objective is to escape the facility", "You are fast and strong", "LMB - bite the victim"}
	}
}

english.lang_end1 = "The game ends here"
english.lang_end2 = "Time limit has been reached"
english.lang_end3 = "Game ended due to the inability to continue"
english.escapemessages = {
	{
		main = "You escaped",
		txt = "You escaped the facility in {t} minutes, good job!",
		txt2 = "Try to get escorted by MTF next time to get bonus points.",
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = "You escaped",
		txt = "You escaped the facility in {t} minutes, good job!",
		txt2 = "Try to get escorted by Chaos Insurgency Soldiers next time to get bonus points.",
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = "You were escorted",
		txt = "You were escorted in {t} minutes, good job!",
		txt2 = "",
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = "You escaped",
		txt = "You escaped in {t} minutes, good job!",
		txt2 = "",
		clr = team.GetColor(TEAM_SCP)
	}
}

-- ROLES \\
english.ROLE_SCP173 = "SCP-173"
english.ROLE_SCP106 = "SCP-106"
english.ROLE_SCP049 = "SCP-049"
english.ROLE_SCP035 = "SCP-035"
english.ROLE_SCP457 = "SCP-457"
english.ROLE_SCP096 = "SCP-096"
english.ROLE_SCP939 = "SCP-939"
english.ROLE_SCP0492 = "SCP-049-2"
english.ROLE_MTFGUARD = "Guard"
english.ROLE_MTFCOM = "Security Chief"
english.ROLE_MTFNTF = "MTF Nine-Tailed Fox"
english.ROLE_CHAOSCOM = "CI Commander"
english.ROLE_CHAOS = "Chaos Insurgency"
english.ROLE_CLASSD = "Class D Personell"
english.ROLE_RES = "Researcher"
english.ROLE_SPEC = "Spectator"
-- HUD \\
-- Scoreboard
english.sb_scpobject = "SCP Object"
english.sb_score = "Score"
english.sb_deaths = "Deaths"
english.sb_ping = "Ping"
english.sb_group = "Group"
-- MTF Manager
english.mtfmanager = "Mobile Task Force Manager"
english.requestgatea = "Request Gate A Open"
english.requestescort = "Request Escorting"
english.sound_random = "Sound: Random"
english.sound_searching = "Sound: Searching"
english.sound_classdfound = "Sound: Class D Found"
english.sound_stop = "Sound: Stop!"
english.sound_targetlost = "Sound: Target Lost"
english.dropvest = "Drop Vest"
-- SweetFX
english.SWEETFX_enabled = "[SweetFX]: Livecolors enabled"
english.SWEETFX_disabled = "[SweetFX]: Livecolors disabled"
-- Thirdperson
english.thirdperson_enabled = "[Thirdperson]: Enabled"
english.thirdperson_disabled = "[Thirdperson]: Disabled"
-- F4 Menu
english.f4close = "Close"
english.f4settings = "Settings"
english.f4settings_lang = "Pick your language:"
english.f4settings_spectmode = "Switch to spectator mode?"
english.f4settings_sweetfx = "Enable live colors? (SweetFX HDR)"
english.f4settings_soundsfix = "Sounds Fix"
english.f4settings_bwt = "Bright weapons and textures fix"
english.f4roles_humans = "Roles 1/2 (Humans)"
english.f4roles_scps = "Roles 2/2 (SCP's)"
english.f4credits = "Credits"
-- SWEPS \\
-- SCP173 
english.nooneislooking = "Noone is looking"
english.readytousein = "ready to use in "
english.readytouse = "ready to use"
english.special = "Special skill "
english.someoneislooking = "someone is looking"
english.seconds = " seconds"
-- SCP106 + SCP049 + SCP939
english.readytoattack = "Ready to attack"
english.nextattack = "Next attack in "
english.channel = "Current voice chat:"
-- SCP714
english.durability = "Durability:"
english.protect = "You are protected"
english.protend = "Your protection is ending"
-- SNAV Ultimate
english.snu_mtfguard = "MTF Guard detected"
english.snu_ci = "Chaos Insurgency Member detected"
english.snu_classd = "Class D detected"
english.snu_researcher = "Researcher detected"
english.snu_detected = "Detected "
english.snu_humanoid = "Humanoid form detected"
-- RADIO
english.radiochannel = "Radio Channel "
english.radiodisabled = "Radio Disabled"
ALLLANGUAGES.english = english