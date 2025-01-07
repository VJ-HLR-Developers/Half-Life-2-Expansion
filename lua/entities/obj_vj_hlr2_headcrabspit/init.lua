AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_base/projectiles/spit_acid_small.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true -- Should it deal radius damage when it collides with something?
ENT.RadiusDamageRadius = 40
ENT.RadiusDamage = 0
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the hit entity is from the radius origin?
ENT.RadiusDamageType = DMG_POISON
ENT.CollisionDecal = "BeerSplash"
ENT.SoundTbl_Startup = "weapons/crossbow/bolt_fly4.wav"
ENT.SoundTbl_OnCollide = "physics/body/body_medium_break4.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("vj_acid_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	sound.EmitHint(SOUND_DANGER, self:GetPos() +self:GetVelocity(), self.RadiusDamageRadius, 1, self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDealDamage(data, phys, hitEnts)
	if hitEnts then
		for _,v in pairs(hitEnts) do
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(v:Health() -1)
			dmginfo:SetDamageType(DMG_POISON)
			dmginfo:SetDamagePosition(v:GetPos() +v:OBBCenter())
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
			v:TakeDamageInfo(dmginfo)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	ParticleEffect("vj_blood_impact_yellow",data.HitPos,Angle(0,0,0))
	local tr = util.TraceLine({
		start = data.HitPos,
		endpos = data.HitPos -Vector(0,0,30),
		filter = self,
		mask = CONTENTS_SOLID
	})
	if tr.HitWorld && (tr.HitNormal == Vector(0.0,0.0,1.0)) then // (tr.Fraction <= 0.405)
		ParticleEffect("vj_blood_pool_yellow_tiny",tr.HitPos,Angle(0,0,0))
	end
end