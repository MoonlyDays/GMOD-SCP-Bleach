AddCSLuaFile()

sound.Add( { 
  name = "breach/weapons/scpcatj/catgun.catgun_fire",
  channel = CHAN_WEAPON,
  volume = 0.90,
  level = SNDLVL_GUNFIRE,
  sound = { 
    "breach/weapons/scpcatj/catgun_fire01.wav",
    "breach/weapons/scpcatj/catgun_fire02.wav",
    "breach/weapons/scpcatj/catgun_fire03.wav",
    "breach/weapons/scpcatj/catgun_fire04.wav",
    "breach/weapons/scpcatj/catgun_fire05.wav",
    "breach/weapons/scpcatj/catgun_fire06.wav",
    "breach/weapons/scpcatj/catgun_fire07.wav",
    "breach/weapons/scpcatj/catgun_fire08.wav"
  }
} )
sound.Add( { name = "catgun.catgun_reload", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "breach/weapons/scpcatj/catgun_reload.wav" } )
sound.Add( { name = "catgun.catgun_reload00", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "breach/weapons/scpcatj/catgun_reload00.wav" } )
--sound.Add( { name = "catgun.catgun_reload_shorter", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "breach/weapons/scpcatj/catgun_reload_shorter.wav" } )
--sound.Add( { name = "catgun.catgun_reload00_shorter", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "breach/weapons/scpcatj/catgun_reload00_shorter.wav" } )
sound.Add( { name = "catgun.catgun_deploy", channel = CHAN_STATIC, volume = 0.70, level = SNDLVL_NORM, sound = "breach/weapons/scpcatj/catgun_deploy.wav" } )



local TTT = ( GAMEMODE_NAME == "terrortown" )

SWEP.Base = TTT and "weapon_tttbase" or "weapon_base"

local cvarprefix = "catgun" -- I suck at naming :D

CreateConVar( cvarprefix .. "_inspecting", 1, FCVAR_ARCHIVE, "Allow inspecting" )

local ACT_VM_IDLE_TO_IS = ACT_VM_RELOAD_INSERT
local ACT_VM_IDLE_IS = ACT_VM_RELOAD_IDLE
local ACT_VM_PRIMARYATTACK_IS = ACT_VM_SECONDARYATTACK
local ACT_VM_IS_TO_IDLE = ACT_VM_RELOAD_END
local ACT_VM_INSPECT = ACT_VM_RELOAD

local SPRINT_MINSPEED = 250

local MODE_HOLD = true
local MODE_TOGGLE = false

if CLIENT then
  
  SWEP.Category  = "Other"
  SWEP.Slot = 4 -- Slot in the weapon selection menu
  SWEP.SlotPos = 0 -- Position in the slot
  SWEP.DrawAmmo = true -- Should draw the default HL2 ammo counter
  SWEP.DrawCrosshair = true -- Should draw the default crosshair
  SWEP.DrawWeaponInfoBox = false -- Should draw the weapon info box
  SWEP.BounceWeaponIcon = false -- Should the weapon icon bounce?
  SWEP.SwayScale = 1.0 -- The scale of the viewmodel sway
  SWEP.BobScale = 1.0 -- The scale of the viewmodel bob

-- Override this in your SWEP to set the icon in the weapon selection
  SWEP.WepSelectIcon = surface.GetTextureID( "weapons/catgun_hud" )
  killicon.Add( "weapon_catgun", "hud/killicons/catgun", Color( 255, 80, 0, 255 ) )
end

if SERVER then
  SWEP.Weight = 5 -- Decides whether we should switch from/to this
  SWEP.AutoSwitchTo = true -- Auto switch to if we pick it up
  SWEP.AutoSwitchFrom = true -- Auto switch from if you pick up a better weapon
end

SWEP.PrintName = "SCP-CAT-J" -- 'Nice' Weapon name (Shown on HUD)

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/v_catgun.mdl"
SWEP.WorldModel = "models/weapons/w_catgun.mdl" --@TODO: make it as ragdoll

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.Sound = Sound("breach/weapons/scpcatj/catgun.catgun_fire") 
SWEP.Primary.ClipSize = 69 -- Size of a clip
SWEP.Primary.Damage = 1
SWEP.Primary.DefaultClip	= 120 -- Default number of bullets in a clip
SWEP.Primary.Automatic = true -- Automatic/Semi Auto
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Spread = 0.4
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.12
SWEP.Primary.Force = 1

