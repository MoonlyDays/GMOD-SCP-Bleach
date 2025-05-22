AddCSLuaFile()

ROLE.Title = "Медик"
ROLE.Objective = {
    "Ваша задача сбежать из комплекса",
    "Вам нужно найти работников MTF, которые помогут вам",
    "Смотрите в оба за D классами, они могут попытаться вас убить",
    "Если кто-то ранен, помогите им"
}
ROLE.Spawn = MAP.SPAWN_SCIENTIST
ROLE.Team = TEAMS.STAFF
ROLE.Model = STAFF_MODELS
ROLE.ModelColor = Color(50, 50, 50)
ROLE.Weapons = {
    "br_holster",
    "keycard_level2",
    "item_ultramedkit",
    "item_eyedrops"
}
