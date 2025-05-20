BREACH = {}

function BREACH:Restart()
    self:CleanUp()
    game.CleanUpMap()

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

function BREACH:CleanUp()
    timer.Remove("PlayCommotionSounds");
    timer.Remove("SetupTime");
    timer.Remove("RoundTime");
    timer.Remove("PostTime");

    self.commotionSounds = table.Copy(MAP.COMMOTION_SOUNDS);

    self:ResetStats();
end

function BREACH:ResetStats()
    self.stats = {}
end

function BREACH:Stat(type)
    return self.stats[type] or 0;
end

function BREACH:AddStat(type, howMuch)
    self.stats[type] = self.Stat(type) + howMuch;
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

function BREACH:SetupPlayers()
    for _, ply in pairs(player.GetAll()) do
        ply:SetRole("scp_1987_j")
        ply:Spawn()
    end
end

function BREACH:OnRoundSetup()
    self:BroadcastSound("Alarm2.ogg")
    self:PlayCommotionSound()
    self:SetupPlayers()
end

function BREACH:OnRoundActive()
end

function BREACH:OnRoundEnded()
end