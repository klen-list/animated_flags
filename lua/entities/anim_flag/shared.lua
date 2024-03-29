-- Animated Flags Remake by Wild Russain x Klen_list

ENT.Base = "base_anim"
ENT.PrintName = "Animated Flag"
ENT.Category = "Animated Flags"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true

if CLIENT then
	if GetConVar"cl_language":GetString() == "russian" or GetConVar"gmod_language":GetString() == "ru" then
		language.Add("flagchangeskin", "Скин флага")
	else
		language.Add("flagchangeskin", "Flag skin")
	end
	language.Add("anim_flag", "Animated Flag")
end

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

hook.Add("ShutDown", "AnimFlagClearDataTemp", function()
	MsgN"[Animated Flags] Clearing vmt cache..."
	for i,matfile in ipairs(file.Find("animflag_loadtemp/*.vmt", "DATA")) do
		file.Delete("animflag_loadtemp/" .. matfile)
	end
	file.Delete"animflag_loadtemp"
end)

properties.Add("flagchangeskin", {
	MenuLabel = "#flagchangeskin",
	Order = 999,
	MenuIcon = "icon16/photos.png",
	Filter = function(self, ent, ply)
		if not (IsValid(ent) and ent:GetClass() == "anim_flag") then return false end
		if GetGlobalInt"animflag_skincount" <= 0 then return false end
		if not gamemode.Call("CanProperty", ply, "flagchangeskin", ent) then return false end

		return true
	end,
	ParseName = function(self, skinidx)
		local name = string.Replace(string.GetFileFromFilename(GetGlobalString("animflag_skin" .. skinidx)), "_", " ")

		local toup, out = true, ""
		for i = 1,#name do
			if name:sub(i, i) == "^" then toup = true continue end
			if toup then out = out .. name:sub(i, i):upper() toup = false continue end
			out = out .. name:sub(i, i)
		end

		return out
	end,
	MenuOpen = function(self, option, ent)
		local submenu = option:AddSubMenu()
		for i = 1,GetGlobalInt"animflag_skincount" do
			option = submenu:AddOption(self:ParseName(i), function() self:SendSkin(ent, i) end)
			if ent:GetSubMaterial(0) == GetGlobalString("animflag_skin" .. i) then option:SetChecked(true) end
		end
	end,
	Action = function()
		-- Nothing, using SendSkin instead
	end,
	SendSkin = function(self, ent, id)
		self:MsgStart()
			net.WriteEntity(ent)
			net.WriteUInt(id, 8) -- 8 bit = 255 skins, u cant reach this
		self:MsgEnd()
	end,
	Receive = function(self, l, ply)
		local ent = net.ReadEntity()

		if not properties.CanBeTargeted(ent, ply) then return end
		if not self:Filter(ent, ply) then return end

		local _skin = net.ReadUInt(8)

		if _skin > GetGlobalInt"animflag_skincount" then
			ply:ChatPrint"[Animated Flags] This flag does not exist on the server!"
			return
		end

		ent:SetSubMaterial(0, GetGlobalString("animflag_skin" .. _skin))
	end
})