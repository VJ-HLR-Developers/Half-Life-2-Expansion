AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/headcrab.mdl"}

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "HCFast.Chest", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 2), -- The offset for the controller when the camera is in first person
}

ENT.FootStepTimeRun = 0.1
ENT.FootStepTimeWalk = 0.1

ENT.GeneralSoundPitch1 = 120
ENT.GeneralSoundPitch2 = 120
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(12,12,15), Vector(-12,-12,0))
end