AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/zombine.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_WIDE_HUMAN

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.BloodColor = "Yellow"
ENT.CustomBlood_Particle = {"blood_impact_green_01"}

ENT.MeleeAttackDamage = 10
ENT.AnimTbl_MeleeAttack = {"FastAttack"}
ENT.MeleeAttackDistance = 35
ENT.MeleeAttackDamageDistance = 75
ENT.TimeUntilMeleeAttackDamage = false

ENT.ItemDropsOnDeathChance = 10
ENT.ItemDropsOnDeath_EntityList = {"weapon_frag"}

ENT.CanFlinch = 1
ENT.FlinchChance = 8
ENT.NextFlinchTime = 5
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS}
ENT.HitGroupFlinching_DefaultWhenNotHit = true
ENT.HitGroupFlinching_Values = {
	{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},
	{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}
}

ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {"vj_hlr/hl2_npc/zombine/gear1.wav","vj_hlr/hl2_npc/zombine/gear2.wav","vj_hlr/hl2_npc/zombine/gear3.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl2_npc/zombine/zombine_idle1.wav","vj_hlr/hl2_npc/zombine/zombine_idle2.wav","vj_hlr/hl2_npc/zombine/zombine_idle3.wav","vj_hlr/hl2_npc/zombine/zombine_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl2_npc/zombine/zombine_alert1.wav","vj_hlr/hl2_npc/zombine/zombine_alert2.wav","vj_hlr/hl2_npc/zombine/zombine_alert3.wav","vj_hlr/hl2_npc/zombine/zombine_alert4.wav","vj_hlr/hl2_npc/zombine/zombine_alert5.wav","vj_hlr/hl2_npc/zombine/zombine_alert6.wav","vj_hlr/hl2_npc/zombine/zombine_alert7.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl2_npc/zombine/zombine_charge1.wav","vj_hlr/hl2_npc/zombine/zombine_charge2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl2_npc/zombine/zombine_pain1.wav","vj_hlr/hl2_npc/zombine/zombine_pain2.wav","vj_hlr/hl2_npc/zombine/zombine_pain3.wav","vj_hlr/hl2_npc/zombine/zombine_pain4.wav"}
ENT.SoundTbl_DeathFollow = {"vj_hlr/hl2_npc/zombine/zombine_die1.wav","vj_hlr/hl2_npc/zombine/zombine_die2.wav"}

