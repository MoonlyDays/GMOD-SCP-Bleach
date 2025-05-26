SCP_914 = {
    nextUseTime = 0,
    buttonStatus = 0
}

function SCP_914:Change(ply)
    if CurTime() < self.nextUseTime then
        return false
    end

    self.nextUseTime = CurTime() + 1.3
    self.buttonStatus = self.buttonStatus + 1
    if self.buttonStatus > 4 then
        self.buttonStatus = 0
    end

    ply:PrintMessage(HUD_PRINTTALK, "Changed to " .. SCP_914_STATUSES[self.buttonStatus])

    net.Start("SCP914_Update")
    net.WriteInt(self.buttonStatus, 6)
    net.Broadcast()

    return true
end

function SCP_914:CleanUp()
    self.nextUseTime = 0
    self.buttonStatus = 0
end

function SCP_914:Use(ply)
    if CurTime() < self.nextUseTime then
        return false
    end

    return true
end
