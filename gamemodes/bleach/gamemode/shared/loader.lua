AddCSLuaFile()

ROLES = {}
MAP = {}

function LoadMapConfig()
    local mapConfig = "mapconfigs/" .. game.GetMap() .. ".lua"
    AddCSLuaFile(mapConfig)
    include(mapConfig)
end
LoadMapConfig()

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
    end
end
LoadRoles()

function LoadItems()
    local files, _ = file.Find(GM.FolderName .. "/gamemode/shared/items/*.lua", "LUA")
    for _, f in pairs(files) do
        local path = "items/" .. f
        local name = string.sub(f, 1, -5)

        ITEM = {}
        include(path)
        AddCSLuaFile(path)
        ITEMS[name] = ITEM;
        ITEM = nil
    end
end
LoadItems()