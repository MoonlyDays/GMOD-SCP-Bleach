BREACH = {
    state = ROUND_STATES.WAITING_FOR_PLAYERS,
    stats = {},
    roleCount = {}
}

function BREACH:AttemptStartRound()
    if self:CanStartRound() then
        self:Restart()
        return true
    end

    return false
end

function BREACH:CheckWinConditions()

end

function BREACH:CanStartRound()
    if #player.GetAll() < MIN_PLAYERS then
        return false
    end

    return true
end

function BREACH:Restart()
    self:ChangeState(ROUND_STATES.SETUP)
end

function BREACH:ChangeRoundState(state)
    if self.state == state then
        return
    end

    if state == ROUND_STATES.WAITING_FOR_PLAYERS then
        self:OnWaitingForPlayers()
    end

    if state == ROUND_STATES.SETUP then
        self:OnRoundSetup()
    end

    if state == ROUND_STATES.ACTIVE then
        self:OnRoundActive()
    end

    if state == ROUND_STATES.CHAT_TIME then
        self:OnRoundEnded()
    end
end

function BREACH:OnWaitingForPlayers()
    self:CleanUp()
end

function BREACH:OnRoundSetup()
    self:CleanUp()
    self:SetupPlayers()
    self:BroadcastSound("Alarm2.ogg")
    self:PlayCommotionSound()

    local time = br_time_preparing:GetInt();
    self:SetTimer(time)
    timer.Create("SetupTime", time, 1, function()
        self:ChangeState(ROUND_STATES.ACTIVE)
    end)
end

function BREACH:OnRoundActive()
    local time = br_time_round:GetInt();
    self:SetTimer(time);
    timer.Create("RoundTime", time, 1, function()
        self:ChangeState(ROUND_STATES.CHAT_TIME)
    end)
end

function BREACH:OnRoundEnded()
    local time = br_time_postround:GetInt();
    self:SetTimer(time)
    self:OnRoundActive()
    timer.Create("PostTime", time, 1, function()
        if not self:AttemptStartRound() then
            self:ChangeState(ROUND_STATES.WAITING_FOR_PLAYERS)
        end
    end)
end

function BREACH:CleanUp()
    game.CleanUpMap()

    timer.Remove("PlayCommotionSounds");
    timer.Remove("SetupTime");
    timer.Remove("RoundTime");
    timer.Remove("PostTime");

    self:ResetStats()
    self.roleCount = {}
    self.commotionSounds = table.Copy(MAP.COMMOTION_SOUNDS);
end

function BREACH:WinCheck()
    if #player.GetAll() < MIN_PLAYERS then
        return
    end
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
    if state == ROUND_STATES.WAITING_FOR_PLAYERS then
        self:OnWaitingForPlayers()
    end

    if state == ROUND_STATES.SETUP then
        self:OnRoundSetup()
    end

    if state == ROUND_STATES.ACTIVE then
        self:OnRoundActive()
    end

    if state == ROUND_STATES.CHAT_TIME then
        self:OnRoundEnded()
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

