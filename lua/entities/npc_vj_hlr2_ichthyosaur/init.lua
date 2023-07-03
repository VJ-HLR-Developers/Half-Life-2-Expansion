AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/icky.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_LARGE_CENTERED

ENT.IdleAlwaysWander = true
ENT.TurningUseAllAxis = true -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.MovementType = VJ_MOVETYPE_AQUATIC -- How does the SNPC move?

ENT.Aquatic_SwimmingSpeed_Calm = 150 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 500 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {ACT_GLIDE} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {ACT_SWIM} -- Animations it plays when it's moving while alerted

ENT.VJC_Data = {
    ThirdP_Offset = Vector(-25, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(12, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}

ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other

ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 75 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 120 -- How far does the damage go?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 10 -- How many repetitions?
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 10 -- How much time until player's Speed resets

ENT.SoundTbl_Breath = {"npc/ichthyosaur/water_breath.wav"}
ENT.SoundTbl_Alert = {"npc/ichthyosaur/water_growl5.wav"}
ENT.SoundTbl_CombatIdle = {"npc/ichthyosaur/water_growl5.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/ichthyosaur/attack_growl1.wav","npc/ichthyosaur/attack_growl2.wav","npc/ichthyosaur/attack_growl3.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/ichthyosaur/snap.wav"}

ENT.GeneralSoundPitch1 = 100

ENT.Icky_Idle = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(40,40,40), Vector(-40,-40,-40))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks()
	local pos = self:GetPos() +self:GetAngles():Forward() *35
	effects.Bubbles(pos +Vector(-32,-32,-32),pos +Vector(32,32,32),math.random(16,32),math.random(100,300),1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(v, isProp)
	self:SetHealth(math.Clamp(self:Health() + ((self.MeleeAttackDamage > v:Health() && v:Health()) or self.MeleeAttackDamage), self:Health(), self:GetMaxHealth()*2))
	self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1_LOW,true,false,true)
	if v:IsPlayer() then
		v:ScreenFade(SCREENFADE.IN,Color(64,0,0),0.5,0)
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss()
	self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK2_LOW,true,false,false)
	VJ.CreateSound(self,"npc/ichthyosaur/snap_miss.wav",75)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local waterLevel = self:WaterLevel()
	if math.random(1,10) == 1 && waterLevel > 0 then
		effects.Bubbles(self:GetPos() +(self:OBBMins() *0.5),self:GetPos() +(self:OBBMaxs() *0.5),math.random(1,4),math.random(100,300),1)
	end
	if self.Icky_Idle == 0 && waterLevel == 0 then
		self.Icky_Idle = 1
		self.HasMeleeAttack = false
		self.HasDeathAnimation = false
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {"thrash"}
	elseif self.Icky_Idle == 1 && waterLevel > 0 then
		self.Icky_Idle = 0
		self.HasMeleeAttack = true
		self.HasDeathAnimation = true
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {ACT_IDLE}
	end
end