ENT.Zombie_AnimationSet = 0 -- 0 = Default, 1 = Run
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSlump(doSlump)
	if doSlump then
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self.NextIdleStandTime = 0
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos() +self:GetForward() *-20,
			mins = self:OBBMins(),
			maxs = self:OBBMaxs(),
			filter = self
		})
		self.SlumpSet = tr.Hit && "a" or "b"
		self.AnimTbl_IdleStand = {VJ_SequenceToActivity(self,"slump_" .. self.SlumpSet)}
		self.SightDistance = 150
		self.SightAngle = 180
		self:AddFlags(FL_NOTARGET)
	else
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self:VJ_ACT_PLAYACTIVITY("slumprise_" .. self.SlumpSet, true, false, false, 0, {OnFinish=function(interrupted, anim)
			self:SetState()
		end})
		self.SightDistance = 10000
		self.SightAngle = 80
		self:RemoveFlags(FL_NOTARGET)
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
	local zType = self.ZombieType or math.random(0,3)

	if self.Slump then
		self:SetSlump(true)
	end

	self.GrenadePulled = false

	if self.ZombieType != 69 then
		if zType == 3 then
			local hp = self.StartHealth *1.25
			self:SetHealth(hp)
			self:SetMaxHealth(hp)
			self.ItemDropsOnDeath_EntityList = {"item_ammo_ar2_altfire"}
		end
		self:SetSkin(zType)
	end

	self.AnimTbl_Walk = {ACT_WALK}
	self.AnimTbl_Run = {ACT_WALK}

	if self.OnInit then
		self:OnInit()
	end

	self:SetBodygroup(1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel)
	elseif key == "pin" then
		self:CreateGrenade()
	elseif key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local slump = self.IsSlumped
	local set = self.Zombie_AnimationSet
	local grenPulled = self.GrenadePulled

	if !slump then
		local ent = self:GetEnemy()
		local dist = self.NearestPointToEnemyDistance
		if grenPulled then
			if !IsValid(self.GrenadeEntity) && self.GrenadeTime != nil && CurTime() > self.GrenadeTime then
				self:TakeDamage(999999999,self,self)
			end
			return
		end
		if self.VJ_IsBeingControlled == false then
			if IsValid(self:GetEnemy()) && math.random(1,(self:Health() < self:GetMaxHealth() *0.25) && 15 or 150) == 1 && dist < 300 then
				self:GrenadeCode()
			end
		else
			if self.VJ_TheController:KeyDown(IN_ATTACK2) then
				self:GrenadeCode()
			end
		end
		if !IsValid(ent) then
			if set == 1 then
				self.Zombie_AnimationSet = 0
				self.AnimTbl_Walk = {ACT_WALK}
				self.AnimTbl_Run = {ACT_WALK}
			end
			return
		end
		if dist <= 600 && set == 0 && math.random(1,100) == 1 then
			self.Zombie_AnimationSet = 1
			self.AnimTbl_Walk = {ACT_RUN}
			self.AnimTbl_Run = {ACT_RUN}
		elseif dist > 600 && set == 1 then
			self.Zombie_AnimationSet = 0
			self.AnimTbl_Walk = {ACT_WALK}
			self.AnimTbl_Run = {ACT_WALK}
		end
	else
		self.NextIdleSoundT_RegularChange = CurTime() +math.random(4,8)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, ent)
	if self:GetBodygroup(1) == 0 then
		return false
	end

	local oldEnt = self.GrenadeEntity
	if IsValid(oldEnt) then
		local grenent = ents.Create("obj_vj_grenade")
		grenent:SetModel("models/weapons/w_npcnade.mdl")
		grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
		grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
		grenent.FussTime = (oldEnt.CurFuss -CurTime())
		grenent:Spawn()
		grenent.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
		grenent.IdleSoundPitch = VJ_Set(100, 100)
		
		local redGlow = ents.Create("env_sprite")
		redGlow:SetKeyValue("model", "vj_base/sprites/vj_glow1.vmt")
		redGlow:SetKeyValue("scale", "0.07")
		redGlow:SetKeyValue("rendermode", "5")
		redGlow:SetKeyValue("rendercolor", "150 0 0")
		redGlow:SetKeyValue("spawnflags", "1") -- If animated
		redGlow:SetParent(grenent)
		redGlow:Fire("SetParentAttachment", "fuse", 0)
		redGlow:Spawn()
		redGlow:Activate()
		grenent:DeleteOnRemove(redGlow)
		util.SpriteTrail(grenent, 1, Color(200,0,0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")
	end

	VJ_CreateSound(ent,self.SoundTbl_DeathFollow,self.DeathSoundLevel)
	local dmgtype = dmginfo:GetDamageType()
	if hitgroup == HITGROUP_HEAD then
		ent:SetBodygroup(1,0)
		self:CreateExtraDeathCorpse(
			"prop_ragdoll",
			"models/headcrabclassic.mdl",
			{Pos=self:GetAttachment(self:LookupAttachment("headcrab")).Pos or self:EyePos()},
			function(crab)
				if self.HeadcrabClass == "npc_vj_hlr2b_headcrab" then
					crab:SetMaterial("models/hl_resurgence/hl2b/headcrab/headcrabsheet")
				end
			end
		)
	else
		if math.random(1,(dmgtype == DMG_CLUB or dmgtype == DMG_SLASH or DMG_BLAST) && 1 or 3) == 1 then
			ent:SetBodygroup(1,0)
			local crab = ents.Create(self.HeadcrabClass or "npc_vj_hlr2_headcrab")
			local enemy = self:GetEnemy()
			crab:SetPos(self:GetAttachment(self:LookupAttachment("headcrab")).Pos or self:EyePos())
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ_HasValue(self.SoundTbl_Pain,sdFile) or VJ_HasValue(self.DefaultSoundTbl_MeleeAttack,sdFile) then return end
	VJ_EmitSound(self,"npc/combine_soldier/vo/on" .. math.random(1,2) .. ".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateGrenade()
	if IsValid(self.GrenadeEntity) then return end
	local grenent = ents.Create("obj_vj_grenade")
	grenent:SetModel("models/weapons/w_npcnade.mdl")
	grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
	grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
	grenent:SetOwner(self)
	grenent:SetParent(self)
	grenent:Fire("SetParentAttachment","grenade_attachment",0)
	grenent.FussTime = 3.5
	grenent.CurFuss = CurTime() +3.5
	grenent:Spawn()
	grenent.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
	grenent.IdleSoundPitch = VJ_Set(100, 100)
	self:DeleteOnRemove(grenent)
	
	local redGlow = ents.Create("env_sprite")
	redGlow:SetKeyValue("model", "vj_base/sprites/vj_glow1.vmt")
	redGlow:SetKeyValue("scale", "0.07")
	redGlow:SetKeyValue("rendermode", "5")
	redGlow:SetKeyValue("rendercolor", "150 0 0")
	redGlow:SetKeyValue("spawnflags", "1") -- If animated
	redGlow:SetParent(grenent)
	redGlow:Fire("SetParentAttachment", "fuse", 0)
	redGlow:Spawn()
	redGlow:Activate()
	grenent:DeleteOnRemove(redGlow)
	util.SpriteTrail(grenent, 1, Color(200,0,0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")

	-- timer.Simple(3.485,function()
	-- 	if IsValid(self) && IsValid(grenent) then
	-- 		grenent:SetOwner(NULL)
	-- 		grenent:SetParent(NULL)
	-- 	end
	-- end)
	
	self.GrenadeEntity = grenent
	self.GrenadeTime = CurTime() +3.5
	-- grenent.VJHumanTossingAway = true // Soldiers kept stealing their grenades xD
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeCode()
	if self:IsBusy() or self.GrenadePulled == true then return end
	self.GrenadePulled = true
	self.AnimTbl_IdleStand = {"Idle_Grenade"}
	self.AnimTbl_Run = {VJ_SequenceToActivity(self,"Run_All_grenade")}
	self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"walk_All_Grenade")}
	VJ_CreateSound(self,"npc/zombine/zombine_readygrenade" .. math.random(1,2) .. ".wav",80,100)
	self:VJ_ACT_PLAYACTIVITY("pullGrenade",true,false,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then
		local p_name = VJ_PICK(self.CustomBlood_Particle)
		if p_name == false then return end
		
		local dmg_pos = dmginfo:GetDamagePosition()
		if dmg_pos == Vector(0, 0, 0) then dmg_pos = self:GetPos() + self:OBBCenter() end
		
		local spawnparticle = ents.Create("info_particle_system")
		spawnparticle:SetKeyValue("effect_name",p_name)
		spawnparticle:SetPos(dmg_pos)
		spawnparticle:Spawn()
		spawnparticle:Activate()
		spawnparticle:Fire("Start","",0)
		spawnparticle:Fire("Kill","",0.1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then return end
	if (dmginfo:IsBulletDamage()) then
		local attacker = dmginfo:GetAttacker()
		local spark = ents.Create("env_spark")
		spark:SetKeyValue("Magnitude","1")
		spark:SetKeyValue("Spark Trail Length","1")
		spark:SetPos(dmginfo:GetDamagePosition())
		spark:SetAngles(self:GetAngles())
		spark:SetParent(self)
		spark:Spawn()
		spark:Activate()
		spark:Fire("StartSpark", "", 0)
		spark:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(spark)

		dmginfo:ScaleDamage(0.5)
	end
	if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end

	if dmginfo:GetInflictor() == self.GrenadeEntity then
		dmginfo:ScaleDamage(500)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self.IsSlumped then
		self:SetSlump(false)
	end
end