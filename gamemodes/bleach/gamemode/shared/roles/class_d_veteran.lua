AddCSLuaFile()

ROLE.Title = "Ветеран класса D"
ROLE.Objective = {
    "Ваша задача сбежать из комплекса",
    "Вам нужно кооперировать с остальными классами D",
    "Ищите ключ-карты и опосайтесь сотрудников MTF и SCP"
}
ROLE.Spawn = MAP.SPAWN_CLASS_D
ROLE.Team = TEAMS.CLASS_D
ROLE.Health = 120
ROLE.Model = CLASS_D_MODELS
ROLE.WalkSpeed = 1.1
ROLE.RunSpeed = 1.05
ROLE.JumpPower = 1.05
ROLE.Requires = { class_d = 2 }
ROLE.Weapons = {
    "br_holster",
    "keycard_level1"
}
