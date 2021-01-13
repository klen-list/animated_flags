-- Created ByPoLaT
-- Remake Wild Russain x Klen_list

ENT.Base 			= "base_anim"

ENT.PrintName		= "Animated Flag"
ENT.Category 		= "Animated Flags"

ENT.Spawnable		= true

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("anim_flag", "Animated Flag")
end