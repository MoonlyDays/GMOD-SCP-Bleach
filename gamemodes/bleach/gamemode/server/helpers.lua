function WakeEntity(ent)
    local phys = ent:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:SetVelocity(Vector(0, 0, 25))
    end
end

function ForceUse(ent, on, int)
    for _, v in pairs(player.GetAll()) do
        if v:Alive() then
            ent:Use(v, v, on, int)
        end
    end
end