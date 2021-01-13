-- Created ByPoLaT
-- Remake Wild Russain x Klen_list

AddCSLuaFile"shared.lua"
include"shared.lua"

local function FlagFunctionalAutoInit(ent)
	timer.Simple(.1, function()
		if  IsValid(ent) and
			ent:GetClass() == "anim_flag" and
			ent:GetModel() == "models/anim_flags/anim_flag.mdl"
		then
			local anim_ent = ents.Create"prop_dynamic"
			anim_ent:SetModel"models/anim_flags/anim_flag.mdl"
			anim_ent:SetPos(ent:GetPos())
			anim_ent:SetAngles(ent:GetAngles())
			anim_ent:Fire("setanimation", "Idle", .1)
			anim_ent:SetParent(ent)
			ent._animflagpart = anim_ent
			ent:AddEffects(EF_NODRAW)
		end
	end)
end
hook.Add("OnEntityCreated", "FlagFunctionalAutoInit", FlagFunctionalAutoInit)

function ENT:Initialize()
	self:SetModel"models/anim_flags/anim_flag.mdl"
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysWake()
end

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	local ang = ply:EyeAngles()
	ang.p = 0
	ang.y = ang.y + 180

	local ent = ents.Create"anim_flag"
	ent:SetPos(tr.HitPos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Think()
	if IsValid(self._animflagpart) then
		self._animflagpart:SetSkin(self:GetSkin())
	end
end