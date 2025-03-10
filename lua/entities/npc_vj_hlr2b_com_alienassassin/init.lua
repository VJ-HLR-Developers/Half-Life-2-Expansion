AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/alien_assassin.mdl"
ENT.StartHealth = 70
ENT.HullType = HULL_HUMAN
ENT.JumpParams = {
	MaxRise = 620,
	MaxDrop = 620,
	MaxDistance = 620
}

ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.BloodColor = VJ.BLOOD_COLOR_GREEN

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 85
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackBleedEnemyChance = 1
ENT.MeleeAttackBleedEnemyReps = 10
ENT.MeleeAttackPlayerSpeedTime = 5

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1,"tripwire","pests"}
ENT.RangeAttackAnimationFaceEnemy = false
ENT.RangeAttackMaxDistance = 1750
ENT.RangeAttackMinDistance = 350
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(5, 9)

ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true
ENT.MainSoundPitch = 140

ENT.SoundTbl_FootStep = {
	"npc/fast_zombie/foot1.wav",
	"npc/fast_zombie/foot2.wav",
	"npc/fast_zombie/foot3.wav",
	"npc/fast_zombie/foot4.wav",
}
ENT.SoundTbl_Idle = {
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_01.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_02.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_03.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_04.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_05.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_06.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_07.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_08.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_09.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_10.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_11.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_12.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/src/npc/alienassassin/vox_abandon_gurgle_01.wav",
	"vj_hlr/src/npc/alienassassin/vox_abandon_gurgle_02.wav",
	"vj_hlr/src/npc/alienassassin/vox_abandon_gurgle_03.wav",
}
ENT.SoundTbl_BeforeRangeAttack = {
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_01.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_02.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_03.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_04.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_05.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_06.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_07.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_08.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_09.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_10.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_11.wav",
	"vj_hlr/src/npc/alienassassin/vox_grunt_misc_12.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/src/npc/alienassassin/vox_abandon_grunt_01.wav",
	"vj_hlr/src/npc/alienassassin/vox_abandon_grunt_02.wav",
	"vj_hlr/src/npc/alienassassin/vox_abandon_grunt_03.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/src/npc/alienassassin/vox_shockwave_yell_01.wav",
	"vj_hlr/src/npc/alienassassin/vox_shockwave_yell_02.wav",
	"vj_hlr/src/npc/alienassassin/vox_shockwave_yell_03.wav",
	"vj_hlr/src/npc/alienassassin/vox_shockwave_yell_04.wav",
	"vj_hlr/src/npc/alienassassin/vox_shockwave_yell_05.wav",
}
--
local projKnife = "models/vj_hlr/weapons/w_knife.mdl" -- Temporary ("models/vj_hlr/hl2b/weapons/css_knife.mdl")
local projPest = "models/weapons/w_bugbait.mdl"
local projHopwire = "models/weapons/w_grenade.mdl" -- Temporary ("models/vj_hlr/hl2b/weapons/tripmine.mdl")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	for i = 1,2 do
		util.SpriteTrail(self,i +3,Color(4,255,0),true,4,1,0.35,1 /(25 +1) *0.5,"VJ_Base/sprites/trail.vmt")
		local spriteGlow = ents.Create("env_sprite")
		spriteGlow:SetKeyValue("rendercolor","4 255 0")
		spriteGlow:SetKeyValue("GlowProxySize","2.0")
		spriteGlow:SetKeyValue("HDRColorScale","1.0")
		spriteGlow:SetKeyValue("renderfx","14")
		spriteGlow:SetKeyValue("rendermode","3")
		spriteGlow:SetKeyValue("renderamt","255")
		spriteGlow:SetKeyValue("disablereceiveshadows","0")
		spriteGlow:SetKeyValue("mindxlevel","0")
		spriteGlow:SetKeyValue("maxdxlevel","0")
		spriteGlow:SetKeyValue("framerate","10.0")
		spriteGlow:SetKeyValue("model","VJ_Base/sprites/glow.vmt")
		spriteGlow:SetKeyValue("spawnflags","0")
		spriteGlow:SetKeyValue("scale","0.075")
		spriteGlow:SetParent(self)
		spriteGlow:Fire("SetParentAttachment", "light" .. i)
		spriteGlow:Spawn()
		self:DeleteOnRemove(spriteGlow)
	end

	self.NextJumpAwayT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(atkType, ent)
	if !atkType then
		if !self:IsBusy() && self.EnemyData.Visible && self.EnemyData.DistanceNearest <= 100 && CurTime() > self.NextJumpAwayT then
			self:VJ_ACT_PLAYACTIVITY("jumpbackt", true, false, true)
			self.NextJumpAwayT = CurTime() + math.Rand(2.5,7.5)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	-- print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "attack" then
		self:ExecuteMeleeAttack()
	elseif key == "draw_knife" then
		SafeRemoveEntity(self.HoldObject)
		local att = self:GetAttachment(self:LookupAttachment("rhand"))
		local prop = ents.Create("prop_physics")
		prop:SetModel(projKnife)
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:SetParent(self)
		prop:Spawn()
		prop:Activate()
		prop:SetOwner(self)
		prop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		prop:Fire("SetParentAttachment", "rhand")
		self:DeleteOnRemove(prop)
		self.HoldObject = prop
	elseif key == "draw_tripwire" then
		SafeRemoveEntity(self.HoldObject)
		local att = self:GetAttachment(self:LookupAttachment("rhand"))
		local prop = ents.Create("prop_physics")
		prop:SetModel(projHopwire)
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:SetParent(self)
		prop:Spawn()
		prop:Activate()
		prop:SetOwner(self)
		prop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		prop:Fire("SetParentAttachment", "rhand")
		self:DeleteOnRemove(prop)
		self.HoldObject = prop
	elseif key == "draw_pests" then
		SafeRemoveEntity(self.HoldObject)
		local att = self:GetAttachment(self:LookupAttachment("rhand"))
		local prop = ents.Create("prop_physics")
		prop:SetModel(projPest)
		prop:SetPos(att.Pos)
		prop:SetAngles(att.Ang)
		prop:SetParent(self)
		prop:Spawn()
		prop:Activate()
		prop:SetOwner(self)
		prop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		prop:Fire("SetParentAttachment", "rhand")
		self:DeleteOnRemove(prop)
		self.HoldObject = prop
	elseif key == "attack_knife" then
		SafeRemoveEntity(self.HoldObject)
		local ent = self:GetEnemy()
		local targetPos = IsValid(ent) && ent:GetPos() +ent:OBBCenter() or self:GetPos() +self:OBBCenter() +self:GetForward() *1000
		local att = self:GetAttachment(self:LookupAttachment("rhand"))
		local proj = ents.Create("obj_vj_projectile_base")
		proj:SetModel(projKnife)
		proj:SetPos(att.Pos)
		proj:SetAngles((targetPos -proj:GetPos()):Angle() +Angle(-90,0,0))
		proj:SetOwner(self)
		proj:SetNoDraw(false)
		proj:DrawShadow(true)
		proj.DoesDirectDamage = true
		proj.DirectDamage = 25
		proj.DirectDamageType = DMG_SLASH
		proj:Spawn()
		proj:Activate()

		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self,ent,"Line",proj:GetPos(),IsValid(ent) && 0.75 or targetPos,4000))
		end
	elseif key == "attack_tripwire" then
		SafeRemoveEntity(self.HoldObject)
		local ent = self:GetEnemy()
		local targetPos = IsValid(ent) && ent:GetPos() +ent:OBBCenter() or self:GetPos() +self:OBBCenter() +self:GetForward() *1000
		local att = self:GetAttachment(self:LookupAttachment("rhand"))
		local proj = ents.Create("obj_vj_projectile_base")
		proj:SetModel(projHopwire)
		proj:SetPos(att.Pos)
		proj:SetAngles((targetPos -proj:GetPos()):Angle() +Angle(-90,0,0))
		proj:SetOwner(self)
		proj:SetNoDraw(false)
		proj:DrawShadow(true)
		proj.ProjectileType = VJ.PROJ_TYPE_PROP
		proj.DoesRadiusDamage = true
		proj.RadiusDamageRadius = 250
		proj.RadiusDamage = 80
		proj.RadiusDamageUseRealisticRadius = true
		proj.RadiusDamageType = bit.bor(DMG_BLAST,DMG_SHOCK)
		proj.RadiusDamageForce = 90
		proj.CollisionBehavior = VJ.PROJ_COLLISION_NONE
		proj.SoundTbl_Idle = "vj_hlr/src/npc/alienassassin/ball_loop1.wav"
		proj.SoundTbl_OnCollide = "weapons/hegrenade/he_bounce-1.wav"
		proj.FuseTime = 3
		function proj:Init()
			timer.Simple(proj.FuseTime, function()
				if IsValid(proj) then
					proj:Destroy()
				end
			end)
			util.SpriteTrail(proj,0,Color(0,213,255),true,8,1,0.65,1 /(25 +1) *0.5,"VJ_Base/sprites/trail.vmt")
			local spriteGlow = ents.Create("env_sprite")
			spriteGlow:SetKeyValue("rendercolor","0 213 255")
			spriteGlow:SetKeyValue("GlowProxySize","2.0")
			spriteGlow:SetKeyValue("HDRColorScale","1.0")
			spriteGlow:SetKeyValue("renderfx","14")
			spriteGlow:SetKeyValue("rendermode","3")
			spriteGlow:SetKeyValue("renderamt","255")
			spriteGlow:SetKeyValue("disablereceiveshadows","0")
			spriteGlow:SetKeyValue("mindxlevel","0")
			spriteGlow:SetKeyValue("maxdxlevel","0")
			spriteGlow:SetKeyValue("framerate","10.0")
			spriteGlow:SetKeyValue("model","VJ_Base/sprites/glow.vmt")
			spriteGlow:SetKeyValue("spawnflags","0")
			spriteGlow:SetKeyValue("scale","0.1")
			spriteGlow:SetPos(proj:GetPos())
			spriteGlow:SetParent(proj)
			spriteGlow:Spawn()
			proj:DeleteOnRemove(spriteGlow)
		end
		function proj:OnDamaged(dmginfo)
			local phys = proj:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddVelocity(dmginfo:GetDamageForce() * 0.1)
			end
		end
		function proj:OnCollision(data, phys)
			local getVel = phys:GetVelocity()
			local curVelSpeed = getVel:Length()
			if curVelSpeed > 500 then
				phys:SetVelocity(getVel * 0.9)
			end
			
			if curVelSpeed > 100 then
				proj:PlaySound("OnCollide")
			end
		end
		local defAngle = Angle(0, 0, 0)
		function proj:OnDestroy()
			local myPos = proj:GetPos()
			
			VJ.EmitSound(proj, "vj_hlr/src/npc/alienassassin/ball_zap1.wav", 75)
			VJ.EmitSound(proj, "vj_hlr/src/npc/alienassassin/ball_shoot1.wav", 75)
			for i = 1,5 do
				ParticleEffect("vj_aurora_shockwave",myPos,defAngle)
				ParticleEffect("electrical_arc_01_system",myPos,defAngle)
			end
		
			local expLight = ents.Create("light_dynamic")
			expLight:SetKeyValue("brightness", "4")
			expLight:SetKeyValue("distance", "300")
			expLight:SetLocalPos(myPos)
			expLight:SetLocalAngles(proj:GetAngles())
			expLight:Fire("Color", "0 80 255")
			expLight:SetParent(proj)
			expLight:Spawn()
			expLight:Activate()
			expLight:Fire("TurnOn", "", 0)
			proj:DeleteOnRemove(expLight)
			
			proj:DealDamage()
		end
		proj:Spawn()
		proj:Activate()

		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self,ent,"Curve",proj:GetPos(),IsValid(ent) && 0.75 or targetPos,50))
		end
	elseif key == "attack_pests" then
		SafeRemoveEntity(self.HoldObject)
		local ent = self:GetEnemy()
		local targetPos = IsValid(ent) && ent:GetPos() +ent:OBBCenter() or self:GetPos() +self:OBBCenter() +self:GetForward() *1000
		local att = self:GetAttachment(self:LookupAttachment("rhand"))
		local proj = ents.Create("obj_vj_projectile_base")
		proj:SetModel(projPest)
		proj:SetPos(att.Pos)
		proj:SetAngles((targetPos -proj:GetPos()):Angle() +Angle(-90,0,0))
		proj:SetOwner(self)
		proj:SetNoDraw(false)
		proj:DrawShadow(true)
		proj.DoesRadiusDamage = true
		proj.RadiusDamageRadius = 175
		proj.RadiusDamage = 50
		proj.RadiusDamageUseRealisticRadius = true
		proj.RadiusDamageType = DMG_POISON
		proj.RadiusDamageForce = 5
		local defAngle = Angle(0, 0, 0)
		function proj:OnDestroy()
			local myPos = proj:GetPos()
			VJ.EmitSound(proj, "npc/antlion/antlion_shoot3.wav", 75)
			ParticleEffect("antlion_gib_02_gas",myPos,defAngle)
			for i = 1,10 do
				ParticleEffect("antlion_gib_02_floaters",myPos,defAngle)
			end
		end
		proj:Spawn()
		proj:Activate()

		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(true)
			phys:EnableDrag(true)
			phys:SetMass(1)
			phys:SetVelocity(VJ.CalculateTrajectory(self,ent,"Curve",proj:GetPos(),IsValid(ent) && 0.75 or targetPos,50))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && dmginfo:IsBulletDamage() && (hitgroup == 2 or hitgroup == 3 or hitgroup == 6 or hitgroup == 7) then
		if self.HasSounds && self.HasImpactSounds then
			VJ.EmitSound(self, "VJ.Impact.Armor")
		end
		dmginfo:ScaleDamage(0.8)
	end
end