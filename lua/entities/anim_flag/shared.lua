-- Created ByPoLaT
-- Remake Wild Russain x Klen_list

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
			if name:sub(i,i) == "^" then toup = true continue end
			if toup then out = out .. name:sub(i,i):upper() toup = false continue end
			out = out .. name:sub(i,i)
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

		ent:SetSubMaterial(0, GetGlobalString("animflag_skin" .. (_skin < GetGlobalInt"animflag_skincount" and _skin or GetGlobalInt"animflag_skincount")))
	end
})