util.AddNetworkString("PlayerBlink")
util.AddNetworkString("DropWeapon")
util.AddNetworkString("RequestGateA")
util.AddNetworkString("RequestEscorting")
util.AddNetworkString("PrepStart")
util.AddNetworkString("RoundStart")
util.AddNetworkString("PostStart")
util.AddNetworkString("RolesSelected")
util.AddNetworkString("SendRoundInfo")
util.AddNetworkString("Sound_Random")
util.AddNetworkString("Sound_Searching")
util.AddNetworkString("Sound_Classd")
util.AddNetworkString("Sound_Stop")
util.AddNetworkString("Sound_Lost")
util.AddNetworkString("UpdateRoundType")
util.AddNetworkString("ForcePlaySound")
util.AddNetworkString("OnEscaped")
util.AddNetworkString("SlowPlayerBlink")
util.AddNetworkString("DropCurrentVest")
util.AddNetworkString("RoundRestart")
util.AddNetworkString("UpdateTime")
util.AddNetworkString("Update914B")
util.AddNetworkString("CapturedBy106")

net.Receive("RoundRestart", function(len, ply)
    if ply:IsSuperAdmin() then
        RoundRestart()
    end
end)
net.Receive("Sound_Random", function(len, ply)
    PlayerNTFSound("Random" .. math.random(1, 4) .. ".ogg", ply)
end)
net.Receive("Sound_Searching", function(len, ply)
    PlayerNTFSound("Searching" .. math.random(1, 6) .. ".ogg", ply)
end)
net.Receive("Sound_Classd", function(len, ply)
    PlayerNTFSound("ClassD" .. math.random(1, 4) .. ".ogg", ply)
end)
net.Receive("Sound_Stop", function(len, ply)
    PlayerNTFSound("Stop" .. math.random(2, 6) .. ".ogg", ply)
end)
net.Receive("Sound_Lost", function(len, ply)
    PlayerNTFSound("TargetLost" .. math.random(1, 3) .. ".ogg", ply)
end)
net.Receive("DropCurrentVest", function(len, ply)
    if ply:GTeam() ~= TEAM_SPECTATOR and ply:GTeam() ~= TEAM_SCP and ply:Alive() then
        if ply.UsingArmor ~= nil then
            ply:UnUseArmor()
        end
    end
end)
net.Receive("RequestEscorting", function(len, ply)
    if ply:GTeam() == TEAM_GUARD then
        CheckEscortMTF(ply)
    elseif ply:GTeam() == TEAM_CHAOS then
        CheckEscortChaos(ply)
    end
end)

net.Receive("RequestGateA", function(len, ply)
    RequestOpenGateA(ply)
end)

net.Receive("DropWeapon", function(len, ply)
    local wep = ply:GetActiveWeapon()
    if ply:GTeam() == TEAM_SPECTATOR then
        return
    end
    if IsValid(wep) and wep ~= nil and IsValid(ply) then
        local atype = wep:GetPrimaryAmmoType()
        if atype > 0 then
            wep.SavedAmmo = wep:Clip1()
        end
        if wep.GetClass == nil then
            return
        end
        if wep.droppable ~= nil then
            if wep.droppable == false then
                return
            end
        end
        ply:DropWeapon(wep)
        ply:ConCommand("lastinv")
    end
end)

function GetRoleTable(all)
    local classds = 0
    local mtfs = 0
    local researchers = 0
    local staff = 0
    local scps = 0
    if all < 8 then
        scps = 1
        all = all - 1
    elseif all > 7 and all < 16 then
        scps = 2
        all = all - 2
    elseif all > 15 then
        scps = 3
        all = all - 3
    end

    --mtfs = math.Round(all * 0.299)
    local mtfmul = 0.3
    if all > 12 then
        mtfmul = 0.28
    elseif all > 22 then
        mtfmul = 0.26
    end

    mtfs = math.Round(all * mtfmul)
    all = all - mtfs
    researchers = math.floor(all * 0.38)
    all = all - researchers
    staff = math.floor(all * 0.3)
    all = all - staff
    classds = all
    --print(scps .. "," .. mtfs .. "," .. classds .. "," .. researchers .. "," .. chaosinsurgency)
    --[[
    print("scps: " .. scps)
    print("mtfs: " .. mtfs)
    print("classds: " .. classds)
    print("researchers: " .. researchers)
    print("chaosinsurgency: " .. chaosinsurgency)
    ]]
    return { scps, mtfs, classds, researchers, staff }
