BREACH = {
    stats = {},
    roleCount = {}
}

function BREACH:Restart()
    self:CleanUp()
    self:OnRoundSetup()

    local prepareTime = br_time_preparing:GetInt();
    self:SetTimer(prepareTime)
    timer.Create("SetupTime", prepareTime, 1, function()

        self:OnRoundActive()
        local roundTime = br_time_round:GetInt();
        self:SetTimer(roundTime);
        timer.Create("RoundTime", roundTime, 1, function()

            self:OnRoundEnded()
            local postTime = br_time_postround:GetInt();
            self:SetTimer(postTime)
            self:OnRoundActive()
            timer.Create("PostTime", postTime, 1, function()
                self:Restart();
            end)
        end)
    end)
end

function BREACH:OnRoundSetup()
    self:BroadcastSound("Alarm2.ogg")
    self:PlayCommotionSound()
    self:SetupPlayers()

    net.Start("RoundStart")
    net.Broadcast()
end

function BREACH:OnRoundActive()
    net.Start("RoundActive")
    net.Broadcast()
end

function BREACH:OnRoundEnded()
    net.Start("RoundEnded")
    net.WriteTable(self.stats, true)
    net.Broadcast()
end

function BREACH:CleanUp()
    game.CleanUpMap()

    timer.Remove("PlayCommotionSounds");
    timer.Remove("SetupTime");
    timer.Remove("RoundTime");
    timer.Remove("PostTime");

    self:ResetStats()
    self.commotionSounds = table.Copy(MAP.COMMOTION_SOUNDS);
    self.roleCount = {}
end

function BREACH:SetupPlayers()
    local players = player.GetAll()
    local playerCount = #players;
    local roleList = {}
    local population = {}

    for _ = 1, playerCount, 1 do
        if roleList[1] == nil then
            roleList = table.Copy(BREACH_ROLE_LIST)
        end

        local nextTeam = roleList[1]
        local ply = table.Random(players)
        table.RemoveByValue(players, ply)
        table.remove(roleList, 1)

        local roleName = self:FindBestAvailableRole(nextTeam, population)
        local role = ROLES[roleName]
        population[roleName] = (population[roleName] or 0) + 1
        ply:SpawnAs(roleName)

        if role.Requires then
            for requiredRole, requiredCount in pairs(role.Requires) do
                population[requiredRole] = (population[requiredRole] or 0) - requiredCount
            end
        end
    end
end

function BREACH:FindBestAvailableRole(team, population)
    local roles = table.Copy(TEAM_ROLES[team])

    for _ = #roles, 1, -1 do
        local roleName = table.Random(roles)
        table.RemoveByValue(roles, roleName)
        if self:IsRoleAvailable(roleName, population) then
            return roleName
        end
    end

    return nil
end

function BREACH:IsRoleAvailable(roleName, population)
    local role = ROLES[roleName]

    if role.StartAssigned ~= nil and not role.StartAssigned then
        return false
    end

    if role.Requires then
        for requiredRole, requiredCount in pairs(role.Requires) do
            local currentCount = population[requiredRole] or 0
            if currentCount < requiredCount then
                return false
            end
        end
    end

    if role.CheckAvailable then
        if not role.CheckAvailable() then
            return false
        end
    end

    return true
end

function BREACH:PlayCommotionSound()
    local rndSound = table.Random(self.commotionSounds)
    if not isstring(rndSound) then
        return
    end

    table.RemoveByValue(self.commotionSounds, rndSound)
    self:BroadcastSound(rndSound)

    timer.Create("PlayCommotionSounds", math.random(8, 14), 1, function()
        self:PlayCommotionSound()
    end)
end

function BREACH:Stat(type)
    return self.stats[type] or 0;
end

function BREACH:AddStat(type, howMuch)
    self.stats[type] = self.Stat(type) + howMuch;
end

function BREACH:SetStat(type, value)
    self.stats[type] = value
end

function BREACH:ResetStats()
    for _, stat in pairs(STATS) do
        self:SetStat(stat, 0)
    end
end

function BREACH:BroadcastSound(sound)
    net.Start("BroadcastSound")
    net.WriteString(sound)
    net.Broadcast()
end

function BREACH:ChangeState(state)
    if self.currentState == state then
        return
    end

    self.currentState = state;
    net.Start("RoundStateChanged")
    net.WriteUInt(state, 4)
    net.Broadcast()
end

function BREACH:SetTimer(time)
    self.timerEndsAt = CurTime() + time;
    net.Start("TimerChanged")
    net.WriteInt(time, 16)
    net.Broadcast()
end

