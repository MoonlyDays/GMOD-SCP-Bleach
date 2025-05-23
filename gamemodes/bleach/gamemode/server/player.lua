local PLAYER = FindMetaTable("Player")

function GM:PlayerInitialSpawn(ply)
    ply:SendInitialUpdate()

    if BREACH.state == ROUND_STATES.WAITING_FOR_PLAYERS then
        BREACH:AttemptStartRound()
    end
end

function GM:PlayerSpawn(ply)
    player_manager.SetPlayerClass(ply, "player_breach")
    ply:CleanUp()
    ply:SetupCurrentRole()
end

function GM:PlayerDeath(ply)
    ply:SetRole("")
    ply:SetTeam(TEAMS.SPECTATOR)
end

function GM:PlayerCanPickupWeapon(ply, wep)
    if not ply:IsPlaying() then
        return false
    end

    if wep.ClearanceLevel then
        for _, v in pairs(ply:GetWeapons()) do
            if v.ClearanceLevel then
                return false
            end
        end
    end

    if ply:Team() == TEAMS.SCP then
        return wep.ISSCP == true
    end

    if not ply:IsPlaying() then
        return false
    end

    for _, v in pairs(ply:GetWeapons()) do
        if v:GetClass() == wep:GetClass() then
            return false
        end
    end

    if wep.DroppedAmmo then
        wep:SetClip1(wep.DroppedAmmo)
    end

    return true
end

function GM:PlayerCanPickupItem(ply, item)
    return ply:IsPlaying()
end

function GM:AllowPlayerPickup(ply, ent)
    return ply:IsPlaying()
end

function GM:PlayerUse(ply, ent)
    if not ply:IsPlaying() then
        return false
    end

    if ply.LastUsedAt > CurTime() then
        return false
    end

    ply.LastUsedAt = CurTime() + 1
    print(ent, ent:GetPos())

    if ent.ButtonConfig then
        if ent.ButtonConfig.clearanceLevel and ply:ActiveClearanceLevel() < ent.ButtonConfig.clearanceLevel then
            ply:EmitSound("KeycardUse2.ogg")
            ply:PrintMessage(HUD_PRINTCENTER, "You need to have " .. ent.ButtonConfig.clearanceLevel .. " clearance level to open this door.")
            return false
        end

        if ent.ButtonConfig.used then
            if ent.ButtonConfig.used(ply, ent) == false then
                ply:EmitSound("KeycardUse2.ogg")
                ply:PrintMessage(HUD_PRINTCENTER, "Access denied")
                return false
            end
        end

        ply:EmitSound("KeycardUse1.ogg")
        ply:PrintMessage(HUD_PRINTCENTER, "Access granted to " .. ent.ButtonConfig.name)
        return true
    end

    return true
end

function GM:PlayerSetHandsModel(ply, ent)
    local simpleModel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simpleModel)
    if info then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end

function GM:PlayerTick(ply)
    ply:UpdateStamina()
    ply:UpdateBlink()
end

function PLAYER:SetupCurrentRole()
    local roleName = self:GetRole()
    print("role: ", roleName);
    if roleName == "" then
        self:SetupSpectator()
        return
    end

    local role = ROLES[roleName];
    if not role then
        print("Unknown role name: ", roleName)
        return ;
    end

    self:UnSpectate()
    self:SetModel(Pick(role.Model))
    self:SetTeam(role.Team)
    self:SetMaxHealth(role.Health or 100)
    self:SetHealth(role.Health or 100)
    self:SetPos(Pick(role.Spawn))

    if role.MoveSpeed then
        self:SetWalkSpeed(BASE_WALK_SPEED * role.MoveSpeed)
        self:SetRunSpeed(BASE_WALK_SPEED * role.MoveSpeed)
    else
        self:SetWalkSpeed(BASE_WALK_SPEED * (role.WalkSpeed or 1))
        self:SetRunSpeed(BASE_RUN_SPEED * (role.RunSpeed or 1))
    end

    if role.Weapons then
        for _, weapon in pairs(role.Weapons) do
            self:Give(weapon)
        end
    end

    if role.Ammo then
        for _, ammo in pairs(role.Ammo) do
            self:GiveAmmo(ammo[2], ammo[1], false)
        end
    end

    if role.Armor then
        self:EquipArmor(role.Armor)
    end

    self:SwitchToDefaultWeapon()
    self:SetupHands()
end

function PLAYER:SpawnAs(role)
    self:SetRole(role)
    self:Spawn()
end

function PLAYER:SetupSpectator()
    self:SetTeam(TEAMS.SPECTATOR)
    self:SetNoTarget(true)
    self:SetNoDraw(true)
    self:Spectate(6)