end

function GetRoleTableCustom(all, scps, p_sec, p_res, p_staff)
    local classds = 0
    local security = 0
    local researchers = 0
    local staff = 0
    all = all - scps
    security = math.Round(all * p_sec)
    all = all - security
    researchers = math.floor(all * p_res)
    all = all - researchers
    staff = math.floor(all * p_staff)
    all = all - staff
    classds = all
    return { scps, security, classds, researchers, staff }
end

function IsRoleMaxed(role)
    local using = 0
    for _, pl in pairs(player.GetAll()) do
        if pl:GetNClass() == role.name then
            using = using + 1
        end
    end
    return using >= role.max
end

function uber_random(num)
    local power = 99999999
    local rnd = math.Round(math.random(1, power) % num)
    return rnd + 1
end

function uber_random_table(tab)
    return tab[uber_random(#tab)]
end

function uber_random_test(num, tests)
    local tab = {}
    for i = 1, tests do
        local rnd = uber_random(num)
        if tab[rnd] == nil then
            tab[rnd] = 0
        end
        tab[rnd] = tab[rnd] + 1
    end

    for i, v in ipairs(tab) do
        print(i .. "	-	" .. math.Round((v / tests) * 100) .. "%")
    end
end

function SetupPlayers_new()
    for k, v in pairs(player.GetAll()) do
        v:SetSpectator()
    end

    local allpl = player.GetAll()
    local num_of_players = math.Clamp(#allpl, 1, #Breach_Default_Role_List)
    local our_role_list = {}
    for i = 1, num_of_players do
        local role = Breach_Default_Role_List[i]
        if our_role_list[role] == nil then
            our_role_list[role] = 0
        end
        our_role_list[role] = our_role_list[role] + 1
    end

    local players_to_use = {}
    for i = 1, num_of_players do
        --local pl_to_use = table.Random(allpl)
        local pl_to_use = uber_random_table(allpl)
        table.ForceInsert(players_to_use, pl_to_use)
        table.RemoveByValue(allpl, pl_to_use)
    end

    local security_spawns = table.Copy(SPAWN_GUARD)
    local research_spawns = table.Copy(SPAWN_SCIENTIST)
    local chaosins_spawns = table.Copy(SPAWN_CHAOS)
    local classds_spawns = table.Copy(SPAWN_CLASS_D)
    local spc_tab = table.Copy(SCPS)
    for k, v in pairs(players_to_use) do
        if our_role_list[ROLE_LIST_SECURITY] ~= nil and our_role_list[ROLE_LIST_SECURITY] > 0 then
            our_role_list[ROLE_LIST_SECURITY] = our_role_list[ROLE_LIST_SECURITY] - 1
            local security_roles = ALL_CLASSES["security"]["roles"]
            local best_role_to_use = security_roles[1]
            for k2, role in pairs(security_roles) do
                local can = true
                if isfunction(role.customcheck) then
                    if role.customcheck(v) == false then
                        can = false
                    end
                end
                if can == true then
                    if IsRoleMaxed(role) == false and v:GetLevel() >= role.level and role.level > best_role_to_use.level then
                        if role.players_min ~= nil then
                            if num_of_players >= role.players_min then
                                --print("1 "..role.name.."("..role.level..")".." better than "..best_role_to_use.name.."("..best_role_to_use.level..")")
                                best_role_to_use = role
                            end
                        else
                            --print("2 "..role.name.."("..role.level..")".." better than "..best_role_to_use.name.."("..best_role_to_use.level..")")
                            best_role_to_use = role
                        end
                        --else
                        --print("nop "..role.name.." IsRoleMaxed:"..tostring(IsRoleMaxed(role)).." levels1:"..tostring(v:GetLevel() >= role.level).." levels2:"..tostring(role.level > best_role_to_use.level))
                    end
                end
            end

            local spawn = table.Random(security_spawns)
            v:SetupNormal()
            v:ApplyRoleStats(best_role_to_use)
            v:SetPos(spawn)
            table.RemoveByValue(security_spawns, spawn)
        elseif our_role_list[ROLE_LIST_CLASSDS] ~= nil and our_role_list[ROLE_LIST_CLASSDS] > 0 then
            our_role_list[ROLE_LIST_CLASSDS] = our_role_list[ROLE_LIST_CLASSDS] - 1
            v:SetRoleBestFrom("classds")
            local spawn = table.Random(classds_spawns)
            v:SetPos(spawn)
            table.RemoveByValue(classds_spawns, spawn)
        elseif our_role_list[ROLE_LIST_RESEARCH_STAFF] ~= nil and our_role_list[ROLE_LIST_RESEARCH_STAFF] > 0 then
            our_role_list[ROLE_LIST_RESEARCH_STAFF] = our_role_list[ROLE_LIST_RESEARCH_STAFF] - 1
            v:SetRoleBestFrom("research_staff")
            local spawn = table.Random(research_spawns)
            v:SetPos(spawn)
            table.RemoveByValue(research_spawns, spawn)
        elseif our_role_list[ROLE_LIST_MISC_STAFF] ~= nil and our_role_list[ROLE_LIST_MISC_STAFF] > 0 then
            our_role_list[ROLE_LIST_MISC_STAFF] = our_role_list[ROLE_LIST_MISC_STAFF] - 1
            v:SetRoleBestFrom("misc_staff")
            local spawn = table.Random(research_spawns)
            v:SetPos(spawn)
            table.RemoveByValue(research_spawns, spawn)
        elseif our_role_list[ROLE_LIST_CHAOSINS] ~= nil and our_role_list[ROLE_LIST_CHAOSINS] > 0 then
            our_role_list[ROLE_LIST_CHAOSINS] = our_role_list[ROLE_LIST_CHAOSINS] - 1
            v:SetRoleBestFrom("chaosins")
            local spawn = table.Random(chaosins_spawns)
            v:SetPos(spawn)
            table.RemoveByValue(chaosins_spawns, spawn)
        elseif our_role_list[ROLE_LIST_SCPS] ~= nil and our_role_list[ROLE_LIST_SCPS] > 0 then
            our_role_list[ROLE_LIST_SCPS] = our_role_list[ROLE_LIST_SCPS] - 1
            if #spc_tab < 1 then
                spc_tab = table.Copy(SCPS)
            end
            local scp = table.Random(spc_tab)
            scp = spc_tab[1]
            scp["func"](v)
            table.RemoveByValue(spc_tab, scp)
        end
    end
end

function SetupPlayers(pltab)
    local allply = GetActivePlayers()
    -- SCPS
    local spctab = table.Copy(SCPS)
    for _ = 1, pltab[1] do
        if #spctab < 1 then
            spctab = table.Copy(SCPS)
        end
        local pl = table.Random(allply)
        if IsValid(pl) == false then
            return
        end
        local scp = table.Random(spctab)
        scp["func"](pl)
        print("assigning " .. pl:Nick() .. " to scps")
        table.RemoveByValue(spctab, scp)
        table.RemoveByValue(allply, pl)
    end

    -- Class D Personnel
    local dspawns = table.Copy(SPAWN_CLASS_D)
    for i = 1, pltab[3] do
        if #dspawns > 0 then
            local pl = table.Random(allply)
            if IsValid(pl) == false then
                return
            end
            local spawn = table.Random(dspawns)
            pl:SetupNormal()
            pl:SetClassD()
            pl:SetPos(spawn)
            print("assigning " .. pl:Nick() .. " to classds")
            table.RemoveByValue(dspawns, spawn)
            table.RemoveByValue(allply, pl)
        end
    end

    -- Researcher Staff
    local resspawns = table.Copy(SPAWN_SCIENTIST)
    for i = 1, pltab[4] do
        if #resspawns > 0 then
            local pl = table.Random(allply)
            if IsValid(pl) == false then
                return
            end
            local spawn = table.Random(resspawns)
            pl:SetupNormal()
            pl:SetResearcher()
            pl:SetPos(spawn)
            print("assigning " .. pl:Nick() .. " to researchers")
            table.RemoveByValue(resspawns, spawn)
            table.RemoveByValue(allply, pl)
        end
    end

    -- Misc Staff
    for i = 1, pltab[5] do
        if #resspawns > 0 then
            local pl = table.Random(allply)
            if IsValid(pl) == false then
                return
            end
            local spawn = table.Random(resspawns)
            pl:SetupNormal()
            pl:SetStaff()
            pl:SetPos(spawn)
            print("assigning " .. pl:Nick() .. " to misc staff")
            table.RemoveByValue(resspawns, spawn)
            table.RemoveByValue(allply, pl)
        end
    end

    -- Security
    local security = ALL_CLASSES["security"]["roles"]
    local snum = pltab[2]
    local securityspawns = table.Copy(SPAWN_GUARD)
    local i4 = math.floor(snum / 8)
    local i4roles = {}
    local i4players = {}
    local i3roles = {}
    local i3players = {}
    local i2roles = {}
    local i2players = {}
    for k, v in pairs(security) do
        if v.importancelevel == 4 then
            table.ForceInsert(i4roles, v)
        elseif v.importancelevel == 3 then
            table.ForceInsert(i3roles, v)
        elseif v.importancelevel == 2 then
            table.ForceInsert(i2roles, v)
        end
    end

    for _, pl in pairs(allply) do
        for k, v in pairs(security) do
            if v.importancelevel > 1 then
                local can = true
                if v.customcheck ~= nil then
                    if v.customcheck(pl) == false then
                        can = false
                    end
                end
                if can == true then
                    if pl:GetLevel() >= v.level then
                        if v.importancelevel == 2 then
                            table.ForceInsert(i2players, pl)
                        elseif v.importancelevel == 3 then
                            table.ForceInsert(i3players, pl)
                        else
                            table.ForceInsert(i4players, pl)
                        end
                    end
                end
            end
        end
    end

    if i4 >= 1 then
        if #i4roles > 0 and #i4players > 0 then
            local pl = table.Random(i4players)
            local spawn = table.Random(securityspawns)
            pl:SetupNormal()
            pl:ApplyRoleStats(table.Random(i4roles))
            table.RemoveByValue(i4players, pl)
            table.RemoveByValue(i3players, pl)
            table.RemoveByValue(i2players, pl)
            pl:SetPos(spawn)
            print("assigning " .. pl:Nick() .. " to security i4")
            table.RemoveByValue(securityspawns, spawn)
            table.RemoveByValue(allply, pl)
        end
    end

    if #i3roles > 0 and #i3players > 0 then
        local pl = table.Random(i3players)
        local spawn = table.Random(securityspawns)
        pl:SetupNormal()
        pl:ApplyRoleStats(table.Random(i3roles))
        table.RemoveByValue(i4players, pl)
        table.RemoveByValue(i3players, pl)
        table.RemoveByValue(i2players, pl)
        pl:SetPos(spawn)
        print("assigning " .. pl:Nick() .. " to security i3")
        table.RemoveByValue(securityspawns, spawn)
        table.RemoveByValue(allply, pl)
    end

    if #i2roles > 0 and #i2players > 0 then
        local pl = table.Random(i2players)
        local spawn = table.Random(securityspawns)
        pl:SetupNormal()
        pl:ApplyRoleStats(table.Random(i2roles))
        pl:SetPos(spawn)
        table.RemoveByValue(i4players, pl)
        table.RemoveByValue(i3players, pl)
        table.RemoveByValue(i2players, pl)
        print("assigning " .. pl:Nick() .. " to security i2")
        table.RemoveByValue(securityspawns, spawn)
        table.RemoveByValue(allply, pl)
    end

    for k, v in pairs(allply) do
        local spawn = table.Random(securityspawns)
        v:SetupNormal()
        v:SetSecurityI1()
        v:SetPos(spawn)
        print("assigning " .. v:Nick() .. " to security i1")
        table.RemoveByValue(securityspawns, spawn)
    end

    net.Start("RolesSelected")
    net.Broadcast()
end

util.AddNetworkString("BR_CreateSmoke")
local button_doors_cont1 = NULL
local button_doors_cont2 = NULL
-- lua_run TestBlockRoom()
function TestBlockRoom()
    local button1_pos = Vector(3849.000000, 1128.000000, 53.000000)
    local button2_pos = Vector(3209.000000, 1128.000000, 53.000000)
    for k, v in pairs(ents.GetAll()) do
        if v:GetPos() == button1_pos then
            button_doors_cont1 = v
            button_doors_cont1.BreachButton = {}
            button_doors_cont1.BreachButton.usesounds = false
            button_doors_cont1.BreachButton.customdenymsg = "Room is contaminated!"
            button_doors_cont1.BreachButton.canactivate = function(pl, ent)
                return false
            end
            button_doors_cont1.BreachButton.clevel = 10
            button_doors_cont1.BreachButton.name = "Contaminated doors 1"
            print("f1")
        elseif v:GetPos() == button2_pos then
            button_doors_cont2 = v
            button_doors_cont2.BreachButton = {}
            button_doors_cont2.BreachButton.usesounds = false
            button_doors_cont2.BreachButton.customdenymsg = "Room is contaminated!"
            button_doors_cont2.BreachButton.canactivate = function(pl, ent)
                return false
            end
            button_doors_cont2.BreachButton.clevel = 10
            button_doors_cont2.BreachButton.name = "Contaminated doors 2"
            print("f2")
        end
        --if IsValid(button_doors_cont1) and IsValid(button_doors_cont2) then
        --	break
        --end
    end

    local gaspos1 = Vector(3208, 1009, -45)
    local gaspos2 = Vector(3832, 1167, 142)
    table.ForceInsert(GAS_AREAS, {
        pos1 = gaspos1,
        pos2 = gaspos2,
        cont = true
    })

    PrintTable(GAS_AREAS)
    print(button_doors_cont1)
    print(button_doors_cont2)
    local gas_to_create = { Vector(3732.5439453125, 1086.2879638672, 5.03125), Vector(3621.2922363281, 1089.9815673828, 5.0312576293945), Vector(3494.8229980469, 1089.9968261719, 5.03125), Vector(3373.4855957031, 1089.3991699219, 5.0312576293945), }
    for k, v in pairs(gas_to_create) do
        SV_CreateSmoke(v, 8)
    end

    timer.Simple(8, UnlockContaminatedDoors)
end

hook.Add("Tick", "br_tick_contamination", function()
    if GAS_AREAS then
        for k, v in pairs(GAS_AREAS) do
            if v.cont == true then
                local door1_pos = Vector(3840.207275, 1118.968750, 54.846138)
                local door1_tr1 = util.TraceLine({
                    start = door1_pos,
                    endpos = Vector(3840.423340, 1057.031250, 90.844742),
                    mask = MASK_SOLID
                })

                local door1_tr2 = util.TraceLine({
                    start = door1_pos,
                    endpos = Vector(3840.722656, 1057.031250, 20.871456),
                    mask = MASK_SOLID
                })

                if (door1_tr1.Fraction == 1) and (door1_tr2.Fraction == 1) then
                    ForceUse(button_doors_cont1, 1, 1)
                end
                local door2_pos = Vector(3198.953613, 1118.968750, 54.763931)
                local door2_tr1 = util.TraceLine({
                    start = door2_pos,
                    endpos = Vector(3199.379883, 1057.031250, 91.456055),
                    mask = MASK_SOLID
                })

                local door2_tr2 = util.TraceLine({
                    start = door2_pos,
                    endpos = Vector(3200.014893, 1057.031250, 20.917458),
                    mask = MASK_SOLID
                })

                if (door2_tr1.Fraction == 1) and (door2_tr2.Fraction == 1) then
                    ForceUse(button_doors_cont2, 1, 1)
                end
            end
        end
    end
end)

function UnlockContaminatedDoors()
    if IsValid(button_doors_cont1) then
        print("u1")
        button_doors_cont1.BreachButton = nil
    end

    if IsValid(button_doors_cont2) then
        print("u2")
        button_doors_cont2.BreachButton = nil
    end

    for area_i, area in ipairs(GAS_AREAS) do
        if area.cont == true then
            table.remove(GAS_AREAS, area_i)
        end
    end
end

function SV_CreateSmoke(pos, length)
    net.Start("BR_CreateSmoke")
    net.WriteVector(pos)
    net.WriteInt(length, 16)
    net.Broadcast()
end