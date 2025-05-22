AddCSLuaFile()

ROLE.Title = "Офицер"
ROLE.Objective = {
    "Ваша задача найти и спасти всех",
    "работников комплекса, что всё ещё внутри.",
    "Вы должны убить все D классы и SCP, что встретите.",
    "Если где-то есть Шериф охраны, слушайте его приказы."
}
ROLE.Spawn = MAP.SPAWN_GUARD
ROLE.Team = TEAMS.SECURITY
ROLE.Model = RESEARCHER_MODELS
ROLE.Armor = "armor_sec_officer"
ROLE.Requires = { guard = 2 }
ROLE.Ammo = { { "SMG1", 200 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level3",
    "item_radio",
    "item_gasmask",
    "weapon_stunstick",
    "weapon_mtf_p90",
    "scpid_guard"
}