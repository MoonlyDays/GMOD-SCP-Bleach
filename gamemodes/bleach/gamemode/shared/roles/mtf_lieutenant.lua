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
ROLE.Vest = "armor_mtf_lie"
ROLE.Ammo = { { "AR2", 180 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level4",
    "item_radio",
    "item_gasmask",
    "item_nvg",
    "weapon_stunstick",
    "weapon_chaos_famas"
}