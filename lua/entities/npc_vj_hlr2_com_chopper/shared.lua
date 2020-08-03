ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= ""
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingLeft()
	return self:GetDirections().LR < 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingRight()
	return self:GetDirections().LR > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingForward()
	return self:GetDirections().FB > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingBackward()
	return self:GetDirections().FB < 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingUp()
	return self:GetDirections().UD > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingDown()
	return self:GetDirections().UD < 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetDirections()
	local vel = self:GetAbsVelocity()
	return {LR=math.Clamp(vel.x,-1,1),FB=math.Clamp(vel.y,-1,1),UD=math.Clamp(vel.z,-1,1)}
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local mat = Material("sprites/light_glow02_add")
	local matB = Material("sprites/light_glow01")
	function ENT:CustomOnDraw()
		local size = 70
		local sizeB = 70
		for i = 9,11 do
			render.SetMaterial(mat)
			render.DrawSprite(self:GetAttachment(i).Pos,math.random(size -8,size +8),math.random(size -8,size +8),Color(255,0,0,255))
		end
		-- render.SetMaterial(matB)
		-- render.DrawSprite(self:GetAttachment(12).Pos,math.random(sizeB -2,sizeB +2),math.random(sizeB -2,sizeB +2),Color(255,0,0,255))
	end

	function ENT:Think()
		local left = self:MovingLeft()
		local right = self:MovingRight()
		local forward = self:MovingForward()
		local backward = self:MovingBackward()
		local up = self:MovingUp()
		local down = self:MovingDown()

		-- self:SetAngles(self:GetAngles() +Angle(self:MovingUp() && 3 or self:MovingDown() && -3,0,0))
		-- self:SetAngles(self:GetAngles() +Angle(self:GetDirections().LR *10,self:GetDirections().FB *10,self:GetDirections().UD *10))
	end
end