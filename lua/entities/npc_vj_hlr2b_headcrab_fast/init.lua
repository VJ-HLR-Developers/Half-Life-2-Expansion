AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
function ENT:Init()
	self:SetCollisionBounds(Vector(12,12,15), Vector(-12,-12,0))
	self:SetMaterial("models/hl_resurgence/hl2b/headcrab_fast/allinonebacup2")
end