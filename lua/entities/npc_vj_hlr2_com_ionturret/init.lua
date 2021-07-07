AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
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
ENT.Turret_FireSound = {"vj_hlr/hl2_npc/ioncannon/ion_cannon_shot1.wav","vj_hlr/hl2_npc/ioncannon/ion_cannon_shot2.wav","vj_hlr/hl2_npc/ioncannon/ion_cannon_shot3.wav"}

ENT.VJC_Data = {
    FirstP_Bone = "polySurface167", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(-5, 1, 20), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(8, 12, 22), Vector(-8, -12, 0))
	self.RangeDistance = self.SightDistance
	self.RangeAttackAngleRadius = 75
	self.SightAngle = 70
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
	
	VJ_EmitSound(self,self.Turret_FireSound,120,self:VJ_DecideSoundPitch(100,110))
	self:VJ_ACT_PLAYACTIVITY("vjseq_fire",true,0.15)
	local gest = self:AddGestureSequence(self:LookupSequence("fire"))
	self:SetLayerPriority(gest,1)
	self:SetLayerPlaybackRate(gest,0.5)
	
	ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,1)
	timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetAttachment(1).Pos)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "0 31 225")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	self.HasPoseParameterLooking = false -- Make it not aim at the enemy right away!
	timer.Simple(0.6, function()
		if IsValid(self) then
			self.HasPoseParameterLooking = true
		end
	end)
	self.NextResetEnemyT = CurTime() + 1 -- Make sure it doesn't reset the enemy right away
	self:VJ_ACT_PLAYACTIVITY({"deploy"}, true, false)
	VJ_EmitSound(self,{"npc/turret_floor/click1.wav"}, 70, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Turret_CurrentParameter then
		self.turret_turningsd = CreateSound(self, "ambient/alarms/combine_bank_alarm_loop4.wav") 
		self.turret_turningsd:SetSoundLevel(60)
		self.turret_turningsd:PlayEx(1, 100)
	else
		VJ_STOPSOUND(self.turret_turningsd)
	end
	self.Turret_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.Turret_HasLOS = false
	else
		if self.Turret_HasLOS == false && IsValid(self:GetEnemy()) then -- If it just got LOS, then play the gun "activate" sound
			VJ_EmitSound(self,{"npc/turret_floor/active.wav"}, 70, 100)
		end
		self.Turret_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) or self.Alerted == true then
		self.Turret_StandDown = false
		self.AnimTbl_IdleStand = {"idlealert"}
		
		local scan = false
		local pyaw = self:GetPoseParameter("aim_yaw")
		
		-- Make it scan around if the enemy is behind, which is unreachable for it!
		if IsValid(self:GetEnemy()) && self.Turret_HasLOS == false && (self:GetForward():Dot((self:GetEnemy():GetPos() - self:GetPos()):GetNormalized()) <= math.cos(math.rad(self.RangeAttackAngleRadius))) then
			scan = true
			self.HasPoseParameterLooking = false
		else
			self.HasPoseParameterLooking = true
		end
		
		 -- Look around randomly when the enemy is not found
		if !IsValid(self:GetEnemy()) or scan == true then
			-- Playing a beeping noise
			if self.Turret_NextScanBeepT < CurTime() then
				VJ_EmitSound(self, {"npc/roller/code2.wav"}, 75, 100)
				self.Turret_NextScanBeepT = CurTime() + 1
			end
			-- LEFT TO RIGHT
			-- Change the rotation direction when the max number is reached for a direction
			if pyaw >= 60 then
				self.Turret_ScanDirSide = 1
			elseif pyaw <= -60 then
				self.Turret_ScanDirSide = 0
			end
			self:SetPoseParameter("aim_yaw", pyaw + (self.Turret_ScanDirSide == 1 and -2 or 2))
			-- UP AND DOWN
			-- Change the rotation direction when the max number is reached for a direction
			if self:GetPoseParameter("aim_pitch") >= 15 then
				self.Turret_ScanDirUp = 1
			elseif self:GetPoseParameter("aim_pitch") <= -15 then
				self.Turret_ScanDirUp = 0
			end
			self:SetPoseParameter("aim_pitch", self:GetPoseParameter("aim_pitch") + (self.Turret_ScanDirUp == 1 and -3 or 3))
		end
	else
		-- Play the retracting sequence and sound
		if CurTime() > self.NextResetEnemyT && self.Alerted == false && self.Turret_StandDown == false then
			self.Turret_StandDown = true
			self:VJ_ACT_PLAYACTIVITY({"retire"}, true, 1)
			VJ_EmitSound(self,{"npc/turret_floor/retract.wav"}, 70, 100)
		end
		if self.Turret_StandDown == true then
			self.AnimTbl_IdleStand = {ACT_IDLE}
		end
	end
end