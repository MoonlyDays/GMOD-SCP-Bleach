AddCSLuaFile()

ROLE.Title = "Охранник (Шпион Хаоса)"
ROLE.Objective = {
    "Ваша задача захватить как можно больше D классов",
    "Выведите их к вертолётной площадке снаружи комплекса",
    "Вы должны убить всех, кто попытается вас остановить"
}
ROLE.Spawn = MAP.SPAWN_GUARD
ROLE.Team = TEAMS.CHAOS
ROLE.Model = RESEARCHER_MODELS
ROLE.Vest = "armor_sec_officer"
ROLE.DisguisedAs = "guard"
ROLE.Ammo = { { "SMG1", 200 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level3",
    "item_radio",
    "item_gasmask",
    "weapon_stunstick",
    "weapon_mtf_p90"
}