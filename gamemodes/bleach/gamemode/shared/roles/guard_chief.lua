AddCSLuaFile()

ROLE.Title = "Шериф охраны"
ROLE.Objective = {
    "Ваша задача найти и спасти всех",
    "работников комплекса, что всё ещё внутри",
    "Вы должны убить все D классы и SCP, что встретите",
    "Вы можете раздавать приказы сотрудникам охраны"
}
ROLE.Spawn = MAP.SPAWN_GUARD
ROLE.Team = TEAMS.SECURITY
ROLE.Model = RESEARCHER_MODELS
ROLE.Vest = "armor_sec_chief"
ROLE.Weapons = {
    "br_holster",
    "keycard_level4",
    "item_radio",
    "item_gasmask",
    "item_nvg",
    "weapon_stunstick",
    "weapon_mtf_mp5"
}
ROLE.Requires = { guard_officer = 1 }
ROLE.Ammo = { { "SMG1", 200 } }
ROLE.Requires = {}