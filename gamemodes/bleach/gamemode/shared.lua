AddCSLuaFile()

GM.Name = "Bleach"
GM.Author = "Moonly Days"
GM.Email = ""
GM.Website = ""

function IncludeFolder(name, shouldInclude, shouldTransmit)
    local files, _ = file.Find(GM.FolderName .. "/gamemode/" .. name .. "/*", "LUA", "nameasc")
    for _, file in pairs(files) do
        local path = name .. "/" .. file;
        if shouldInclude then
            include(path)
        end
        if shouldTransmit then
            AddCSLuaFile(path)
        end
    end
end

function GM:CreateTeams()
    team.SetUp(TEAMS.SPECTATOR, "Наблюдатель", Color(141, 186, 160))
    team.SetUp(TEAMS.SCP, "SCP Объект", Color(112, 15, 31))
    team.SetUp(TEAMS.SECURITY, "Охранник", Color(0, 100, 255))
    team.SetUp(TEAMS.MTF, "MTF", Color(0, 100, 255))
    team.SetUp(TEAMS.CLASS_D, "Класс Д Персонал", Color(255, 130, 0))
    team.SetUp(TEAMS.SCIENTIST, "Ученый", Color(66, 188, 244))
    team.SetUp(TEAMS.STAFF, "Сотрудник", Color(141, 58, 196))
    team.SetUp(TEAMS.CHAOS, "Повстанцы Хаоса", Color(33, 56, 19))
end