end

function PLAYER:CleanUp()
    self:SetNoCollideWithTeammates(true)
    self:SetCustomCollisionCheck(true)
    self:AllowFlashlight(false)
    self:Flashlight(false)
    self:StripWeapons()
    self:RemoveAllAmmo()
    self:SetCanZoom(false)
    self:SetNoDraw(false)
    self:SprintEnable()
    self:SetModelScale(1)
    self.Stamina = MAX_STAMINA
    self.StaminaRestoresAfter = 0
    self.UsingArmor = nil
    self.AmmoPickupTimes = {}
    self.NextBlinkTime = 0
    self.UnblinkAt = nil
    self.IsBlinking = false
    self.LastUsedAt = 0
end

function PLAYER:UpdateBlink()
    if CurTime() > self.NextBlinkTime then
        self.NextBlinkTime = CurTime() + br_time_blink_delay:GetInt()
        self:Blink(br_time_blink:GetFloat())
    end

    if self.UnblinkAt and CurTime() > self.UnblinkAt then
        self.IsBlinking = false
    end
end

function PLAYER:Blink(time)
    self.UnblinkAt = CurTime() + time;
    self.IsBlinking = true
    net.Start("Blink")
    net.WriteFloat(time)
    net.Send(self)
end

function PLAYER:UpdateStamina()
    if not self:Alive() then
        return
    end

    if self:IsSprinting() and self:GetVelocity():LengthSqr() > 0.1 then
        if self.Stamina > 0 then
            self.Stamina = Approach(self.Stamina, 0, FrameTime() * STAMINA_CONSUME_SPEED)
            self.StaminaRestoresAfter = CurTime() + STAMINA_COOLDOWN
            if self.Stamina == 0 then
                self:SprintDisable()
            end
        end
    else
        if CurTime() > self.StaminaRestoresAfter then
            self.Stamina = Approach(self.Stamina, MAX_STAMINA, FrameTime() * STAMINA_RESTORE_SPEED)
            self:SprintEnable()
        end
    end

    net.Start("StaminaChanged")
    net.WriteFloat(self.Stamina, 8)
    net.Send(self)
end

function PLAYER:SendInitialUpdate()
    net.Start("TimerChanged")
    net.WriteInt(BREACH.timerEndsAt - CurTime(), 16)
    net.Send(self)

    net.Start("RoundStateChanged")
    net.WriteInt(BREACH.state, 4)
    net.Send(self)
end

function PLAYER:CanUseItems()
    return self:IsPlaying() and self:Team() ~= TEAMS.SCP
end

function PLAYER:EquipArmor(armor)
    if self.UsingArmor == armor then
        return
    end

    self:EmitSound(Sound("npc/combine_soldier/zipline_clothing" .. math.random(1, 2) .. ".wav"))
    self.UsingArmor = armor

    local stats = 0.9
    if armor == "armor_chaos" then
        self:SetModel("models/friskiukas/bf4/us_01.mdl")
        stats = 0.85
    elseif armor == "armor_fireproof" then
        self:SetModel("models/fart/ragdolls/css/counter_sas_player.mdl")
        stats = 0.95
    elseif armor == "armor_mtf_com" then
        self:SetModel("models/player/riot.mdl")
        stats = 0.85
    elseif armor == "armor_mtf_lie" then
        self:SetModel("models/mw2/skin_03/mw2_soldier_04.mdl")
        stats = 0.85
    elseif armor == "armor_mtf_medic" then
        self:SetModel("models/payday2/units/medic_player.mdl")
        stats = 0.85
    elseif armor == "armor_mtf_officer" then
        self:SetModel("models/fart/ragdolls/css/counter_sas_player.mdl")
        stats = 0.85
    elseif armor == "armor_sec_chief" then
        self:SetModel("models/mtf/mtf remasteredhd.mdl")
        stats = 0.9
    elseif armor == "armor_sec_guard" then
        self:SetModel("models/player/kerry/class_securety.mdl")
        stats = 0.9
    elseif armor == "armor_sec_officer" then
        self:SetModel("models/fart/ragdolls/css/counter_gign_player.mdl")
        stats = 0.9
    end
end

function PLAYER:DropArmor()
    if not self.UsingArmor then
        return
    end

    self:SetModel(Pick(self:Role().Model))
    local item = ents.Create(self.UsingArmor)
    if IsValid(item) then
        item:Spawn()
        item:SetPos(self:GetPos())
        self:EmitSound(Sound("npc/combine_soldier/zipline_clothing" .. math.random(1, 2) .. ".wav"))
    end

    self.UsingArmor = nil
end