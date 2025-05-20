AddCSLuaFile()

ROLE.Title = "Ученый (Шпион Хаоса)"
ROLE.Objective = {
    "Ваша задача захватить как можно больше D классов",
    "Выведите их к вертолётной площадке снаружи комплекса",
    "Вы должны убить всех, кто попытается вас остановить"
}
ROLE.Spawn = MAP.SPAWN_SCIENTIST
ROLE.Team = TEAMS.CHAOS
ROLE.Model = RESEARCHER_MODELS
ROLE.Ammo = { { "AR2", 180 }, { "Pistol", 105 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level3"
}
ROLE.DisguisedAs = "scientist"