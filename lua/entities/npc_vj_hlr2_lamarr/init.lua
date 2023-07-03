AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Lamarr.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200

ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true
ENT.PlayerFriendly = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(8,10,15), Vector(-8,-10,0))

	self.Headcrab_Sleeping = false
	self.Headcrab_NextSleepT = CurTime() +math.random(20,30)
	self.Headcrab_WakeUpT = 0
	self.Headcrab_SleepAnimT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.Headcrab_Sleeping then
		self.Headcrab_WakeUpT = 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self.Headcrab_Sleeping then
		self.Headcrab_WakeUpT = 0
	else
		self.Headcrab_NextSleepT = CurTime() +math.random(20,30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()

	if self.Headcrab_Sleeping then
		if CurTime() > self.Headcrab_SleepAnimT then
			self:VJ_ACT_PLAYACTIVITY("SleepLoop",true,false,false)
			VJ.EmitSound(self,"npc/headcrab/idle2.wav",65,100)
			self.Headcrab_SleepAnimT = CurTime() +self:SequenceDuration("SleepLoop")
		elseif CurTime() > self.Headcrab_WakeUpT then
			self.Headcrab_Sleeping = false
			self.Headcrab_NextSleepT = CurTime() + math.Rand(15, 45)
			self:SetMaxLookDistance(10000)
			self.SightAngle = 80
		end
		return
	end

	if self.VJ_IsBeingControlled then return end
	
	if !self.Alerted && !IsValid(self:GetEnemy()) && !self:IsMoving() && CurTime() > self.Headcrab_NextSleepT && !self.Headcrab_Sleeping && !self:IsBusy() then
		self.Headcrab_Sleeping = true
		self.Headcrab_WakeUpT = CurTime() +math.Rand(15, 30)
		self:SetState(VJ_STATE_ONLY_ANIMATION)
		self:SetMaxLookDistance(325)
		self.SightAngle = 180
	end
end