--SWEP.Secondary.ClipSize = -1 -- Size of a clip
--SWEP.Secondary.DefaultClip = -1 -- Default number of bullets in a clip
--SWEP.Secondary.Automatic	= false -- Automatic/Semi Auto
SWEP.Secondary.Ammo = "none"

SWEP.UseHands = true

SWEP.HoldType = "smg"

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

-- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HEAVY

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
-- SWEP.AmmoEnt = "item_ammo_smg1_ttt"

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = nil

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = false

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true -- We use our own ironisghting

-- This sets the icon shown for the weapon in the DNA sampler, search window,
-- equipment menu (if buyable), etc.
SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess

-- end TTT config

SWEP.NextIronsightTime = 0.01
SWEP.ReloadTime = 2.5



function SWEP:Initialize()
  self:SetHoldType( self.HoldType ) -- Avoid using SetWeaponHoldType! Otherwise the players could hold it wrong!
end



function SWEP:SetupDataTables() --This also used for variable declaration and SetVar/GetVar getting work
  self:NetworkVar( "Bool", 0, "Ironsight" )
  self:NetworkVar( "Bool", 1, "Sprint" )
  self:NetworkVar( "Float", 0, "InspectTime" )
  self:NetworkVar( "Float", 1, "IdleTime" )
  self:NetworkVar( "Float", 2, "IronsightTime" ) --Next time when we can switch ironsight. Also used to interp viewpos.
  self:NetworkVar( "Float", 3, "SprintTime" )
end



function SWEP:PlayAnim( Act )
  if self.Owner:IsNPC() or not IsFirstTimePredicted() then return end
  self.Weapon:SendWeaponAnim( Act )
  self:SetIdleTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
  --self:SetSprintTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
end



function SWEP:PrimaryAttack()
-- ToDo:
-- * Muzzleflash when firing (Do we need to make it here in lua or inside qc of model? Anyway, we need to add attachments to model aswell);
 
    if ( self.Weapon:Clip1() <= 0 ) then return end
    
    local ironsight = self:GetIronsight()
 
    local bullet    = {} 
    bullet.Num      = self.Primary.NumberofShots 
    bullet.Src      = self.Owner:GetShootPos() or Vector()
    bullet.Dir      = self.Owner:GetAimVector() 
    bullet.Spread   = Vector( 1, 1, 0 ) * ( self.Primary.Spread * 0.1 ) / ( ironsight and 3.0 or 1.0 )
    bullet.Tracer   = 1 
    bullet.Force    = self.Primary.Force 
    bullet.Damage   = self.Primary.Damage 
    bullet.AmmoType = self.Primary.Ammo
 
    self:PlayAnim( ironsight and ACT_VM_PRIMARYATTACK_IS or ACT_VM_PRIMARYATTACK )
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
 
    self.Owner:FireBullets( bullet ) 
    self:TakePrimaryAmmo( 1 )
    -- self.Owner:ViewPunch( Angle( -1, 0, 0 ) )
    
    self:EmitSound( Sound(self.Primary.Sound) )
 
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self:SetSprintTime( CurTime() + self.Primary.Delay )
    -- if not self.Owner:IsNPC() then self:SetIdleTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() ) end -- GetViewModel() doesn't work on npcs
end



function SWEP:SecondaryAttack() end



function SWEP:SprintSwitchTo( bool )
  local sprinting = self:GetSprint()
  if sprinting == bool then return end
  self:PlayAnim( bool and ACT_VM_SPRINT_ENTER or ACT_VM_SPRINT_LEAVE )
  self:SetSprint( bool )
end



function SWEP:IronsightSwitchTo( bool )
  local ironsight = self:GetIronsight()
  if ironsight == bool then return end
  self:PlayAnim( bool and ACT_VM_IDLE_TO_IS or ACT_VM_IS_TO_IDLE )
  self:SetIronsight( bool )
end



