AddCSLuaFile()

ROLE.Title = "Директор Комплекса"
ROLE.Objective = {
    "Вам нужно раздавать приказы охране комплекса",
    "Вам нужно сохранить комплекс и не позволить SCP и классу D сбежать"
}
ROLE.Spawn = MAP.SPAWN_GUARD
ROLE.Team = TEAMS.SECURITY
ROLE.Model = SIDE_DIRECTOR_MODEL
ROLE.Requires = { guard_chief = 1 }
ROLE.Ammo = { { "Pistol", 105 } }
ROLE.Weapons = {
    "br_holster",
    "keycard_level5",
    "item_radio",
    "item_gasmask",
    "weapon_stunstick",
    "weapon_mtf_deagle",
    "scpid_guard"
}