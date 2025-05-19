russian = {}
russian.roundtype = "Round type: {type}"
russian.preparing = "Prepare, round will start in {num} seconds"
russian.round = "The round has started, good luck!"
russian.lang_pldied = "{num} player(s) died"
russian.lang_descaped = "{num} Class D(s) escaped"
russian.lang_sescaped = "{num} SCP(s) escaped"
russian.lang_rescaped = "{num} Staff members escaped"
russian.lang_dcaptured = "Chaos Insurgency captured {num} Class D(s)"
russian.lang_rescorted = "MTF escorted {num} Staff member(s)"
russian.lang_teleported = "SCP - 106 caputred {num} victim(s) to the Pocket Dimension "
russian.lang_snapped = "{num} neck(s) were snapped by SCP173"
russian.lang_zombies = 'SCP - 049 "cured the disease" {num} time(s) '
russian.class_unknown = "Unknown"
russian.starttexts = {
    ROLE_SCP173 = { "You are the SCP-173", { "Your objective is to escape the facility", "You cannot move when someone is looking at you", "Remember, humans are blinking", "You have a special ability on RMB: blind everyone around you" } },
    ROLE_SCP106 = { "You are the SCP-106", { "Your objective is to escape the facility", "When you touch someone, they will teleport", "to your pocket dimension" } },
    ROLE_SCP966 = { "You are the SCP-966", { "Your objective is to escape then facility", "You are invisible, humans can only see you using a nvg" } },
    ROLE_SCP457 = { "You are the SCP-457", { "Your objective is to escape then facility", "You are always burning", "If you are close enough to a human, you will burn them" } },
    ROLE_SCP049 = { "You are the SCP-049", { "Your objective is to escape the facility", "If you touch someone, they will become SCP-049-2" } },
    ROLE_SCP0492 = { "You are the SCP-049-2", { "Your objective is to escape the facility", "Cooperate with SCP-049 to kill more people" } },
    ROLE_SCP0082 = { "You are the SCP-008-2", { "Your objective is to infect every MTF Guard", "If you attack someone, they will become 008-2 aswell" } },
    -- RESEARCH STAFF
    ROLE_RES = { "You are a Researcher", { "Your objective is to escape from the facility", "You need to find a MTF Guard that will help you", "Be on the look out of Class Ds as they might try to kill you" } },
    ROLE_RES_SPY = { "You are a Chaos Insurgency Spy", { "Your objective is to kill all MTF Guards and capture the Class D", "They are unaware of your disguise", "Don't destroy your disguise", "If you find any class d's, try to escort them" } },
    ROLE_HRES = { "You are the Head Researcher", { "Your objective is to escape from the facility", "You need to find a MTF Guard that will help you", "Be on the look out of Class Ds as they might try to kill you" } },
    -- MISC STAFF
    ROLE_JANITOR = { "You are a Janitor", { "Your objective is to escape from the facility", "You need to find a MTF Guard that will help you", "Be on the look out of Class Ds as they might try to kill you" } },
    ROLE_ENG = { "You are an Engineer", { "Your objective is to escape from the facility", "You need to find a MTF Guard that will help you", "Be on the look out of Class Ds as they might try to kill you" } },
    ROLE_MEDIC = { "You are a Medic", { "Your objective is to escape from the facility", "You need to find a MTF Guard that will help you", "Be on the look out of Class Ds as they might try to kill you", "If someone gets injured, heal them" } },
    -- CLASS D PERSONNEL
    ROLE_CLASSD = { "You are a Class D", { "Your objective is to escape from the facility", "You need to cooperate with other Class Ds", "Search for keycards and be aware of MTF and SCPs" } },
    ROLE_VETERAN = { "You are a Veteran Class D", { "Your objective is to escape from the facility", "You need to cooperate with other Class Ds", "Search for keycards and be aware of MTF and SCPs" } },
    -- SITE SECURITY
    ROLE_SEC_GUARD = { "You are a Security Guard", { "Your objective is to find and rescue all", "staff that is still in the facility", "You have to kill any Class Ds or SCPs that you find", "If there is a security chief somewhere, listen to his orders" } },
    ROLE_SEC_OFFICER = { "You are a Security Officer", { "Your objective is to find and rescue all", "staff that is still in the facility", "You have to kill any Class Ds or SCPs that you find", "If there is a security chief somewhere, listen to his orders" } },
    ROLE_SEC_MEDIC = { "You are a Security Medic", { "Your objective is support your teammates", "If someone gets injured, heal them", "If there is a security chief somewhere, listen to his orders" } },
    ROLE_SEC_CHIEF = { "You are a Security Chief", { "Your objective is to find and rescue all", "staff that is still in the facility", "You have to kill any Class Ds or SCPs that you find", "You can give orders to security officers" } },
    ROLE_SD = { "You are a Site Director", { "Your objective is to give objectives", "You need to give objectives to the site security", "You need to keep the site secure, don't let any SCP or Class D escape" } },
    -- SUPPORT
    ROLE_CHAOS = { "You are a Chaos Insurgency Soldier", { "Your objective is to capture as much Class Ds as it is possible", "Escort them to the helipad outisde of the facility", "You have to kill anyone who will stop you" } },
    ROLE_MTF_OFFICER = { "You are a MTF Officer", { "Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class D or SCP that you will find", "Listen to MTF Commander's orders and stick to your team" } },
    ROLE_MTF_MEDIC = { "You are a MTF Medic", { "Your objective is support your teammates", "If someone gets injured, heal them", "Listen to MTF Commander's orders and stick to your team" } },
    ROLE_MTF_SCU = { "You are a MTF Special Containment Unit", { "Your objective is to find and rescue all", "of the researchers that are still in the facility", "Listen to MTF Commander's orders and stick to your team" } },
    ROLE_CHAOSCOM = { "You are a Chaos Insurgency Commander", { "Your objective is to give objectives to your team", "Kill anyone who will stop you" } },
    ROLE_MTF_SNIPER = { "You are a MTF Sniper", { "Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class D or SCP that you will find", "Listen to MTF Commander's orders and stick to your team" } },
    ROLE_MTF_LIE = { "You are a MTF Lieutenant", { "Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class Ds or SCPs that you will find", "Give orders to Guards to simplify the task", "Listen to MTF Commander's orders and stick to your team" } },
    ROLE_MTF_COM = { "You are a MTF Commander", { "Your objective is to find and rescue all", "of the researchers that are still in the facility", "You have to kill any Class Ds or SCPs that you will find", "Give orders to Guards to simplify the task" } },
    -- CI
    ROLE_CI_RES = { "You are a CI Spy", { "You are a part of Chaos Insurgency disguised as a Researcher", "Your objective is to capture and escort Class D Personnel", "Kill anyone who will stop you" } },
    ROLE_CI_GUARD = { "You are a CI Spy", { "You are a part of Chaos Insurgency disguised as a Guard", "Your objective is to capture and escort Class D Personnel", "Kill anyone who will stop you" } },
    ROLE_CI_SOLD = { "You are a CI Spy", { "You are a part of Chaos Insurgency disguised as a Guard", "Your objective is to capture and escort Class D Personnel", "Kill anyone who will stop you" } },
    -- OTHERS
    ROLE_SPEC = { "You are a Spectator", { 'HMMMMMMMMMMMMMM' } },
}

