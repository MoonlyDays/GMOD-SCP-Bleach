AddCSLuaFile()

ROLE.Title = "Охранник"
ROLE.Objective = {
    "Ваша задача найти и спасти всех",
    "работников комплекса, что всё ещё внутри.",
    "Вы должны убить все D классы и SCP, что встретите.",
    "Если есть старшие по званию, слушайте их приказы."
}
ROLE.Spawn = MAP.SPAWN_GUARD
ROLE.Team = TEAMS.SECURITY
ROLE.Model = RESEARCHER_MODELS
ROLE.Vest = "armor_sec_guard"
ROLE.Ammo = { { "SMG1", 200 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level2",
    "item_radio",
    "item_gasmask",
    "weapon_stunstick",
    "weapon_mtf_tmp"
}