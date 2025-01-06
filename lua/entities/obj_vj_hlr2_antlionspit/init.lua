AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/spitball_small.mdl", "models/spitball_medium.mdl", "models/spitball_medium.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true -- Should it deal radius damage when it collides with something?
ENT.RadiusDamageRadius = 40
ENT.RadiusDamage = 20
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the hit entity is from the radius origin?
ENT.RadiusDamageType = DMG_ACID
ENT.CollisionDecals = "BeerSplash"
ENT.SoundTbl_Idle = "vj_base/ambience/acid_idle.wav"
ENT.SoundTbl_OnCollide = "vj_base/ambience/acid_splat.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("vj_acid_idle",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffect("vj_acid_impact1",self:GetPos(),Angle(0,0,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	sound.EmitHint(SOUND_DANGER, self:GetPos() +self:GetVelocity(), self.RadiusDamageRadius, 1, self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	ParticleEffect("vj_acid_impact1",data.HitPos,Angle(0,0,0))
	ParticleEffect("vj_acid_impact2",data.HitPos,Angle(0,0,0))
end