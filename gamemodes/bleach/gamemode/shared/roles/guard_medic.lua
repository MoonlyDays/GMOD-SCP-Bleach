AddCSLuaFile()

ROLE.Title = "Медик охраны"
ROLE.Objective = {
    "Ваша задача найти и спасти всех",
    "работников комплекса, что всё ещё внутри.",
    "Вы должны убить все D классы и SCP, что встретите.",
    "Если где-то есть Шериф охраны, слушайте его приказы.",
    "Если кто-то ранен, помогите им"
}
ROLE.Spawn = MAP.SPAWN_GUARD
ROLE.Team = TEAMS.SECURITY
ROLE.Model = RESEARCHER_MODELS
ROLE.Armor = "armor_sec_officer"
ROLE.Weapons = { "br_holster", "keycard_level2" }
ROLE.Ammo = { { "SMG1", 200 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level3",
    "item_radio",
    "item_gasmask",
    "item_ultramedkit",
    "weapon_stunstick",
    "weapon_mtf_ump45"
}