-- Created ByPoLaT
-- Remake Wild Russain x Klen_list

AddCSLuaFile"shared.lua"
include"shared.lua"

function ENT:Initialize()
	self:SetModel"models/anim_flags/anim_flag.mdl"
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysWake()
	self:ResetSequence(0, false)
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end