AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/headcrab.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 10
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_yellow_01"}
ENT.HasMeleeAttack = false
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.LeapDistance = 300 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.3 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 1.4 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.85 -- How much time until it can use any attack again? | Counted in Seconds
ENT.TimeUntilLeapAttackVelocity = 0.1 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 50 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 250 -- How much upward force should it apply?
ENT.LeapAttackDamage = 8
ENT.LeapAttackExtraTimers = {0.4,0.6,0.8,1} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.StopLeapAttackAfterFirstHit = true
ENT.LeapAttackDamageDistance = 40 -- How far does the damage go?
ENT.FootStepTimeRun = 0.1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.1 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "HCFast.Chest", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 2), -- The offset for the controller when the camera is in first person
}
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.FootStepSoundLevel = 50
ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav","npc/headcrab_poison/ph_step2.wav","npc/headcrab_poison/ph_step3.wav","npc/headcrab_poison/ph_step4.wav"}
ENT.SoundTbl_Alert = {"npc/headcrab/alert1.wav"}
ENT.SoundTbl_Idle = {"npc/headcrab/idle1.wav","npc/headcrab/idle2.wav","npc/headcrab/idle3.wav"}
ENT.SoundTbl_BeforeLeapAttack = {"npc/headcrab/attack1.wav","npc/headcrab/attack2.wav","npc/headcrab/attack3.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/headcrab/headbite.wav"}
ENT.SoundTbl_Pain = {"npc/headcrab/pain1.wav","npc/headcrab/pain2.wav","npc/headcrab/pain3.wav"}
ENT.SoundTbl_Death = {"npc/headcrab/die1.wav","npc/headcrab/die2.wav"}
ENT.SoundTbl_IdleDialogue = {"npc/headcrab_fast/idle1.wav","npc/headcrab_fast/idle2.wav","npc/headcrab_fast/idle3.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"npc/headcrab_fast/alert1.wav","npc/headcrab_fast/idle1.wav","npc/headcrab_fast/idle2.wav","npc/headcrab_fast/idle3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(12,12,15), Vector(-12,-12,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttackVelocityCode()
	self:SetGroundEntity(NULL)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/