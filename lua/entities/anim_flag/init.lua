-- Created ByPoLaT
-- Remake Wild Russain x Klen_list

AddCSLuaFile"shared.lua"
include"shared.lua"

do
	local skinc, mat = 0
	MsgN"[Animated Flags] Starting material loading..."
	file.CreateDir"animflag_loadtemp"
	for i,matfile in ipairs(file.Find("materials/models/anim_flag_skins/*.vtf", "GAME")) do
		if matfile == "flag_structure.vtf" then continue end -- model material, not flag
		matfile = matfile:sub(1, #matfile - 4)

		file.Write("animflag_loadtemp/" .. matfile .. ".vmt", Format("vertexlitgeneric{$basetexture \"models/anim_flag_skins/%s\"}", matfile))
		mat = Material("../data/animflag_loadtemp/" .. matfile)

		if mat:IsError() then
			MsgN("[Animated Flags] Refused from loading error material `" .. matfile .. "`!")
			continue
		end

		skinc = skinc + 1
		SetGlobalString("animflag_skin" .. skinc, mat:GetName())

		MsgN("[Animated Flags] Created material for `", matfile, "`...")
	end
	SetGlobalInt("animflag_skincount", skinc)
end

hook.Add("ShutDown", "AnimFlagClearDataTemp", function()
	MsgN"[Animated Flags] Clearing vmt cache..."
	for i,matfile in ipairs(file.Find("animflag_loadtemp/*.vmt", "DATA")) do
		file.Delete("animflag_loadtemp/" .. matfile)
	end
	file.Delete"animflag_loadtemp"
end)

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

function ENT:Think()
	self:NextThink(CurTime())
	return true
end