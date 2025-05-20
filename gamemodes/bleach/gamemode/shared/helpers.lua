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