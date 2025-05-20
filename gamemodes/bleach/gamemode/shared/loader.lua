AddCSLuaFile()

ROLES = {}
MAP = {}

function LoadMapConfig()
    local mapConfig = "mapconfigs/" .. game.GetMap() .. ".lua"
    AddCSLuaFile(mapConfig)
    include(mapConfig)
end

function LoadRoles()
    local files, _ = file.Find(GM.FolderName .. "/gamemode/shared/roles/*.lua", "LUA")
    for _, f in pairs(files) do
        local path = "roles/" .. f
        local name = string.sub(f, 1, -5)

        ROLE = {}
        include(path)
        AddCSLuaFile(path)
        ROLES[name] = ROLE;
        ROLE = nil
        print("Loaded role:", name)
    end
end

LoadMapConfig()
LoadRoles()