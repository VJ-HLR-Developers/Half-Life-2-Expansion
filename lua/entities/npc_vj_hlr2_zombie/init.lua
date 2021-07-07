AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/zombie.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_green_01"}
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.MeleeAttackDamage = 18
ENT.TimeUntilMeleeAttackDamage = 1
ENT.FootStepTimeRun = 0.38 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.38 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "ValveBiped.HC_Body_Bone", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 4, 0), -- The offset for the controller when the camera is in first person
}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
-- ENT.SoundTbl_Breath = {"npc/fast_zombie/breathe_loop1.wav"}
ENT.SoundTbl_Alert = {"npc/zombie/zombie_alert1.wav","npc/zombie/zombie_alert2.wav","npc/zombie/zombie_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack1.wav","npc/zombie/zo_attack2.wav"}
ENT.SoundTbl_Pain = {"npc/zombie/zombie_pain1.wav","npc/zombie/zombie_pain2.wav","npc/zombie/zombie_pain3.wav","npc/zombie/zombie_pain4.wav","npc/zombie/zombie_pain5.wav","npc/zombie/zombie_pain6.wav"}
ENT.SoundTbl_Death = {"npc/zombie/zombie_die1.wav","npc/zombie/zombie_die2.wav","npc/zombie/zombie_die3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0,8))
	self:SetBodygroup(1,1)
	-- self:SetCollisionBounds(Vector(13,13,60), Vector(-13,-13,0))
	self.IsPlayingSpecialAttack = false
	self.IsSlumped = false
	self.SlumpAnimation = VJ_PICK({"slump_a","slump_b"})
	self.SlumpRise = (self.SlumpAnimation == "slump_a" && VJ_PICK({"slumprise_a","slumprise_a2","slumprise_a_attack"})) or "slumprise_b"
	if self.Slump then
		self.IsSlumped = true
		self:AddFlags(FL_NOTARGET)
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
	if self.ZInit then self:ZInit() end
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
	else
		if math.random(1,3) == 1 then self:VJ_ACT_PLAYACTIVITY("Tanturm",true,false,true) end
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
	self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
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
end