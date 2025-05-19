AddCSLuaFile()

ENT.PrintName		= "Breach Gate"
ENT.Author		    = "Kanade"
ENT.Type			= "anim"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.RenderGroup 	= RENDERGROUP_OPAQUE
ENT.Model			= "models/foundation/containment/door01.mdl"

function ENT:Initialize()
	//self.Entity:SetModel(self.Model)
	self.Entity:PhysicsInit(SOLID_BBOX)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_BBOX)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
end
