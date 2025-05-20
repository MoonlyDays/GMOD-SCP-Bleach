net.Receive("BroadcastSound", function()
    local sound = net.ReadString();
    surface.PlaySound(sound)
end)

net.Receive("TimerChanged", function()
    timerEndsAt = CurTime() + net.ReadInt(16);
    print(timerEndsAt)
end)
