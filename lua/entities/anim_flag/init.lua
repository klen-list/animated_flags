-- Animated Flags Remake by Wild Russain x Klen_list

AddCSLuaFile("shared.lua")
include("shared.lua")

if CreateConVar(
		"animflag_forceload",
		"1",
		FCVAR_SERVER_CAN_EXECUTE + FCVAR_ARCHIVE,
		"Enable/Disable force workshop addon loading."
	):GetBool()
then
	resource.AddWorkshop( "2160259648")
end

function ENT:Initialize()
	self:SetModel"models/anim_flag_rework/anim_flag_rework.mdl"
	if GetGlobalInt"animflag_skincount" > 0 then
		self:SetSubMaterial(0, GetGlobalString"animflag_skin1")
	end
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysWake()
	self:ResetSequence(0, false)
end

---@param cdmg CTakeDamageInfo
function ENT:OnTakeDamage(cdmg)
	self:TakePhysicsDamage(cdmg)
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end