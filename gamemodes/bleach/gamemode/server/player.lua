local PLAYER = FindMetaTable("Player")

function GM:PlayerSpawn(ply)
    player_manager.SetPlayerClass(ply, "player_breach")

    ply:SetNoCollideWithTeammates(true)
    ply:SetCustomCollisionCheck(true)
    ply:AllowFlashlight(false)
    ply:Flashlight(false)
    ply:StripWeapons()
    ply:RemoveAllAmmo()
    ply:SetCanZoom(false)
    ply:SetNoDraw(false)

    ply:SetupCurrentRole()
end

function PLAYER:SetupCurrentRole()
    local roleName = self:GetRole()
    print("role: ", roleName);
    if roleName == "" then
        self:SetupSpectator()
        return
    end

    local role = ROLES[roleName];
    if not role then
        print("Unknown role name: ", roleName)
        return ;
    end

    self:UnSpectate()
    self:SetModel(Pick(role.Model))
    self:SetTeam(role.Team)
    self:SetMaxHealth(role.Health or 100)
    self:SetHealth(role.Health or 100)
    self:SetPos(Pick(role.Spawn))

    for _, weapon in pairs(role.Weapons) do
        self:Give(weapon)
    end
end

function PLAYER:SetupSpectator()
    self:SetTeam(TEAMS.SPECTATOR)
    self:SetNoTarget(true)
    self:SetNoDraw(true)
    self:Spectate(6)
end