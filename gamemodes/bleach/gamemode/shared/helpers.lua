AddCSLuaFile()

function player.GetPlaying()
    local dick = {}
    for _, ply in pairs(player.GetAll()) do
        if ply:IsPlaying() then
            table.insert(dick, ply)
        end
    end
    return dick
end

function Pick(container)
    if (istable(container)) then
        return table.Random(container)
    end

    return container
end

function ExhaustPick(container)
    if istable(container) then
        local item = table.Random(container)
        table.RemoveByValue(container, item)
        return item
    end

    return container
end

function LerpTo(current, target, step)
    if math.abs(target - current) < 0.001 then
        return target
    end
    return current + (target - current) * step
end

function Percent(current, max)
    return math.floor(Fraction(current, max) * 100) .. " %";
end

function Fraction(current, max)
    return math.Clamp(current / max, 0, 1)
end

function Approach(current, target, step)
    if current < target then
        return math.min(current + step, target)
    elseif current > target then
        return math.max(current - step, target)
    else
        return target
    end
end

function table.Map(input, func)
    local out = {}
    for k, v in pairs(input) do
        out[k] = func(v);
    end
    return out;
end

function table.Join(input, del)
    local out = "";
    for i = 0, #input do
        local val = input[i] or "";
        if i == 1 then
            out = val;
        else
            out = out .. del .. val;
        end
    end
    return out
end