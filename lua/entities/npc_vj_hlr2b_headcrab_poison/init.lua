AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.BloodColor = "Yellow"	
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
function ENT:CustomOnInitialize()
	self:SetModel("models/vj_hlr/hl2b/headcrab_poison.mdl")
	self:SetCollisionBounds(Vector(14,14,15), Vector(-14,-14,0))
	self.CustomRunActivites = {VJ_SequenceToActivity(self,"Scurry")}
end