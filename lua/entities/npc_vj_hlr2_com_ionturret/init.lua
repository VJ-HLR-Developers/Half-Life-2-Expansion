AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/combine_cannon_gun.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.Turret_HasAlarm = false
ENT.Turret_BulletAttachment = "muzzle"
ENT.TimeUntilRangeAttackProjectileRelease = 0.001 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 1.8 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 1.8 -- How much time until it can use any attack again? | Counted in Seconds
ENT.Turret_Fire = {"vjseq_fire"}
ENT.Turret_FireSound = {"vj_combine/ioncannon/ion_cannon_shot1.wav","vj_combine/ioncannon/ion_cannon_shot2.wav","vj_combine/ioncannon/ion_cannon_shot3.wav"}
ENT.Turret_TurningSound = "ambient/alarms/combine_bank_alarm_loop4.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(8, 12, 22), Vector(-8, -12, 0))
	self.RangeDistance = self.SightDistance
	self.RangeAttackAngleRadius = 75
	self.SightAngle = 70
	self.Turret_AlarmTimes = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTrace()
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("muzzle")).Pos
	tracedata.endpos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() +Vector(math.Rand(-60,60),math.Rand(-60,60),0)
	tracedata.filter = {self}
	return util.TraceLine(tracedata).HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local attackpos = self:DoTrace()
	util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",self:GetPos(),attackpos,false,self:EntIndex(),1)
	ParticleEffect("aurora_shockwave",attackpos,Angle(math.random(0,360),math.random(0,360),math.random(0,360)),nil)
	ParticleEffect("Weapon_Combine_Ion_Cannon_Exlposion_c",attackpos,Angle(math.random(0,360),math.random(0,360),math.random(0,360)),nil)
	util.ScreenShake(attackpos, 16, 200, 2, 1500)
	util.ScreenShake(self:GetPos(),12,100,0.4,800)
	sound.Play("weapons/mortar/mortar_explode3.wav",attackpos,80,100)
	util.VJ_SphereDamage(self,self,attackpos,80,40,DMG_DISSOLVE,true,false,{Force = 150})
	
	VJ_EmitSound(self,self.Turret_FireSound,self.Turret_FireSoundVolume,self:VJ_DecideSoundPitch(100,110))
	self:VJ_ACT_PLAYACTIVITY("vjseq_fire",true,0.15)
	local gest = self:AddGestureSequence(self:LookupSequence("fire"))
	self:SetLayerPriority(gest,1)
	self:SetLayerPlaybackRate(gest,0.5)
	
	ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,self.Turret_BulletAttachmentParticle)
	timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetAttachment(self:LookupAttachment(self.Turret_BulletAttachment)).Pos)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "0 31 225")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self:DeleteOnRemove(FireLight1)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/