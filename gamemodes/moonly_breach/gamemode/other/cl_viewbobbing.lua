AddCSLuaFile()
-- me when sushi roll
-- Source: https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/game/shared/baseplayer_shared.cpp#L1728
local function CalcRoll(angles, velocity, rollAngle, rollSpeed)
    if angles == nil or velocity == nil then return 0 end
    local right = angles:Right()
    -- Get amount of lateral movement
    local side = velocity:Dot(right)
    -- Right or left side?
    local sign = side < 0 and -1 or 1
    side = math.abs(side)
    local value = rollAngle
    -- Hit 100% of rollAngle at rollSpeed. Below that get linear approx.
    if side < rollSpeed then
        side = side * value / rollSpeed
    else
        side = value
    end
    -- Scale by right/left sign
    return side * sign
end

-- equivalent client ConVars
local cl_rollangle = CreateClientConVar("br_viewbobbing_rollangle", '2', true, true):GetFloat() or 0.8
cvars.AddChangeCallback("br_viewbobbing_rollangle", function(convar, oldValue, newValue) cl_rollangle = tonumber(newValue) or cl_rollangle end)
local cl_rollspeed = CreateClientConVar("br_viewbobbing_rollspeed", '200', true, true):GetFloat() or 200
cvars.AddChangeCallback("br_viewbobbing_rollspeed", function(convar, oldValue, newValue) cl_rollspeed = tonumber(newValue) or cl_rollspeed end)
-- so that we don't calculate roll twice
local rollin = false
hook.Add("CalcView", "LuaClViewRoll_CalcView", function(ply, pos, angles, ...)
    if rollin then return end
    if cl_rollangle == 0 then return end
    if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
    if ply:GetViewEntity() ~= ply then return end
    -- start roll hook
    rollin = true
    -- create table for modification
    local t = {
        angles = angles
    }

    -- call a CalcView hook (thanks to VManip for this piece of code that i didn't consider at all for some reason)
    local hookv = {hook.Run("CalcView", ply, pos, angles, ...)}
    for _, val in ipairs(hookv) do
        if istable(val) then
            for k, v in pairs(val) do
                t[k] = v
            end
        elseif isvector(val) then
            t.origin = val
        elseif isangle(val) then
            t.angles = val
        end
    end

    -- calculate view roll
    local roll = CalcRoll(t.angles, ply:GetAbsVelocity(), cl_rollangle, cl_rollspeed)
    t.angles.r = t.angles.r + roll
    -- end roll hook
    rollin = false
    return t
end)