function SWEP:Think()

  local ironsight = self:GetIronsight()
  
  local velocity = self.Owner:GetVelocity():Length2D()
  
  local sprinting = self:GetSprint()
  if CurTime()>=self:GetSprintTime() then
    if self.Owner:KeyDown( IN_SPEED ) and self.Owner:IsOnGround() and not self.Owner:Crouching() and velocity >= SPRINT_MINSPEED then
      self:SprintSwitchTo( true )
    else
      self:SprintSwitchTo( false )
    end
  end
  
  local switchmode = MODE_TOGGLE -- @TODO: read user cvar
  if CurTime()>=self:GetIronsightTime() then
  
    if switchmode then
--      if self.Owner:KeyDown( IN_ATTACK2 ) then self:IronsightSwitchTo( true ) end
--      if self.Owner:KeyReleased( IN_ATTACK2 ) then self:IronsightSwitchTo( false ) end
      self:IronsightSwitchTo( self.Owner:KeyDown( IN_ATTACK2 ) and not sprinting )
    else
      if sprinting then self:IronsightSwitchTo( false )
      elseif self.Owner:KeyPressed( IN_ATTACK2 ) then self:IronsightSwitchTo( not ironsight ) end
    end
    
  end
  
  if CurTime() >= self:GetIdleTime() and not self.Owner:IsNPC() then self:PlayAnim( sprinting and ACT_VM_SPRINT_IDLE or ironsight and ACT_VM_IDLE_IS or ACT_VM_IDLE ) end
  
  self.BobScale = ironsight and 0.01 or 1.0
  self.SwayScale = ironsight and 0.0 or 1.0
  
  if self.Weapon:Clip1() <= 0 and self:Ammo1() > 0 and CurTime() >= self.Weapon:GetNextPrimaryFire() + 0.05 then self:Reload() end
  
end



function SWEP:Deploy()
  self:SetInspectTime( 0 )
  local NextAttack = 1
  self:SetIronsight( false )
  self:SetSprint( false )
  self:SetIronsightTime( CurTime() + NextAttack )
  self:PlayAnim( ACT_VM_DRAW )
  self:SetSprintTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
  self.Weapon:SetNextPrimaryFire( CurTime() + NextAttack )
  return true -- fixes quick switching!
end



function SWEP:Reload()
  if ( not self:HasAmmo() ) or ( CurTime() < self.Weapon:GetNextPrimaryFire() ) then return end
  if self.Weapon:Clip1() < self.Primary.ClipSize and self:Ammo1() > 0 then
    self:SetIronsight( false )
    self:SetSprint( false )
    self.Weapon:DefaultReload( ACT_VM_RELOAD )
    self:SetIdleTime( CurTime() + self.ReloadTime )
    self:SetIronsightTime( CurTime() + self.ReloadTime )
    self:SetSprintTime( CurTime() + self.ReloadTime )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadTime )
    --self:EmitSound( self.SoundReload )
  else self:Inspect() end
end



function SWEP:Inspect()
  if self.Owner:IsNPC() then return end -- NPCs aren't supposed to reload it

  local keydown = self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) or self.Owner:KeyDown(IN_ZOOM) or self.Owner:KeyDown(IN_SPEED)
  if not cvars.Bool( cvarprefix .. "_inspecting", true) or keydown then return end

  local getseq = self:GetSequence()
  local act = self:GetSequenceActivity(getseq) --GetActivity() method doesn't work :\
  if ( act == ACT_VM_INSPECT and CurTime() < self:GetInspectTime() ) then
    self:SetInspectTime( CurTime() + 0.1 ) -- We should press R repeately instead of holding it to loop
  return end

  self:PlayAnim( ACT_VM_INSPECT )
  self:SetIronsight( false )
  self:SetSprint( false )
  self:SetInspectTime( CurTime() + 0.1 )
end



-- Stuff ripped from Doom3 SWEPS by Upset
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
  surface.SetDrawColor(255, 235, 20, alpha)
  surface.SetTexture(self.WepSelectIcon)
  local texw, texh = surface.GetTextureSize(self.WepSelectIcon)
  
  wide = (texw*wide)/160
  tall = tall/1.75
  x = x + wide/8
  y = y + tall/3
  
  if texw == 64 then
    x = x + wide*.6
  end

  surface.DrawTexturedRect(x, y, wide, tall)
end



