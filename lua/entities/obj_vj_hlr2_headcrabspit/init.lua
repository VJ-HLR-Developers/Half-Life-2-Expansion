AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/spitball_small.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 40 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 0 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_POISON -- Damage type
ENT.DecalTbl_DeathDecals = {"BeerSplash"}
ENT.SoundTbl_Startup = {"weapons/crossbow/bolt_fly4.wav"}
ENT.SoundTbl_OnCollide = {"physics/body/body_medium_break4.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	ParticleEffectAttach("antlion_spit_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data, phys, hitEnt)
	for _,v in pairs(hitEnt) do
		if v:IsNPC() or v:IsPlayer() then
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
function ENT:DeathEffects(data, phys)
	ParticleEffect("vj_impact1_yellow",data.HitPos,Angle(0,0,0),nil)
	local tr = util.TraceLine({
		start = data.HitPos,
		endpos = data.HitPos -Vector(0,0,30),
		filter = self,
		mask = CONTENTS_SOLID
	})
	if tr.HitWorld && (tr.HitNormal == Vector(0.0,0.0,1.0)) then // (tr.Fraction <= 0.405)
		ParticleEffect("vj_bleedout_yellow_tiny",tr.HitPos,Angle(0,0,0),nil)
	end
end