russian.lang_round_end_main = "The round has ended"
russian.endmessages = { "Time limit has been reached", "Facility is under control of one faction", "Everybody died or escaped", }
russian.escapemessages = {
    {
        main = "You escaped",
        txt = "You escaped the facility in {t} minutes, good job!",
        txt2 = "Try to get escorted by MTF next time to get bonus points.",
        clr = Color(237, 28, 63),
    },
    {
        main = "You escaped",
        txt = "You escaped the facility in {t} minutes, good job!",
        txt2 = "Try to get escorted by Chaos Insurgency Soldiers next time to get bonus points.",
        clr = Color(237, 28, 63),
    },
    {
        main = "You were escorted",
        txt = "You were escorted in {t} minutes, good job!",
        txt2 = "",
        clr = Color(237, 28, 63),
    },
    {
        main = "You escaped",
        txt = "You escaped in {t} minutes, good job!",
        txt2 = "",
        clr = Color(237, 28, 63),
    }
}

russian.ROLES = {}
russian.ROLES.ROLE_SCP173 = "SCP-173"
russian.ROLES.ROLE_SCP106 = "SCP-106"
russian.ROLES.ROLE_SCP049 = "SCP-049"
russian.ROLES.ROLE_SCP457 = "SCP-457"
russian.ROLES.ROLE_SCP966 = "SCP-966"
russian.ROLES.ROLE_SCP0492 = "SCP-049-2"
russian.ROLES.ROLE_SCP0082 = "SCP-008-2"
russian.ROLES.ROLE_RES = "Researcher"
russian.ROLES.ROLE_RES_SPY = "CI Spy"
russian.ROLES.ROLE_HRES = "Head Researcher"
-- Misc Staff
russian.ROLES.ROLE_JANITOR = "Janitor"
russian.ROLES.ROLE_ENG = "Engineer"
russian.ROLES.ROLE_MEDIC = "Medic"
-- Class D Personnel
russian.ROLES.ROLE_CLASSD = "Class D Personnel"
russian.ROLES.ROLE_VETERAN = "Class D Veteran"
-- Security
russian.ROLES.ROLE_SEC_GUARD = "Security Guard"
russian.ROLES.ROLE_SEC_OFFICER = "Security Officer"
russian.ROLES.ROLE_SEC_MEDIC = "Security Medic"
russian.ROLES.ROLE_SEC_CHIEF = "Security Chief"
russian.ROLES.ROLE_SD = "Site Director"
-- Support
russian.ROLES.ROLE_CHAOS = "CI Soldier"
russian.ROLES.ROLE_MTF_OFFICER = "MTF Officer"
russian.ROLES.ROLE_MTF_MEDIC = "MTF Medic"
russian.ROLES.ROLE_MTF_SCU = "MTF SCU"
russian.ROLES.ROLE_MTF_SNIPER = "MTF Sniper"
russian.ROLES.ROLE_CHAOSCOM = "CI Commander"
russian.ROLES.ROLE_MTF_LIE = "MTF Lieutenant"
russian.ROLES.ROLE_MTF_COM = "MTF Commander"
-- CI Spies
russian.ROLES.ROLE_CI_RES = "CI Spy Researcher"
russian.ROLES.ROLE_CI_GUARD = "CI Spy Guard"
russian.ROLES.ROLE_CI_SOLD = "CI Spy Soldier"
russian.ROLES.ROLE_SPEC = "Spectator"
ALL_LANGUAGES.russian = russian