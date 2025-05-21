AddCSLuaFile()

function IsButton(ent, button)
    return ent:GetPos() == button["pos"];
end

function FindButtonByName(name, className)

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