function SWEP:SetupWeaponHoldTypeForAI(t)
  self.ActivityTranslateAI = {}
  
  self.ActivityTranslateAI[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_SMG1
  self.ActivityTranslateAI[ACT_RELOAD] = ACT_RELOAD_SMG1
  self.ActivityTranslateAI[ACT_IDLE] = ACT_IDLE_SMG1
  self.ActivityTranslateAI[ACT_IDLE_ANGRY] = ACT_IDLE_ANGRY_SMG1
  self.ActivityTranslateAI[ACT_WALK] = ACT_WALK_RIFLE
  
  self.ActivityTranslateAI[ACT_IDLE_RELAXED] = ACT_IDLE_SMG1_RELAXED
  self.ActivityTranslateAI[ACT_IDLE_STIMULATED] = ACT_IDLE_SMG1_STIMULATED
  self.ActivityTranslateAI[ACT_IDLE_AGITATED] = ACT_IDLE_ANGRY_SMG1
  
  self.ActivityTranslateAI[ACT_WALK_RELAXED] = ACT_WALK_RIFLE_RELAXED
  self.ActivityTranslateAI[ACT_WALK_STIMULATED] = ACT_WALK_RIFLE_STIMULATED
  self.ActivityTranslateAI[ACT_WALK_AGITATED] = ACT_WALK_AIM_RIFLE
  
  self.ActivityTranslateAI[ACT_RUN_RELAXED] = ACT_RUN_RIFLE_RELAXED
  self.ActivityTranslateAI[ACT_RUN_STIMULATED] = ACT_RUN_RIFLE_STIMULATED
  self.ActivityTranslateAI[ACT_RUN_AGITATED] = ACT_RUN_AIM_RIFLE
  
  self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED] = ACT_IDLE_SMG1_RELAXED
  self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED] = ACT_IDLE_AIM_RIFLE_STIMULATED
  self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED] = ACT_IDLE_ANGRY_SMG1
    
  self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED] = ACT_WALK_RIFLE_RELAXED
  self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED] = ACT_WALK_AIM_RIFLE_STIMULATED
  self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED] = ACT_WALK_AIM_RIFLE
    
  self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED] = ACT_RUN_RIFLE_RELAXED
  self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED] = ACT_RUN_AIM_RIFLE_STIMULATED
  self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED] = ACT_RUN_AIM_RIFLE
  
  self.ActivityTranslateAI[ACT_WALK_AIM] = ACT_WALK_AIM_RIFLE
  self.ActivityTranslateAI[ACT_WALK_CROUCH] = ACT_WALK_CROUCH_RIFLE
  self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM] = ACT_WALK_CROUCH_AIM_RIFLE
  self.ActivityTranslateAI[ACT_RUN] = ACT_RUN_RIFLE
  self.ActivityTranslateAI[ACT_RUN_AIM] = ACT_RUN_AIM_RIFLE
  self.ActivityTranslateAI[ACT_RUN_CROUCH] = ACT_RUN_CROUCH_RIFLE
  self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM] = ACT_RUN_CROUCH_AIM_RIFLE
  self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_SMG1
  self.ActivityTranslateAI[ACT_COVER_LOW] = ACT_COVER_SMG1_LOW
  self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] = ACT_RANGE_AIM_SMG1_LOW
  self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_SMG1_LOW
  self.ActivityTranslateAI[ACT_RELOAD_LOW] = ACT_RELOAD_SMG1_LOW
  self.ActivityTranslateAI[ACT_GESTURE_RELOAD] = ACT_GESTURE_RELOAD_SMG1
end



--if SERVER then
--  function SWEP:NPCShoot_Primary(ShootPos, ShootDir)
--  local owner = self:GetOwner()
--  if !IsValid(owner) then return end
--  timer.Create("CatgunNPCattack"..owner:EntIndex(), self.Primary.Delay, 3, function() -- TODO: make network var instead of timer.
--    if !owner or !IsValid(owner) then return end
--    self:PrimaryAttack()
--    end)
--  end
--end
-- end of ripped stuff



function SWEP:NPCShoot_Secondary( ShootPos, ShootDir ) end



function SWEP:Holster( wep )
  return true
end



function SWEP:OnRemove()
end



function SWEP:OwnerChanged()
end

--YOU'RE WINNER!