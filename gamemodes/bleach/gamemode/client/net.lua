net.Receive("BroadcastSound", function()
    local sound = net.ReadString();
    surface.PlaySound(sound)
end)

net.Receive("TimerChanged", function()
    HUD.timerEndsAt = CurTime() + net.ReadInt(16);
end)

net.Receive("Blink", function()
    local time = net.ReadFloat()
    HUD.blinkTimer = br_time_blink_delay:GetInt()
    HUD:BlackoutScreen(0, 1, time, 25, 25)
end)

net.Receive("RoundStateChanged", function()
    local state = net.ReadInt(4)

    if state == ROUND_STATES.WAITING_FOR_PLAYERS then
        HUD.waitingForPlayersVisible = true
    end

    if state == ROUND_STATES.SETUP then
        HUD:BlackoutScreen(1, 1, 2, 0, 0.3)
        HUD.objectiveTextVisible = true
        HUD.roundSummaryVisible = false
    end

    if state == ROUND_STATES.ACTIVE then
        HUD.objectiveTextVisible = false
    end

    if state == ROUND_STATES.CHAT_TIME then
    end
end)

net.Receive("StaminaChanged", function()
    HUD.stamina = net.ReadFloat()
end)