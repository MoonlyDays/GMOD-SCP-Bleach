BREACH = BREACH or {
    currentState = ROUND_STATES.WAITING_FOR_PLAYERS,
    stats = {},
    timerEndsAt = 0,
    nextTickAt = 0,
    nextSquadSpawn = 0,
    roleCount = {}
}

hook.Add("Tick", "BreachTick", function()
    BREACH:Tick()
end)

function BREACH:SpawnSquad(name)

    self.nextSquadSpawn = CurTime() + math.random(
            br_time_squad_enter_delay_min:GetInt(),
            br_time_squad_enter_delay_max:GetInt()
    )

    local squad = SQUAD_SPAWN[name]
    local spectatorPlayers = team.GetPlayers(TEAMS.SPECTATOR)
    local squadCount = math.random(squad.MinCount, squad.MaxCount)
    local population = {}

    for _ = 1, squadCount, 1 do
        local ply = ExhaustPick(spectatorPlayers)
        if not ply then
            break
        end

        if squad.Role then
            ply:SpawnAs(squad.Role)
        end

        if squad.Team then
            local role = self:FindBestAvailableRole(squad.Team, population);
            ply:SpawnAs(role)
            population[role] = (population[role] or 0) + 1
        end
    end

    if squad.BroadcastSound then
        self:BroadcastSound(squad.BroadcastSound)
    end
end

function BREACH:AttemptStartRound()
    if self:CanStartRound() then
        self:Restart()
        return true
    end

    return false
end

function BREACH:Tick()
    if CurTime() < self.nextTickAt then
        return
    end

    self.nextTickAt = CurTime() + 1

    local timeRemaining = math.max(self.timerEndsAt - CurTime(), 0)
    net.Start("TimerChanged")
    net.WriteInt(timeRemaining, 16)
    net.Broadcast()

    if self.currentState == ROUND_STATES.WAITING_FOR_PLAYERS then
        self:AttemptStartRound()
        return
    end

    if self.currentState == ROUND_STATES.ACTIVE then
        self:CheckEscapes()
        self:CheckWinConditions()
        return
    end

end

function BREACH:CheckEscapes()
    if self.currentState ~= ROUND_STATES.ACTIVE then
        return
    end

    for _, pos in pairs(MAP.ESCAPE_POINTS) do
        for _, ent in pairs(ents.FindInSphere(pos, 250)) do
            if not (ent:IsPlayer() and ent:IsPlaying()) then
                continue
            end

            if ent.isEscaping or CurTime() < ent.NextEscapeAttempt then
                continue
            end

            ent.NextEscapeAttempt = CurTime() + 2
            if not ent:CanEscape() then
                ent:PrintMessage(HUD_PRINTCENTER, "Вы не можете сбежать.")
                continue
            end

            net.Start("PlayerEscaped")
            net.Send(ent)

            ent:GodEnable()
            ent:Freeze(true)
            ent:PrintMessage(HUD_PRINTCENTER, "Вы сбежали!")
            ent.isEscaping = true

            if ent:Team() == TEAMS.SCP then
                BREACH:AddStat(STATS.SCP_ESCAPED, 1)
            end
            if ent:Team() == TEAMS.CLASS_D then
                BREACH:AddStat(STATS.CLASS_D_ESCAPED, 1)
            end
            if ent:Team() == TEAMS.STAFF or ent:Team() == TEAMS.SCIENTIST then
                BREACH:AddStat(STATS.STAFF_ESCAPED, 1)
            end

            timer.Create("EscapeWait" .. ent:SteamID64(), 2, 1, function()
                ent:Freeze(false)
                ent:GodDisable()
                ent:SpawnAsSpectator()
                ent.isEscaping = false
            end)
        end
    end
end

function BREACH:CheckWinConditions()
    if #player.GetAll() < MIN_PLAYERS then
        return
    end

    if self.currentState ~= ROUND_STATES.ACTIVE then
        return
    end

    local endRound = false
    local classDCount = #team.GetPlayers(TEAMS.CLASS_D)
    local guardCount = #team.GetPlayers(TEAMS.SECURITY)
    local scientistCount = #team.GetPlayers(TEAMS.SCIENTIST)
    local staffCount = #team.GetPlayers(TEAMS.STAFF)
    local mtfCount = #team.GetPlayers(TEAMS.MTF)
    local scpCount = #team.GetPlayers(TEAMS.SCP)
    local chaosCount = #team.GetPlayers(TEAMS.CLASS_D)
    local allCount = #player.GetPlaying()

    local why = "idk"
    if all == 0 then
        why = "Все игроки мертвы"
        endRound = true
    elseif scpCount == allCount then
        endRound = true
        why = "Остались только SCP"
    elseif mtfCount == allCount then
        endRound = true
        why = "Остались только MTF"
    elseif (staffCount + mtfCount + guardCount + scientistCount) == allCount then
        endRound = true
        why = "Остались только сотрудники комплекса"
    elseif classDCount == allCount then
        endRound = true
        why = "Остались только класс дебилов"
    elseif chaosCount == allCount then
        endRound = true
        why = "Остались только повстанцы с кровати"
    elseif (chaosCount + classDCount) == all then
        endRound = true
        why = "Остались только класс D и повстанцы"
    end

    if not endRound then
        return
    end

    self:ChangeState(ROUND_STATES.CHAT_TIME, why)
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
    self:SetupItems()
    self:SetupButtons()

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
        self:ChangeState(ROUND_STATES.CHAT_TIME, "Время вышло")
    end)
end

function BREACH:OnRoundEnded()
    local time = br_time_postround:GetInt();
    self:SetTimer(time)
    self:BroadcastSound("Mandeville.ogg")

    net.Start("RoundSummaryChanged")
    net.WriteTable(self.stats)
    net.Broadcast()

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

function BREACH:SetupButtons()
    for _, ent in pairs(ents.GetAll()) do
        for _, button in pairs(MAP.BUTTONS) do
            if button.pos and ent:GetPos() == button.pos then
                ent.ButtonConfig = button
            end
        end
    end
end

function BREACH:WinCheck()
    if #player.GetAll() < MIN_PLAYERS then
        return
    end
end

function BREACH:SetupItems()
    for name, item in pairs(ITEMS) do
        local spawns = table.Copy(item.Spawn)
        local spawnCount = table.Count(spawns)

        if item.SpawnFraction then
            spawnCount = math.floor(spawnCount * item.SpawnFraction)
        end

        for _ = 1, spawnCount, 1 do
            if item.ChanceFraction then
                if math.random(0, 100) <= (item.ChanceFraction * 100) then
                    continue
                end
            end

            local entName = Pick(item.Entity)
            local spawn = ExhaustPick(spawns)
            local ent = ents.Create(entName)
            ent:SetPos(Pick(spawn))
            ent:Spawn()

            if item.Spawned then
                item.Spawned(ent)
            end
        end
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
    self.stats[type] = self:Stat(type) + howMuch;
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

function BREACH:BroadcastSoundTo(ply, sound)
    net.Start("BroadcastSound")
    net.WriteString(sound)
    net.Send(ply)
end

function BREACH:ChangeState(state, why)
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
    net.WriteString(why or "")
    net.Broadcast()
end

function BREACH:SetTimer(time)
    self.timerEndsAt = CurTime() + time;
end

