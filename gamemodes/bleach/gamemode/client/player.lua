local PLAYER = FindMetaTable("Player")

function GM:PlayerBindPress(ply, bind, pressed)
    if bind == "+menu" then
        net.Start("DropWeapon")
        net.SendToServer()
    end
end

function GM:OnPlayerChat(ply, strText, bTeam, bDead)
    if (strText == "dropvest") then
        if ply == LocalPlayer() then
            ply:DropCurrentVest()
        end

        return true
    end
end

function PLAYER:DropCurrentVest()
    net.Start("DropCurrentVest")
    net.SendToServer()
end