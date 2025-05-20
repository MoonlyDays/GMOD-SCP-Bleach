ROLES = {}
MAP = {}

function LoadMapConfig()
    local mapConfig = "mapconfigs/" .. game.GetMap() .. ".lua"
    AddCSLuaFile(mapConfig)
    include(mapConfig)
end

function LoadRoles()
    local files, _ = file.Find(GM.FolderName .. "/gamemode/roles/*.lua", "LUA")
    for _, v in pairs(files) do
        local path = "../roles/" .. v
        local name = string.sub(f, 1, -4)
        AddCSLuaFile(path)

        ROLE = {}
        include(path)

        ROLES[name] = ROLE;
        ROLE = nil
    end
end

LoadMapConfig()
LoadRoles()