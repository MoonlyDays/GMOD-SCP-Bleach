AddCSLuaFile()
ENT.PrintName = "SCP-173"
ENT.Author = "Kanade"
ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Owner = nil
ENT.IsAttacking = false
ENT.CurrentTargets = {}
ENT.Attacks = 0
ENT.SnapSound = Sound("snap.wav")
function ENT:Use(activator, caller)
	return false
end

function ENT:SetCurrentOwner(ply)
	self.Owner = ply
	self:SetNWEntity("173Owner", ply)
end

function ENT:GetCurrentOwner()
	return self.Owner
end

function ENT:OnTakeDamage(dmginfo)
	if self.Owner:IsPlayer() == true then
		self.Owner:TakeDamageInfo(dmginfo)
	else
		self:Remove()
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/breach173.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	--self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_FLY)
	self.Entity:SetSolid(SOLID_BBOX)
	--local phys = self.Entity:GetPhysicsObject()
	--if phys and phys:IsValid() then phys:Wake() end
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:AttackPlayer()
	self.Attacks = self.Attacks + 1
	for i, v in ipairs(self.CurrentTargets) do
		if v[1]:IsPlayer() and (v[1]:Alive() == false or v[1]:GTeam() == TEAM_SPECTATOR or v[1]:GTeam() == TEAM_SCP or self:IsPlayerVisible(v[1], self:GetPos()) == false) then
			table.RemoveByValue(self.CurrentTargets, v)
		else
			self.CurrentTargets[i] = {v[1], v[1]:GetPos():Distance(self:GetPos())}
		end
	end

	if self.CurrentTargets[1] and self.CurrentTargets[1][1]:IsPlayer() then
		local pl = self.CurrentTargets[1][1]
		if self:CanMove(pl:GetPos() - pl:EyeAngles():Forward() * 10) == false then return end
		self:SetAngles(Angle(0, pl:EyeAngles().y, 0))
		self:SetPos(pl:GetPos() - pl:EyeAngles():Forward() * 10)
		pl:TakeDamage(5000, self.Owner, self.Entity)
		roundstats.snapped = roundstats.snapped + 1
		pl:EmitSound(self.SnapSound, 75, 100, 1)
		self.Owner:SetPos(self:GetPos())
	else
		self.Attacks = 10
	end
	--PrintTable(self.CurrentTargets)
end

function ENT:IsPlayerLooking(ply)
	local yes = ply:GetAimVector():Dot((self:GetPos() - ply:GetPos() + Vector(70)):GetNormalized())
	return yes > 0.39
end

function ENT:IsPlayerVisible(ply, fromPos)
	local ent173_ang = self:GetAngles()
	local pl_pos = ply:GetPos()
	local pl_posc = ply:WorldSpaceCenter()
	local tr_up = util.TraceLine({
		start = Vector(fromPos.x, fromPos.y, fromPos.z + 45),
		endpos = Vector(pl_posc.x, pl_posc.y, pl_posc.z + 30),
		filter = {self, self.Owner}
	})

	local tr_down = util.TraceLine({
		start = Vector(fromPos.x, fromPos.y, fromPos.z - 45),
		endpos = Vector(pl_pos.x, pl_pos.y, pl_pos.z + 10),
		filter = {self, self.Owner}
	})

	local tr_center1 = util.TraceLine({
		start = fromPos + ent173_ang:Right() * 25,
		endpos = pl_posc,
		filter = {self, self.Owner}
	})

	local tr_center2 = util.TraceLine({
		start = fromPos - ent173_ang:Right() * 25,
		endpos = pl_posc,
		filter = {self, self.Owner}
	})

	--print(ply:Nick())
	--print("tr_up: " .. tostring(tr_up.Entity))
	--print("tr_down: " .. tostring(tr_down.Entity))
	--print("tr_center1: " .. tostring(tr_center1.Entity))
	--print("tr_center2: " .. tostring(tr_center2.Entity))
	if tr_up.Entity == ply then return true end
	if tr_down.Entity == ply then return true end
	if tr_center1.Entity == ply then return true end
	if tr_center2.Entity == ply then return true end
	return false
end

function ENT:CanMove(pos)
	local cpos = nil
	if pos == self:GetPos() then
		cpos = self:WorldSpaceCenter()
	else
		cpos = pos
	end

	for k, v in pairs(ents.FindInSphere(pos, 1100)) do
		--print("VisibleVec: " .. tostring(v:VisibleVec( pos )))
		if v:IsPlayer() and v:Alive() and v:GTeam() ~= TEAM_SPECTATOR and v:GTeam() ~= TEAM_SCP and self:IsPlayerVisible(v, cpos) and (v.isblinking == false and v.nextBlinkCheck < CurTime()) then --and v:VisibleVec( pos )
			print(v:Nick() .. " is looking - " .. CurTime())
			return false
		end
	end
	return true
end

function ENT:StopAttacking()
	self.IsAttacking = false
	self:SetNWBool("IsAttacking", false)
	self:NextThink(CurTime() + 3)
	print("attacking has ended")
end

function ENT:TryToMoveTo(pos, ang)
	if self:CanMove(self:GetPos()) == true then
		self:SetPos(pos)
		if ang ~= nil then self:SetAngles(ang) end
		self:EmitSound("173sound" .. math.random(1, 3) .. ".ogg", 300, 100, 1)
	end
end

ENT.Tries = 0
function ENT:Think()
	if SERVER then
		--[[
		if self.Entity:IsOnGround() == false then
			local tr = util.TraceLine( {
				start = self.Entity:GetPos(),
				endpos = self.Entity:GetPos() + Angle(90,0,0):Forward() * 1000,
				filter = self
			} )
			self:SetPos(tr.HitPos)
		end
		]]
		--[[
		if self.IsAttacking then
			if self:CanMove(self:GetPos()) then
				self:AttackPlayer()
				if self.Attacks > 1 then
					self:StopAttacking()
					return
				end
			end
			print("waiting... " .. self.Tries)
			self.Tries = self.Tries + 1
			if self.Tries > 20 then
				self:StopAttacking()
			end
			self:NextThink( CurTime() + 0.2 )
		else
			self:NextThink( CurTime() + 3 )
		end
		]]
	end
end

function ENT:AttackNearbyPlayers()
	print("attacking...")
	self.IsAttacking = false
	self:SetNWBool("IsAttacking", false)
	self.CurrentTargets = {}
	self.Attacks = 0
	self.Tries = 0
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 400)) do
		if v:IsPlayer() and v:Alive() and v:GTeam() ~= TEAM_SPECTATOR and v:GTeam() ~= TEAM_SCP and self:IsPlayerVisible(v, self:WorldSpaceCenter()) then
			table.ForceInsert(self.CurrentTargets, {v, 0})
			self.IsAttacking = true
			self:SetNWBool("IsAttacking", true)
		end
	end
	--if self.IsAttacking == true then
	--	self:AttackPlayer()
	--end
end