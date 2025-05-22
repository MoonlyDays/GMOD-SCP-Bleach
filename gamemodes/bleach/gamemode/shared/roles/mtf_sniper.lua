AddCSLuaFile()

ROLE.Title = "Лейтенант MTF"
ROLE.Objective = {
    "Ваша задача найти и спасти всех",
    "работников комплекса, что всё ещё внутри",
    "Вы должны убить все D классы и SCP, что встретите",
    "Слушайте комманды командира MTF и не отставайте от вашей команды"
}
ROLE.Spawn = MAP.SPAWN_OUTSIDE
ROLE.Team = TEAMS.MTF
ROLE.Model = RESEARCHER_MODELS
ROLE.Armor = "armor_mtf_officer"
ROLE.Ammo = { { "AR2", 180 }, { "Pistol", 105 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level4",
    "item_radio",
    "item_gasmask",
    "item_nvg",
    "weapon_stunstick",
    "weapon_mtf_usp",
    "weapon_chaos_sg550"
}