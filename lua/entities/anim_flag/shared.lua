-- Created ByPoLaT
-- Remake Wild Russain x Klen_list

ENT.Base = "base_anim"

ENT.PrintName = "Animated Flag"
ENT.Category = "Animated Flags"

ENT.Spawnable = true

ENT.AutomaticFrameAdvance = true

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("anim_flag", "Animated Flag")
	
	ENT.Skins = {
		"USA",
		"Bombass",
		"Deutschland Reich",
		"United Kingdom",
		"Error",
		"Germany (1WW)",
		"Gmod",
		"LGBT",
		"Russian Federation",
		"SCP Foundation",
		"Steam",
		"Ukraine",
		"USSR",
		"Airborne Forces RF"
	}
	
	if GetConVar"cl_language":GetString() == "russian" or GetConVar"gmod_language":GetString() == "ru" then
		language.Add("flagchangeskin", "Скин флага")
	else
		language.Add("flagchangeskin", "Flag skin")
	end
end

hook.Add("CanProperty", "AnimFlagsNoDefaultSkinProperty", function(ply, property, ent)
	if (IsValid(ent) and ent:GetClass() == "anim_flag") and property == "skin" then return false end
end)

properties.Add("flagchangeskin", {
	MenuLabel = "#flagchangeskin",
	Order = 999,
	MenuIcon = "icon16/photos.png",

	Filter = function(self, ent, ply)
		if not (IsValid(ent) and ent:GetClass() == "anim_flag") then return false end
		if not gamemode.Call("CanProperty", ply, "flagchangeskin", ent) then return false end

		return true
	end,
	Action = function(self, ent)
		-- Using SetSkin instead
	end,
	MenuOpen = function(self, option, ent, tr)
		local submenu = option:AddSubMenu()
		for i,skin in ipairs(ent.Skins) do
			local option = submenu:AddOption(skin, function() self:SetSkin(ent, i - 1) end)
			if ent:GetSkin() == i - 1 then option:SetChecked(true) end
		end
	end,
	SetSkin = function(self, ent, id)
		self:MsgStart()
			net.WriteEntity(ent)
			net.WriteUInt(id, 8)
		self:MsgEnd()
	end,
	Receive = function(self, l, ply)
		local ent = net.ReadEntity()

		if not properties.CanBeTargeted(ent, ply) then return end
		if not self:Filter(ent, ply) then return end
		
		local skin = net.ReadUInt(8)

		ent:SetSkin(skin < 0 and 0 or skin > 13 and 13 or skin)
	end 
})