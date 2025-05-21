net.Receive("BroadcastSound", function()
    local sound = net.ReadString();
    surface.PlaySound(sound)
end)

net.Receive("TimerChanged", function()
    timerEndsAt = CurTime() + net.ReadInt(16);
end)

net.Receive("RoundStart", function()
    HUD:BlackoutScreen(1, 5, 2)
    HUD.objectiveTextVisible = true
    HUD.roundSummaryVisible = false
end)

net.Receive("RoundActive", function()
    HUD.objectiveTextVisible = false
end)

net.Receive("RoundEnded", function()
    HUD.roundSummary = net.ReadTable(true)
    HUD.roundSummaryVisible = true
end)