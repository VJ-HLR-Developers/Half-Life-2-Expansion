ENT.Base 			= "npc_vj_hlr2_com_chopper"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= ""
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	ENT.Rotor = 0
	function ENT:CustomOnDraw()
		self.Rotor = self.Rotor +1
		self:ManipulateBoneAngles(19,Angle(self.Rotor,0,0))
	end
end