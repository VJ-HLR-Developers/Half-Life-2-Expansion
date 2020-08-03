AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/items/combine_rifle_ammo01.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 200 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 40 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_DISSOLVE -- Damage type
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"ambient/energy/force_field_loop1.wav"}
ENT.SoundTbl_OnCollide = {"npc/scanner/cbot_energyexplosion1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	self:SetNoDraw(true)
	self:DrawShadow(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	ParticleEffectAttach("electrical_arc_01_system",PATTACH_POINT_FOLLOW,self,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- ParticleEffectAttach("electrical_arc_01_system",PATTACH_POINT_FOLLOW,self,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data,phys,hitent)
	for _,v in pairs(hitent) do
		v:EmitSound("ambient/energy/weld"..math.random(1,2)..".wav",60,100)
		if IsValid(v) then
			local zapEnt = v
			timer.Create("VJ_HLR2_ZapEffect"..self:EntIndex()..tostring(zapEnt),0.2,15,function()
				if IsValid(zapEnt) then
					local effect = EffectData()
					effect:SetOrigin(zapEnt:GetPos())
					effect:SetStart(zapEnt:GetPos())
					effect:SetMagnitude(5)
					effect:SetEntity(zapEnt)
					util.Effect("teslaHitBoxes",effect)
					zapEnt:EmitSound("Weapon_StunStick.Activate")
				end
			end)
			if v:IsPlayer() && IsValid(v:GetActiveWeapon()) then
				local wep = v:GetActiveWeapon()
				v:DropWeapon(wep)
				local zapWep = wep
				timer.Create("VJ_HLR2_ZapEffect_PWep"..self:EntIndex()..tostring(zapWep),0.2,15,function()
					if IsValid(zapWep) then
						local effect = EffectData()
						effect:SetOrigin(zapWep:GetPos())
						effect:SetStart(zapWep:GetPos())
						effect:SetMagnitude(5)
						effect:SetEntity(zapWep)
						util.Effect("teslaHitBoxes",effect)
						zapWep:EmitSound("Weapon_StunStick.Activate")
					end
				end)
			elseif v:IsNPC() && v.IsVJBaseSNPC && IsValid(v:GetActiveWeapon()) && math.random(1,3) == 1 then
				local class = v:GetActiveWeapon():GetClass()
				local ent = ents.Create(class)
				ent:SetPos(v:GetActiveWeapon():GetPos())
				ent:SetAngles(v:GetActiveWeapon():GetAngles())
				ent:Spawn()
				if IsValid(ent:GetPhysicsObject()) then
					ent:GetPhysicsObject():SetVelocity(ent:GetPos() +VectorRand() *20)
				end
				v:GetActiveWeapon():Remove()
				local zapNWep = ent
				timer.Create("VJ_HLR2_ZapEffect_NWep"..self:EntIndex()..tostring(zapNWep),0.2,15,function()
					if IsValid(zapNWep) then
						local effect = EffectData()
						effect:SetOrigin(zapNWep:GetPos())
						effect:SetStart(zapNWep:GetPos())
						effect:SetMagnitude(5)
						effect:SetEntity(zapNWep)
						util.Effect("teslaHitBoxes",effect)
						zapNWep:EmitSound("Weapon_StunStick.Activate")
					end
				end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	for i = 1,5 do
		ParticleEffect("aurora_shockwave",self:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("electrical_arc_01_system",self:GetPos(),Angle(0,0,0),nil)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/