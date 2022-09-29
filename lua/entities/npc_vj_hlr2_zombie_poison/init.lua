AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/zombie_poison.mdl"}
ENT.StartHealth = 250
ENT.HullType = HULL_HUMAN

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.BloodColor = "Yellow"
ENT.CustomBlood_Particle = {"blood_impact_green_01"}

ENT.MeleeAttackDamage = 18
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 35
ENT.MeleeAttackDamageDistance = 75
ENT.TimeUntilMeleeAttackDamage = false

ENT.CanFlinch = 1
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH}

ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {"npc/zombie_poison/pz_left_foot1.wav","npc/zombie_poison/pz_right_foot1.wav"}
ENT.SoundTbl_Idle = {"npc/zombie_poison/pz_idle2.wav","npc/zombie_poison/pz_idle3.wav","npc/zombie_poison/pz_idle4.wav"}
ENT.SoundTbl_DefBreath = {"npc/zombie_poison/pz_breathe_loop1.wav","npc/zombie_poison/pz_breathe_loop2.wav"}
ENT.SoundTbl_Alert = {"npc/zombie_poison/pz_alert1.wav","npc/zombie_poison/pz_alert2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombie_poison/pz_warn1.wav","npc/zombie_poison/pz_warn2.wav"}
ENT.SoundTbl_Pain = {"npc/zombie_poison/pz_pain1.wav","npc/zombie_poison/pz_pain2.wav","npc/zombie_poison/pz_pain3.wav"}
ENT.SoundTbl_DeathFollow = {"npc/zombie_poison/pz_die1.wav","npc/zombie_poison/pz_die2.wav"}
ENT.SoundTbl_Warn = {"npc/zombie_poison/pz_warn1.wav","npc/zombie_poison/pz_warn2.wav"}
ENT.SoundTbl_Throw = {"npc/zombie_poison/pz_throw2.wav","npc/zombie_poison/pz_throw3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}

ENT.HeadcrabClass = "npc_vj_hlr2_headcrab_poison"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSlump(doSlump)
	if doSlump then
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {VJ_SequenceToActivity(self,"slump_a")}
		self:SetSightDistance(150)
		self.SightAngle = 180
		self:AddFlags(FL_NOTARGET)
	else
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self:VJ_ACT_PLAYACTIVITY("slumprise_a", true, false, false, 0, {OnFinish=function(interrupted, anim)
			self:SetState()
		end})
		self:SetSightDistance(10000)
		self.SightAngle = 80
		self:RemoveFlags(FL_NOTARGET)
		self.SoundTbl_Breath = self.SoundTbl_DefBreath
	end
	self.IsSlumped = doSlump
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.IsSlumped then
		self:SetSlump(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	local zType = self.ZombieType or math.random(1,8)

	if self.OnInit then
		self:OnInit()
	end

	if self.Slump then
		self:SetSlump(true)
	else
		self.SoundTbl_Breath = self.SoundTbl_DefBreath
	end

	if self.ZombieType != 69 then
		if zType != 4 then -- 4 skin is normal poison zombie
			local hp = self.StartHealth *((zType == 1 && zType == 3) && 1.2 or (zType >= 5 && zType <= 7) && 1.5 or zType == 8 && 2 or 1)
			self:SetHealth(hp)
			self:SetMaxHealth(hp)
			if (zType == 1 && zType == 3) or (zType >= 5 && zType <= 7) then
				self.ItemDropsOnDeath_EntityList = {"weapon_frag"}
				self.ItemDropsOnDeathChance = 12
			elseif zType == 8 then
				self.ItemDropsOnDeath_EntityList = {"item_ammo_ar2_altfire"}
				self.ItemDropsOnDeathChance = 6
			end
			if zType == 3 then
				self.SoundTbl_FootStepAdd = {"vj_hlr/hl2_npc/zolice/gear1.wav","vj_hlr/hl2_npc/zolice/gear2.wav","vj_hlr/hl2_npc/zolice/gear3.wav"}
			elseif zType >= 5 && zType <= 8 then
				self.SoundTbl_FootStepAdd = {"vj_hlr/hl2_npc/zombine/gear1.wav","vj_hlr/hl2_npc/zombine/gear2.wav","vj_hlr/hl2_npc/zombine/gear3.wav"}
			end
		end
		self:SetSkin(zType)
	end

	self:SetBodygroup(1,1)
	self:SetBodygroup(2,1)
	self:SetBodygroup(3,1)
	self:SetBodygroup(4,1)

	self.Headcrabs = 3
	self.NextThrowT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThrowHeadcrab(pos)
	local current = self.Headcrabs
	if current == 0 then
		return
	end
	self:SetBodygroup(1 +current,0)
	self.Headcrabs = current -1

	sound.EmitHint(SOUND_DANGER, pos, 250, 1, self)

	local att = self:GetAttachment(self:LookupAttachment("headcrab" .. 1 +current))
	local p = ents.Create(self.HeadcrabClass)
	p:SetPos(att.Pos)
	p:SetAngles(Angle(0,(pos -p:GetPos()):Angle().y,0))
	p:Spawn()
	p:OnThrown(self:GetEnemy(),self,pos)

	-- local ply = self:GetCreator()
	-- if IsValid(ply) then -- Kind of silly, as you can remove them as they are thrown. Leaving for future use if wanted
	-- 	undo.Create(self:GetName() .. "'s " .. p:GetName())
	-- 		undo.AddEntity(p)
	-- 		undo.SetPlayer(ply)
	-- 	undo.Finish()
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel)
		if self.SoundTbl_FootStepAdd then
			VJ_EmitSound(self,self.SoundTbl_FootStepAdd,self.FootStepSoundLevel)
		end
	-- elseif key == "pickup" then
		-- // Do something except not really
	elseif key == "melee" then
		self:MeleeAttackCode()
		if self.IsBeta then
			VJ_EmitSound(self,"vj_hlr/hl1_npc/bullchicken/bc_spithit3.wav")

			local pos,ang = self:GetBonePosition(53)
			ParticleEffect("antlion_gib_01",pos,ang,nil)
		end
	elseif key == "throw" then
		local ent = self:GetEnemy()
		self:ThrowHeadcrab(IsValid(ent) && ent:GetPos() +ent:OBBCenter() or self:GetPos() +self:GetForward() *400 +self:OBBCenter())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	local headcrabs = self.Headcrabs
	if headcrabs <= 0 then
		return
	end
	local ent = self:GetEnemy()
	local cont = self.VJ_TheController
	local dist = self.NearestPointToEnemyDistance

	if IsValid(cont) && !cont:KeyDown(IN_ATTACK2) then
		return
	end

	if IsValid(ent) && dist <= 700 && dist > 150 && self:Visible(ent) && CurTime() > self.NextThrowT && !self:IsBusy() then
		if dist <= 350 then
			self:VJ_ACT_PLAYACTIVITY("headcrab2Leap",true,false,true)
		else
			VJ_CreateSound(self,self.SoundTbl_Warn,80)
			sound.EmitHint(SOUND_DANGER, ent:GetPos(), 250, 1, self)
			self:VJ_ACT_PLAYACTIVITY("ThrowWarning",true,false,true, 0, {OnFinish=function(interrupted, anim)
				if interrupted then
					return
				end
				self:VJ_ACT_PLAYACTIVITY("Throw",true,false,true)
				VJ_CreateSound(self,self.SoundTbl_Throw,80)
			end})
		end
		self.NextThrowT = CurTime() +math.random(8,12)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local slump = self.IsSlumped
	local set = self.Zombie_AnimationSet

	if slump then
		self.NextIdleSoundT_RegularChange = CurTime() +math.random(4,8)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self.IsSlumped then
		self:SetSlump(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, ent)
	if self:GetBodygroup(1) == 0 then
		return false
	end

	VJ_CreateSound(ent,self.SoundTbl_DeathFollow,self.DeathSoundLevel)
	for i = 1,self.Headcrabs do
		local crab = ents.Create(self.HeadcrabClass or "npc_vj_hlr2_headcrab_poison")
		local enemy = self:GetEnemy()
		crab:SetPos(self:GetAttachment(self:LookupAttachment("headcrab" .. i)).Pos or self:EyePos())
		crab:SetAngles(self:GetAngles() +Angle(0,math.random(0,360),0))
		crab:Spawn()
		crab:SetGroundEntity(NULL) -- This fixes that issue where they snap to the ground when spawned
		crab:SetLocalVelocity(self:GetVelocity() *dmginfo:GetDamageForce():Length())
		if ent:IsOnFire() then
			crab:Ignite(math.random(8,10))
		end
		ent:SetBodygroup(1 +i,0)
		crab.EntitiesToNoCollide = {crab:GetClass()}
	end
	local dmgtype = dmginfo:GetDamageType()
	if hitgroup == HITGROUP_HEAD then
		ent:SetBodygroup(1,0)
		local mdl = self.HeadcrabClass == "npc_vj_hlr2b_headcrab_poison" && "models/vj_hlr/hl2b/headcrab_poison.mdl" or "models/headcrabblack.mdl"
		self:CreateExtraDeathCorpse(
			"prop_ragdoll",
			mdl,
			{Pos=self:GetAttachment(self:LookupAttachment("headcrab1")).Pos or self:EyePos()})
	else
		if math.random(1,(dmgtype == DMG_CLUB or dmgtype == DMG_SLASH or DMG_BLAST) && 1 or 3) == 1 then
			ent:SetBodygroup(1,0)
			local crab = ents.Create(self.HeadcrabClass or "npc_vj_hlr2_headcrab_poison")
			local enemy = self:GetEnemy()
			crab:SetPos(self:GetAttachment(self:LookupAttachment("headcrab1")).Pos or self:EyePos())
			crab:SetAngles(self:GetAngles())
			crab:Spawn()
			crab:SetGroundEntity(NULL) -- This fixes that issue where they snap to the ground when spawned
			crab:SetLocalVelocity(self:GetVelocity() *dmginfo:GetDamageForce():Length())
			if ent:IsOnFire() then
				crab:Ignite(math.random(8,10))
			end
			undo.ReplaceEntity(self,crab)
		end
	end
end