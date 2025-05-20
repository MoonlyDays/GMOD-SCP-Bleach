AddCSLuaFile()

ROLE.Title = "Медик MTF"
ROLE.Objective = {
    "Ваша задача поддерживать участников вашей команды",
    "Если кто-то ранен, помогите им",
    "Слушайте комманды командира MTF и не отставайте от вашей команды"
}
ROLE.Spawn = MAP.SPAWN_OUTSIDE
ROLE.Team = TEAMS.MTF
ROLE.Model = RESEARCHER_MODELS
ROLE.Vest = "armor_mtf_medic"
ROLE.Ammo = { { "AR2", 180 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level4",
    "item_radio",
    "item_gasmask",
    "item_nvg",
    "item_ultramedkit",
    "weapon_stunstick",
    "weapon_chaos_famas"
}