AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/headcrabblack.mdl"}
ENT.StartHealth = 30
ENT.HullType = HULL_TINY

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "HCblack.torso", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 2), -- The offset for the controller when the camera is in first person
}

ENT.AnimTbl_IdleStand = {ACT_IDLE,"IdleSumo","IdleSniff"}

ENT.BloodColor = "Yellow"
ENT.CustomBlood_Particle = {"blood_impact_yellow_01"}

ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {"vjseq_Spitattack"}
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_headcrabspit"
ENT.TimeUntilRangeAttackProjectileRelease = 0.725
ENT.NextRangeAttackTime = 3
ENT.RangeDistance = 800
ENT.RangeToMeleeDistance = 400

ENT.HasLeapAttack = true
ENT.AnimTbl_LeapAttack = {ACT_RANGE_ATTACK1}
ENT.LeapDistance = 250
ENT.LeapToMeleeDistance = 0
ENT.TimeUntilLeapAttackDamage = 1.5
ENT.NextLeapAttackTime = 1.8
ENT.NextAnyAttackTime_Leap = 1.8
ENT.TimeUntilLeapAttackVelocity = 1.48
ENT.LeapAttackVelocityForward = 70
ENT.LeapAttackVelocityUp = 200
ENT.LeapAttackDamageType = DMG_SLASH
ENT.LeapAttackExtraTimers = {1.7,1.9,2.1,2.3}
ENT.StopLeapAttackAfterFirstHit = true
ENT.LeapAttackDamageDistance = 40
ENT.LeapAttackDamage = 0
ENT.DisableDefaultLeapAttackDamageCode = true

ENT.CanFlinch = 1
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH
ENT.FlinchChance = 3
ENT.NextFlinchTime = 1

