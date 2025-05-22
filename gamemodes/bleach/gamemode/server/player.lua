local PLAYER = FindMetaTable("Player")

function GM:PlayerInitialSpawn(ply)
    ply:SendInitialUpdate()

    if BREACH.state == ROUND_STATES.WAITING_FOR_PLAYERS then
        BREACH:AttemptStartRound()
    end
end

function GM:PlayerSpawn(ply)
    player_manager.SetPlayerClass(ply, "player_breach")
    ply:CleanUp()
    ply:SetupCurrentRole()
end

function GM:PlayerDeath(ply)
    ply:SetRole("")
    ply:SetTeam(TEAMS.SPECTATOR)
end

function GM:PlayerUse(ply)
    if ply:Team() == TEAMS.SPECTATOR then
        return false
    end

    return true
end

function GM:PlayerSetHandsModel(ply, ent)
    local simpleModel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simpleModel)
    if not info then
        return
    end

    ent:SetModel(info.model)
    ent:SetSkin(info.skin)
    ent:SetBodyGroups(info.body)
end

function GM:PlayerTick(ply)
    ply:UpdateStamina()
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

    if role.MoveSpeed then
        self:SetWalkSpeed(BASE_WALK_SPEED * role.MoveSpeed)
        self:SetRunSpeed(BASE_WALK_SPEED * role.MoveSpeed)
    else
        self:SetWalkSpeed(BASE_WALK_SPEED * (role.WalkSpeed or 1))
        self:SetRunSpeed(BASE_RUN_SPEED * (role.RunSpeed or 1))
    end

    if role.Weapons then
        for _, weapon in pairs(role.Weapons) do
            self:Give(weapon)
        end

    end

    if role.Ammo then
        for _, ammo in pairs(role.Ammo) do
            self:GiveAmmo(ammo[2], ammo[1], false)
        end
    end

    self:SwitchToDefaultWeapon()
end

function PLAYER:SpawnAs(role)
    self:SetRole(role)
    self:Spawn()
end

function PLAYER:SetupSpectator()
    self:SetTeam(TEAMS.SPECTATOR)
    self:SetNoTarget(true)
    self:SetNoDraw(true)
    self:Spectate(6)
end

function PLAYER:CleanUp()
    self:SetNoCollideWithTeammates(true)
    self:SetCustomCollisionCheck(true)
    self:AllowFlashlight(false)
    self:Flashlight(false)
    self:StripWeapons()
    self:RemoveAllAmmo()
    self:SetCanZoom(false)
    self:SetNoDraw(false)
    self:SprintEnable()
    self:SetModelScale(1)
    self.Stamina = MAX_STAMINA
    self.StaminaRestoresAfter = 0
    self.UsingArmor = nil
    self.AmmoPickupTimes = {}
end

function PLAYER:UpdateStamina()
    if not self:Alive() then
        return
    end

    if self:IsSprinting() and self:GetVelocity():LengthSqr() > 0.1 then
        if self.Stamina > 0 then
            self.Stamina = Approach(self.Stamina, 0, FrameTime() * STAMINA_CONSUME_SPEED)
            self.StaminaRestoresAfter = CurTime() + STAMINA_COOLDOWN
            if self.Stamina == 0 then
                self:SprintDisable()
            end
        end
    else
        if CurTime() > self.StaminaRestoresAfter then
            self.Stamina = Approach(self.Stamina, MAX_STAMINA, FrameTime() * STAMINA_RESTORE_SPEED)
            self:SprintEnable()
        end
    end

    net.Start("StaminaChanged")
    net.WriteFloat(self.Stamina, 8)
    net.Send(self)
end

function PLAYER:SendInitialUpdate()
    net.Start("TimerChanged")
    net.WriteInt(BREACH.timerEndsAt - CurTime())
    net.Send(self)

    net.Start("RoundStateChanged")
    net.WriteInt(BREACH.state, 4)
    net.Send(self)
end

function PLAYER:CanUseItems()
    return self:IsPlaying() and self:Team() ~= TEAMS.SCP
end

function PLAYER:EquipArmor(armor)
    if self.UsingArmor == armor then
        return
    end

    self:EmitSound(Sound("npc/combine_soldier/zipline_clothing" .. math.random(1, 2) .. ".wav"))
    self.UsingArmor = armor
end

function PLAYER:DropArmor()

end