AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/ceiling_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.HasDeathRagdoll = false
ENT.StartHealth = 250
ENT.SightDistance = 2200 -- How far it can see
ENT.PoseParameterLooking_TurningSpeed = 25
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 0), Vector(-13, -13, -40))
	self:SetPos(self:GetPos() +Vector(0,0,32))
	self.RangeDistance = self.SightDistance
	self.RangeAttackAngleRadius = 180
	self.SightAngle = 90
	self.Turret_AlarmTimes = 0
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/