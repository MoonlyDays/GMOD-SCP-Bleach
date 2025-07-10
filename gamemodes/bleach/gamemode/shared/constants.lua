AddCSLuaFile()

MIN_PLAYERS = 2
MAX_STAMINA = 10
STAMINA_CONSUME_SPEED = 1
STAMINA_RESTORE_SPEED = 0.5
STAMINA_COOLDOWN = 5
BASE_WALK_SPEED = 180
BASE_RUN_SPEED = 280

STATS = {
    CLASS_D_ESCAPED = 1,
    STAFF_ESCAPED = 2,
    SCP_ESCAPED = 3,
    PLAYERS_DIED = 4,
    SCP_106_CAPTURED = 5,
    SCP_173_SNAPPED = 6,
    SCP_049_CURED = 7,
    SCP_1987_BIT = 8
}

TEAMS = {
    SPECTATOR = 0,
    CLASS_D = 1,
    SCP = 2,
    SCIENTIST = 3,
    SECURITY = 4,
    MTF = 5,
    CHAOS = 6,
    STAFF = 7
}

SQUAD_SPAWN = {
    ntfs = {
        Team = TEAMS.MTF,
        MinCount = 3,
        MaxCount = 5
    },
    chaos = {
        Team = TEAMS.CHAOS,
        MinCount = 3,
        MaxCount = 5
    },
    freddy = {
        Role = "scp_1987_j",
        MinCount = 1,
        MaxCount = 1,
        BroadcastSound = "breach/scp/freddy_spawn_3.mp3"
    }
}

SCP_914_STATUSES = {
    "rough",
    "coarse",
    "1:1",
    "fine",
    "very fine"
}

TEAM_ROLE_LIST = {
    TEAMS.CLASS_D
}

BREACH_ROLE_LIST = {
    TEAMS.SCP,
    -- 1 - 16	{4, 2, 2, 3, 3, 2}
    TEAMS.CLASS_D,
    TEAMS.SCP,
    TEAMS.SECURITY,
    TEAMS.STAFF,
    TEAMS.CLASS_D,
    TEAMS.SCIENTIST,
    --  TEAMS.CHAOS,
    TEAMS.SECURITY,
    TEAMS.SCP,
    TEAMS.CLASS_D,
    TEAMS.SCIENTIST,
    TEAMS.SECURITY,
    TEAMS.CLASS_D,
    TEAMS.STAFF,
    -- TEAMS.CHAOS,
    TEAMS.SCIENTIST,
    -- 2 - 32	{8, 5, 4, 5, 6, 4}
    TEAMS.CLASS_D,
    TEAMS.SECURITY,
    TEAMS.SCP,
    -- TEAMS.CHAOS,
    TEAMS.CLASS_D,
    TEAMS.STAFF,
    TEAMS.SECURITY,
    TEAMS.SCP,
    TEAMS.CLASS_D,
    TEAMS.SCIENTIST,
    TEAMS.STAFF,
    -- TEAMS.CHAOS,
    TEAMS.SECURITY,
    TEAMS.SCP,
    TEAMS.SCIENTIST,
    TEAMS.CLASS_D,
}

ROUND_STATES = {
    WAITING_FOR_PLAYERS = 0,
    SETUP = 1,
    ACTIVE = 2,
    CHAT_TIME = 3,
}

SCP_173_MODEL = "models/breach173.mdl"
SCP_049_MODEL = "models/vinrax/player/scp049_player.mdl"
SCP_049_2_MODEL = "models/player/zombie_classic.mdl"
SCP_457_MODEL = "models/player/corpse1.mdl"
SCP_106_MODEL = "models/vinrax/player/scp106_player.mdl"
SCP_1987_J_MODEL = "models/cktheamazingfrog/player/freddy/freddyvr.mdl"

SIDE_DIRECTOR_MODEL = "models/player/breen.mdl"

RESEARCHER_MODELS = {
    "models/player/kerry/class_scientist_1.mdl",
    "models/player/kerry/class_scientist_2.mdl",
    "models/player/kerry/class_scientist_3.mdl",
    "models/player/kerry/class_scientist_4.mdl",
    "models/player/kerry/class_scientist_5.mdl",
    "models/player/kerry/class_scientist_6.mdl",
    "models/player/kerry/class_scientist_7.mdl",
}

STAFF_MODELS = {
    "models/player/Group01/Male_01.mdl",
    "models/player/Group01/Male_02.mdl",
    "models/player/Group01/Male_03.mdl",
    "models/player/Group01/Male_04.mdl",
    "models/player/Group01/Male_05.mdl",
    "models/player/Group01/Male_06.mdl",
    "models/player/Group01/Male_07.mdl",
    "models/player/Group01/Male_08.mdl",
    "models/player/Group01/Male_09.mdl",
    "models/player/Group01/Female_01.mdl",
    "models/player/Group01/Female_02.mdl",
    "models/player/Group01/Female_03.mdl",
    "models/player/Group01/Female_04.mdl",
    "models/player/Group01/Female_06.mdl",
}

CHAOS_MODELS = {
    "models/kerry/player/merriweather/male_01.mdl",
    "models/kerry/player/merriweather/male_02.mdl",
    "models/kerry/player/merriweather/male_03.mdl",
    "models/kerry/player/merriweather/male_04.mdl",
    "models/kerry/player/merriweather/male_05.mdl",
    "models/kerry/player/merriweather/male_06.mdl",
    "models/kerry/player/merriweather/male_07.mdl",
    "models/kerry/player/merriweather/male_08.mdl",
}

SECURITY_MODELS = {
    "models/player/group04/male_01.mdl",
    "models/player/group04/male_02.mdl",
    "models/player/group04/male_03.mdl",
    "models/player/group04/male_04.mdl",
    "models/player/group04/male_05.mdl",
    "models/player/group04/male_06.mdl",
    "models/player/group04/male_07.mdl",
    "models/player/group04/male_08.mdl",
    "models/player/group04/male_09.mdl",
}

CLASS_D_MODELS = {
    "models/player/kerry/class_d_1.mdl",
    "models/player/kerry/class_d_2.mdl",
    "models/player/kerry/class_d_3.mdl",
    "models/player/kerry/class_d_4.mdl",
    "models/player/kerry/class_d_5.mdl",
    "models/player/kerry/class_d_6.mdl",
    "models/player/kerry/class_d_7.mdl",
}
