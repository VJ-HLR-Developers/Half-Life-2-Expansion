AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/zombine.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 110
ENT.HullType = HULL_WIDE_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_green_01"}
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"FastAttack"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 90 -- How far does the damage go?
ENT.MeleeAttackDamage = 18
ENT.TimeUntilMeleeAttackDamage = 0.45
ENT.FootStepTimeRun = 0.21 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "ValveBiped.HC_Body_Bone", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 0), -- The offset for the controller when the camera is in first person
}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombine/gear1.wav","npc/zombine/gear2.wav","npc/zombine/gear3.wav"}
ENT.SoundTbl_Idle = {"npc/zombine/zombine_idle1.wav","npc/zombine/zombine_idle2.wav","npc/zombine/zombine_idle3.wav","npc/zombine/zombine_idle4.wav","npc/zombine/zombine_alert1.wav","npc/zombine/zombine_alert2.wav","npc/zombine/zombine_alert3.wav","npc/zombine/zombine_alert4.wav","npc/zombine/zombine_alert7.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombine/zombine_pain2.wav"}
ENT.SoundTbl_Alert = {
	"npc/zombine/zombine_charge1.wav",
	"npc/zombine/zombine_charge2.wav",
}
ENT.SoundTbl_Pain = {
	"npc/zombine/zombine_pain1.wav",
	"npc/zombine/zombine_pain2.wav",
	"npc/zombine/zombine_pain3.wav",
	"npc/zombine/zombine_pain4.wav",
}
ENT.SoundTbl_Death = {
	"npc/zombine/zombine_die1.wav",
	"npc/zombine/zombine_die2.wav",
}
ENT.GrenadeTime = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ_HasValue(self.SoundTbl_Pain,sdFile) or VJ_HasValue(self.DefaultSoundTbl_MeleeAttack,sdFile) then return end
	VJ_EmitSound(self,"npc/combine_soldier/vo/on" .. math.random(1,2) .. ".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0,4))
	self:SetBodygroup(1,1)
	self:SetCollisionBounds(Vector(13,13,60), Vector(-13,-13,0))
	self.GrenadePulled = false
	self.BlowTime = 0
	self.IsPlayingSpecialAttack = false
	self.CustomWalkActivites = {VJ_SequenceToActivity(self,"walk_all_grenade")}
	self.CustomRunActivites = {VJ_SequenceToActivity(self,"walk_all_grenade")}
	self.IsSlumped = false
	self.SlumpAnimation = VJ_PICK({"slump_a","slump_b"})
	self.SlumpRise = (self.SlumpAnimation == "slump_a" && VJ_PICK({"slumprise_a","slumprise_a2","slumprise_a_attack"})) or "slumprise_b"
	if self.Slump then
		self.IsSlumped = true
		self:AddFlags(FL_NOTARGET)
		self.SoundTbl_Idle = {}
		self.AnimTbl_IdleStand = {self.SlumpAnimation}
		self.AnimTbl_MeleeAttack = {self.SlumpRise}
		self.SightDistance = 140
		self.SightAngle = 180
		self.MovementType = VJ_MOVETYPE_STATIONARY
		self.CanTurnWhileStationary = false
		self.HasMeleeAttack = false
		self.HasRangeAttack = false
		self.HasLeapAttack = false
		self.CanFlinch = 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UnSlump()
	self.IsSlumped = false
	self.AnimTbl_IdleStand = {ACT_IDLE}
	self:VJ_ACT_PLAYACTIVITY("vjseq_" .. self.SlumpRise,true,false,false)
	local animtime = self:SequenceDuration(self:LookupSequence(self.SlumpRise))
	self:RemoveFlags(FL_NOTARGET)
	self:SetArrivalActivity(ACT_IDLE)
	self.SoundTbl_Idle = {"npc/zombine/zombine_idle1.wav","npc/zombine/zombine_idle2.wav","npc/zombine/zombine_idle3.wav","npc/zombine/zombine_idle4.wav","npc/zombine/zombine_alert1.wav","npc/zombine/zombine_alert2.wav","npc/zombine/zombine_alert3.wav","npc/zombine/zombine_alert4.wav","npc/zombine/zombine_alert7.wav"}
	timer.Simple(animtime,function()
		if IsValid(self) then
			self:ResetSlump()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.IsSlumped then
		self:UnSlump()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self.IsSlumped then
		self:UnSlump()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetSlump()
	self.CanFlinch = 1
	self.SightDistance = 10000
	self.SightAngle = 80
	self.MovementType = VJ_MOVETYPE_GROUND
	self.HasMeleeAttack = true
	self.HasRangeAttack = false
	self.HasLeapAttack = false
	self.AnimTbl_MeleeAttack = {"FastAttack"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateGrenade()
	local grenent = ents.Create("npc_grenade_frag")
	grenent:SetModel("models/Items/grenadeAmmo.mdl")
	grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
	grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
	grenent:SetOwner(self)
	grenent:SetParent(self)
	grenent:Fire("SetParentAttachment","grenade_attachment",0)
	grenent:Spawn()
	grenent:Activate()
	grenent:Input("SetTimer",self:GetOwner(),self:GetOwner(),3.5)
	self.GrenadeTime = CurTime() +3.5
	-- grenent.VJHumanTossingAway = true // Soldiers kept stealing their grenades xD
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeCode()
	if self.GrenadePulled == true then return end
	self.GrenadePulled = true
	VJ_EmitSound(self,"npc/zombine/zombine_readygrenade"..math.random(1,2)..".wav",80,100)
	self:VJ_ACT_PLAYACTIVITY("pullGrenade",true,VJ_GetSequenceDuration(self,VJ_SequenceToActivity(self,"pullGrenade")))
	timer.Simple(VJ_GetSequenceDuration(self,VJ_SequenceToActivity(self,"pullGrenade")) -0.4,function()
		if self:IsValid() then
			self:CreateGrenade()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.IsSlumped then return end
	self.NextMeleeAttackTime = self.CurrentAttackAnimationDuration
	self.NextAnyAttackTime_Melee = self.CurrentAttackAnimationDuration

	if self.VJ_IsBeingControlled == false then
		if self:Health() < 40 && IsValid(self:GetEnemy()) && math.random(1,10) == 1 && self:GetEnemy():GetPos():Distance(self:GetPos()) < 500 then
			self:GrenadeCode()
		end
	else
		if self:Health() < 40 && self.VJ_TheController:KeyDown(IN_ATTACK2) then
			self.AnimTbl_IdleStand = {"Idle_Grenade"}
			self:GrenadeCode()
		end
	end

	if self:GetMovementActivity() == ACT_RUN then
		self.FootStepTimeRun = 0.3
	elseif self:GetMovementActivity() == ACT_WALK then
		self.FootStepTimeWalk = 0.55
	else
		self.FootStepTimeRun = 0.3
		self.FootStepTimeWalk = 0.55
	end

	if self.GrenadePulled == true then
		self.AnimTbl_IdleStand = {"Idle_Grenade"}
		self.AnimTbl_Run = {VJ_SequenceToActivity(self,"Run_All_grenade")}
		self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"walk_All_Grenade")}
	else
		self.AnimTbl_IdleStand = {ACT_IDLE}
		if IsValid(self:GetEnemy()) && self:GetEnemy():GetPos():Distance(self:GetPos()) < 1000 then
			self.AnimTbl_Walk = {ACT_RUN}
			self.AnimTbl_Run = {ACT_RUN}
		elseif IsValid(self:GetEnemy()) && self:GetEnemy():GetPos():Distance(self:GetPos()) > 1000 then
			self.AnimTbl_Walk = {ACT_WALK}
			self.AnimTbl_Run = {ACT_WALK}
		else
			self.AnimTbl_Walk = {ACT_WALK}
			self.AnimTbl_Run = {ACT_RUN}
		end
		self.AnimTbl_Walk = {ACT_WALK}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	if self:GetBodygroup(1) == 0 then return false end
	local randcrab = math.random(1,3)
	local dmgtype = dmginfo:GetDamageType()
	if hitgroup == HITGROUP_HEAD then randcrab = math.random(1,2) end
	if dmgtype == DMG_CLUB or dmgtype == DMG_SLASH then randcrab = 1 end
	if randcrab == 1 then
		self:SetBodygroup(1,1)
	end
	if randcrab == 2 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/headcrabclassic.mdl",{Pos=self:GetAttachment(self:LookupAttachment("headcrab")).Pos})
		self.Corpse:SetBodygroup(1,0)
	end
	if randcrab == 3 then
		self.Corpse:SetBodygroup(1,0)
		local spawncrab = ents.Create("npc_vj_hlr2_headcrab")
		local enemy = self:GetEnemy()
		local pos = self:GetAttachment(self:LookupAttachment("headcrab")).Pos
		spawncrab:SetPos(pos)
		spawncrab:SetAngles(self:GetAngles())
		spawncrab:SetVelocity(dmginfo:GetDamageForce()/58)
		spawncrab:Spawn()
		spawncrab:Activate()
		if self.Corpse:IsOnFire() then spawncrab:Ignite(math.Rand(8,10),0) end
		timer.Simple(0.05,function()
			if spawncrab != nil then
				spawncrab:SetPos(pos)
				if IsValid(enemy) then spawncrab:SetEnemy(enemy) spawncrab:SetSchedule(SCHED_CHASE_ENEMY) end
			end
		end)
	end

	if self.GrenadePulled == true && CurTime() < self.GrenadeTime then
		local grenent = ents.Create("npc_grenade_frag")
		grenent:SetModel("models/Items/grenadeAmmo.mdl")
		grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
		grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
		grenent:SetOwner(self)
		grenent:Spawn()
		grenent:Activate()
		grenent:Input("SetTimer",self:GetOwner(),self:GetOwner(),1.5)
	end
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
		self.DamageSpark1 = ents.Create("env_spark")
		self.DamageSpark1:SetKeyValue("Magnitude","1")
		self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
		self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
		self.DamageSpark1:SetAngles(self:GetAngles())
		//self.DamageSpark1:Fire("LightColor", "255 255 255")
		self.DamageSpark1:SetParent(self)
		self.DamageSpark1:Spawn()
		self.DamageSpark1:Activate()
		self.DamageSpark1:Fire("StartSpark", "", 0)
		self.DamageSpark1:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(self.DamageSpark1)
	end
	if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
	dmginfo:ScaleDamage(0.50)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/