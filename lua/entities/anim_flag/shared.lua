-- Animated Flags Remake by Wild Russain x Klen_list

ENT.Base = "base_anim"
ENT.PrintName = "Animated Flag"
ENT.Category = "Animated Flags"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true
ENT.PhysicsSounds = true

if CLIENT then
	if GetConVar("cl_language"):GetString() == "russian" or GetConVar("gmod_language"):GetString() == "ru" then
		language.Add("flagchangeskin", "Скин флага")
	else
		language.Add("flagchangeskin", "Flag skin")
	end

	language.Add("anim_flag", "Animated Flag")
end

do
	local skinc = 0
	---@type IMaterial
	local mat

	MsgN("[Animated Flags] Starting material loading...")
	file.CreateDir("animflag_loadtemp")

	---@param matfile string
	for i, matfile in ipairs(file.Find("materials/models/anim_flag_skins/*.vtf", "GAME")) do
		if matfile == "flag_structure.vtf" then continue end -- model material is not a flag
		matfile = matfile:sub(1, -5)

		file.Write(
			"animflag_loadtemp/" .. matfile .. ".vmt",
			Format("vertexlitgeneric{$basetexture \"models/anim_flag_skins/%s\"}", matfile)
		)

		mat = Material("../data/animflag_loadtemp/" .. matfile)
		if mat:IsError() then
			MsgN("[Animated Flags] Refused from loading error material `", matfile, "`!")
			continue
		end

		skinc = skinc + 1
		if SERVER then SetGlobalString("animflag_skin" .. skinc, mat:GetName()) end

		MsgN("[Animated Flags] Created material for `", matfile, "`...")
	end
	if SERVER then SetGlobalInt("animflag_skincount", skinc) end
	MsgN("[Animated Flags] Totally loaded ", skinc, " flags.")
end

---@return nil
hook.Add("ShutDown", "AnimatedFlags.ClearCacheVMT", function()
	MsgN("[Animated Flags] Clearing VMT cache...")

	---@param matfile string
	for i, matfile in ipairs(file.Find("animflag_loadtemp/*.vmt", "DATA")) do
		file.Delete("animflag_loadtemp/" .. matfile)
	end

	file.Delete("animflag_loadtemp")
end)

do
	---@class PropertyData
	---@field MsgStart function
	---@field MsgEnd function

	---@class SetFlagProperty : PropertyData
	local propData = {}

	propData.MenuLabel = "#flagchangeskin"
	propData.Order = 999
	propData.MenuIcon = "icon16/photos.png"

	---@param ent Entity
	---@param ply Player
	---@return boolean
	function propData:Filter(ent, ply)
		if not (IsValid(ent) and ent:GetClass() == "anim_flag") then return false end
		if GetGlobalInt("animflag_skincount") <= 0 then return false end
		if not gamemode.Call("CanProperty", ply, "flagchangeskin", ent) then return false end

		return true
	end

	---@param skinIdx number
	---@return string
	function propData:ParseName(skinIdx)
		local rawName = string.Replace(
			string.GetFileFromFilename(
				GetGlobalString("animflag_skin" .. skinIdx)
			), "_", " "
		)

		local nextUpperCase, outName = true, ""
		for i = 1, #rawName do
			local symbol = rawName:sub(i, i)

			if symbol == "^" then
				nextUpperCase = true
				continue
			end

			if nextUpperCase then
				symbol = symbol:upper()
				nextUpperCase = false
			end

			outName = outName .. symbol
		end

		return outName
	end

	---@param option DMenuOption
	---@param ent Entity
	function propData:MenuOpen(option, ent)
		local submenu = option:AddSubMenu()
		---@cast submenu DMenu

		for i = 1, GetGlobalInt("animflag_skincount") do
			option = submenu:AddOption(self:ParseName(i), function() self:SendSkin(ent, i) end)
			if ent:GetSubMaterial(0) == GetGlobalString("animflag_skin" .. i) then option:SetChecked(true) end
		end
	end

	---Nothing, using SendSkin instead
	function propData:Action()
	end

	---@param ent Entity
	---@param id integer
	function propData:SendSkin(ent, id)
		self:MsgStart()
			net.WriteEntity(ent)
			net.WriteUInt(id, 32)
		self:MsgEnd()
	end

	---@param ply Player
	function propData:Receive(_, ply)
		local ent = net.ReadEntity()

		if not properties.CanBeTargeted(ent, ply) then return end
		if not self:Filter(ent, ply) then return end

		local skin = net.ReadUInt(32)

		if skin > GetGlobalInt("animflag_skincount") then
			ply:ChatPrint("[Animated Flags] This flag does not exist on the server!")
			return
		end

		ent:SetSubMaterial(0, GetGlobalString("animflag_skin" .. skin))
	end

	properties.Add("flagchangeskin", propData)
end