ENT.HasExtraMeleeAttackSounds = true
ENT.FootStepTimeRun = 0.5
ENT.FootStepTimeWalk = 0.5

ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav","npc/headcrab_poison/ph_step2.wav","npc/headcrab_poison/ph_step3.wav","npc/headcrab_poison/ph_step4.wav"}
ENT.SoundTbl_AlertAnim = {"npc/headcrab_poison/ph_warning1.wav","npc/headcrab_poison/ph_warning2.wav","npc/headcrab_poison/ph_warning3.wav"}
ENT.SoundTbl_CombatIdle = {"npc/headcrab_poison/ph_hiss1.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"npc/headcrab_poison/ph_scream1.wav","npc/headcrab_poison/ph_scream2.wav","npc/headcrab_poison/ph_scream3.wav"}
ENT.SoundTbl_BeforeLeapAttack = {"npc/headcrab_poison/ph_scream1.wav","npc/headcrab_poison/ph_scream2.wav","npc/headcrab_poison/ph_scream3.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/headcrab_poison/ph_poisonbite1.wav","npc/headcrab_poison/ph_poisonbite2.wav","npc/headcrab_poison/ph_poisonbite3.wav"}
ENT.SoundTbl_LeapAttackJump = {"npc/headcrab_poison/ph_jump1.wav","npc/headcrab_poison/ph_jump2.wav","npc/headcrab_poison/ph_jump3.wav"}
ENT.SoundTbl_Pain = {"npc/headcrab_poison/ph_pain1.wav","npc/headcrab_poison/ph_pain2.wav","npc/headcrab_poison/ph_pain3.wav","npc/headcrab_poison/ph_wallpain1.wav","npc/headcrab_poison/ph_wallpain2.wav","npc/headcrab_poison/ph_wallpain3.wav"}
ENT.SoundTbl_Death = {"npc/headcrab_poison/ph_rattle1.wav","npc/headcrab_poison/ph_rattle2.wav","npc/headcrab_poison/ph_rattle3.wav"}
ENT.SoundTbl_Idle = {
	"npc/headcrab_poison/ph_idle1.wav",
	"npc/headcrab_poison/ph_idle2.wav",
	"npc/headcrab_poison/ph_idle3.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"npc/headcrab_poison/ph_talk1.wav",
	"npc/headcrab_poison/ph_talk2.wav",
	"npc/headcrab_poison/ph_talk3.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"npc/headcrab_poison/ph_talk1.wav",
	"npc/headcrab_poison/ph_talk2.wav",
	"npc/headcrab_poison/ph_talk3.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"npc/headcrab_poison/ph_idle1.wav",
	"npc/headcrab_poison/ph_idle2.wav",
	"npc/headcrab_poison/ph_idle3.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"npc/headcrab_poison/ph_talk1.wav",
	"npc/headcrab_poison/ph_talk2.wav",
	"npc/headcrab_poison/ph_talk3.wav",
}

ENT.GeneralSoundPitch1 = 100

ENT.AnimationSet = 0 -- 0 = Default, 1 = Scurry, 2 = Custom
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(14,14,15), Vector(-14,-14,0))

	self.ScurryAnimation = VJ.SequenceToActivity(self,"Scurry")
	self.FlyAnimation = VJ.SequenceToActivity(self,"Drown")

	self.WasThrown = false
	self.HasRanThrownDamage = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * 15 + self:GetForward() * 10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	return self:CalculateProjectile("Curve", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "PriorExecution" && self.AttackState == VJ.ATTACK_STATE_STARTED then -- Since StopAttacks() doesn't stop the velocity code from running
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.CanAlertCrab != true then return end

	VJ.STOPSOUND(self.CurrentIdleSound)
	self.NextIdleSoundT = self.NextIdleSoundT + 2
	self.CurrentSpeechSound = VJ.CreateSound(self,VJ.PICK(self.SoundTbl_AlertAnim),self.AlertSoundLevel,self:GetSoundPitch(self.AlertSoundPitch.a,self.AlertSoundPitch.b))
	self:PlayAnim("Threatdisplay",true,VJ.AnimDuration(self,"Threatdisplay"),false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if self.WasThrown then
			return self.FlyAnimation
		end
	elseif act == ACT_RUN then
		if self.IsFollowing then
			return self.ScurryAnimation
		end
		return self:Health() <= 10 && self.ScurryAnimation or ACT_RUN
	elseif act == ACT_WALK then
		if self.IsFollowing then
			return self.ScurryAnimation
		end
		return self:Health() <= 10 && self.ScurryAnimation or ACT_RUN
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local animSet = self.AnimationSet
	if self.WasThrown then
		if self:IsOnGround() then
			self.WasThrown = false
			self:ClearSchedule()
			self:SetState()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTouch(ent)
	if self.WasThrown && !self.HasRanThrownDamage then
		if (ent:IsNPC() || (ent:IsPlayer() && ent:Alive())) && (self:Disposition(ent) != D_LI) && (ent != self) && (ent:GetClass() != self:GetClass()) then
			self.HasRanThrownDamage = true
			self:DoPoisonHeadcrabDamage(ent)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPoisonHeadcrabDamage(v)
	if !IsValid(v) then return end

	VJ.EmitSound(self,self.SoundTbl_LeapAttackDamage,75)

	if v:Health() > 1 then
		local poisonDMG = DamageInfo()
		poisonDMG:SetDamage(v:Health() -1)
		poisonDMG:SetInflictor(self)
		poisonDMG:SetDamageType(DMG_POISON)
		poisonDMG:SetAttacker(self)
		if v:IsNPC() or v:IsPlayer() then
			poisonDMG:SetDamageForce(self:GetForward()*((poisonDMG:GetDamage()+100)*70))
		end
		v:TakeDamageInfo(poisonDMG, self)
	else
		local normalDMG = DamageInfo()
		normalDMG:SetDamage(self:ScaleByDifficulty(40))
		normalDMG:SetInflictor(self)
		normalDMG:SetDamageType(DMG_SLASH)
		normalDMG:SetAttacker(self)
		if v:IsNPC() or v:IsPlayer() then
			normalDMG:SetDamageForce(self:GetForward()*((normalDMG:GetDamage()+100)*70))
		end
		v:TakeDamageInfo(normalDMG, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterStartTimer(seed)
	local pos = self:GetPos()
	if IsValid(self:GetEnemy()) then
		pos = self:GetEnemy():GetPos()
	end
	sound.EmitHint(SOUND_DANGER, pos, 250, 1, self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterChecks(v)
	self:DoPoisonHeadcrabDamage(v)
end