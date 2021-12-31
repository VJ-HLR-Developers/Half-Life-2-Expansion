AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Lamarr.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.FriendsWithAllPlayerAllies = true
ENT.PlayerFriendly = true
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(8,10,15), Vector(-8,-10,0))
	self.NextSleepAnimT = CurTime()
	self.NextSleepT = CurTime() +math.random(20,30)
	self.WakeUpT = 0
	self.IsSleeping = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self.IsSleeping then
		self.WakeUpT = 0
	else
		self.NextSleepT = CurTime() +math.random(20,30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if !IsValid(self:GetEnemy()) then
		if !self.IsSleeping then
			if CurTime() > self.NextSleepT && math.random(1,30) == 1 then
				self.WakeUpT = CurTime() +math.Rand(50,80)
				self.IsSleeping = true
			end
		else
			if CurTime() > self.WakeUpT then
				self.IsSleeping = false
				self.WakeUpT = 0
				self.NextSleepT = CurTime() +math.random(20,30)
			end
		end
	else
		if self.IsSleeping then
			self.IsSleeping = false
			self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"),0)
			self.WakeUpT = 0
			self.NextSleepT = CurTime() +math.random(20,30)
		end
	end
	if self.IsSleeping then
		self:StopMoving()
		self:StopMoving()
		self:ClearSchedule()
		self.HasSounds = false
		self.SightDistance = 200
		self.DisableWandering = true
		self.DisableChasingEnemy = true
		self.DisableMakingSelfEnemyToNPCs = true
		self:SetMaxYawSpeed(0)
		if CurTime() > self.NextSleepAnimT then
			self:VJ_PlaySequence("SleepLoop",1,false,0,true)
			VJ_EmitSound(self,"npc/headcrab/idle2.wav",65,100)
			self.NextSleepAnimT = CurTime() +self:SequenceDuration("SleepLoop")
		end
	else
		self.HasSounds = true
		self.SightDistance = 10000
		self.DisableWandering = false
		self.DisableChasingEnemy = false
		self.DisableMakingSelfEnemyToNPCs = false
		self:SetMaxYawSpeed(self.TurningSpeed)
	end
end