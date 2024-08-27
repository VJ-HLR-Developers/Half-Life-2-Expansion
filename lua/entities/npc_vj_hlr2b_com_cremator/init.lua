AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/cremator.mdl"
ENT.StartHealth = 650
ENT.HullType = HULL_HUMAN
ENT.TurningSpeed = 12

ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.BloodColor = "Red"

ENT.CanFlinch = 1
ENT.FlinchChance = 35
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1, ACT_RANGE_ATTACK2, ACT_RANGE_ATTACK1, ACT_RANGE_ATTACK2, ACT_RELOAD}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackAnimationFaceEnemy = false
ENT.MeleeAttackDistance = 300

ENT.PoseParameterLooking_InvertYaw = true
ENT.ConstantlyFaceEnemyDistance = 500

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.PainSoundPitch = VJ_Set(40, 55)

ENT.SoundTbl_FootStep = {"vj_hlr/hl2_npc/cremator/foot1.wav","vj_hlr/hl2_npc/cremator/foot2.wav","vj_hlr/hl2_npc/cremator/foot3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl2_npc/cremator/alert_object.wav","vj_hlr/hl2_npc/cremator/alert_player.wav"}
ENT.SoundTbl_Pain = {"npc/combine_soldier/pain1.wav","npc/combine_soldier/pain2.wav","npc/combine_soldier/pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl2_npc/cremator/crem_die.wav"}

ENT.Cremator_FlameRange = 370
ENT.Cremator_FlameDamage = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.IsFlameActive = false
	self.IdleLoopStatus = 0

	self.IdleLoop = CreateSound(self,"vj_hlr/hl2_npc/cremator/amb_loop.wav")
	self.IdleLoop:SetSoundLevel(60)
	self.IdleLoop:Play()

	self.AlertLoop = CreateSound(self,"vj_hlr/hl2_npc/cremator/amb_mad.wav")
	self.AlertLoop:SetSoundLevel(65)

	self.FireLoop = CreateSound(self,"vj_hlr/hl2_npc/cremator/plasma_shoot.wav")
	self.FireLoop:SetSoundLevel(80)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply,controlEnt)
	function controlEnt:CustomOnThink()
		self.VJC_BullseyeTracking = self.VJCE_NPC:GetIdealActivity() == ACT_RUN
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	-- print(key)
	if key == "step" then
		self:FootStepSoundCode()
		VJ.EmitSound(self,"vj_hlr/hl2_npc/cremator/amb" .. math.random(1,3) .. ".wav",60)
	elseif key == "fire_start" then
		self.IsFlameActive = true
		ParticleEffectAttach("vj_hlr_cremator_range",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("muzzle"))
		VJ.EmitSound(self,"vj_hlr/hl2_npc/cremator/plasma_ignite.wav",75)
		self.FireLoop:Play()
		self:SetMaxYawSpeed(1)
	elseif key == "fire_end" then
		self.IsFlameActive = false
		self:StopParticles()
		VJ.EmitSound(self,"vj_hlr/hl2_npc/cremator/plasma_stop.wav",75)
		self.FireLoop:Stop()
		self:SetMaxYawSpeed(self.TurningSpeed)
	elseif key == "gun_foley" then
		VJ.EmitSound(self,"physics/metal/weapon_impact_soft" .. math.random(1,3) .. ".wav",70)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(act)
	if self.IsFlameActive then
		self.IsFlameActive = false
		self:StopParticles()
		VJ.EmitSound(self,"vj_hlr/hl2_npc/cremator/plasma_stop.wav",75)
		self.FireLoop:Stop()
		self:SetMaxYawSpeed(self.TurningSpeed)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Alerted && self.IdleLoopStatus == 0 then
		self.IdleLoop:Stop()
		self.AlertLoop:Play()
		self.IdleLoopStatus = 1
	elseif !self.Alerted && self.IdleLoopStatus == 1 then
		self.AlertLoop:Stop()
		self.IdleLoop:Play()
		self.IdleLoopStatus = 0
	end
	if self.IsFlameActive then
		self:SetTurnTarget("Enemy",0.2)
		local att = self:GetAttachment(self:LookupAttachment("muzzle"))
		local pos,ang = att.Pos,att.Ang
		sound.EmitHint(SOUND_DANGER, pos +ang:Forward() *(self.Cremator_FlameRange /2), self.Cremator_FlameRange *2, 0.2, self)
		VJ.ApplyRadiusDamage(self,self,(self:GetPos() +(self:GetForward() *self:OBBMaxs().y)),self.Cremator_FlameRange,self.Cremator_FlameDamage,bit.bor(DMG_BURN,DMG_DISSOLVE,DMG_ENERGYBEAM),true,false,{UseCone=true,UseConeDegree=35,UseConeDirection=ang:Forward()},
		function(ent)
			if (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() or VJ.IsProp(ent)) then
				if ent:IsPlayer() then
					ent:ScreenFade(SCREENFADE.IN,Color(26,255,0,170),0.5,0)
				end
				if !ent:IsOnFire() then
					ent:Ignite(10)
				end
			elseif ent:IsRagdoll() then
				ent:Dissolve(0, 1)
			end
		end)	
	end
	self.ConstantlyFaceEnemy = self:GetIdealActivity() == ACT_RUN
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- function ENT:TranslateActivity(act)
-- 	if act == ACT_IDLE then
-- 		if self.Alerted then
-- 			return ACT_IDLE_ANGRY
-- 		end
-- 	end
-- 	return act
-- end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.IdleLoop)
	VJ.STOPSOUND(self.AlertLoop)
	VJ.STOPSOUND(self.FireLoop)
end