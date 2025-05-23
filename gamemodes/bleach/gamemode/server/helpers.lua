function WakeEntity(ent)
    local phys = ent:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:SetVelocity(Vector(0, 0, 25))
    end
end