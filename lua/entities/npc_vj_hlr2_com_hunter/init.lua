AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/hunter.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 210
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "White" -- The blood type, this will determine what it should use (decal, particle, etc.)

ENT.CallForHelpDistance = 6000
ENT.AnimTbl_CallForHelp = {"hunter_respond_1","hunter_respond_3"}

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {
	"meleert",
	"meleeleft",
	"melee_02",
	"melee_02",
	"melee_02",
	"melee_02",
}
ENT.MeleeAttackDamage = 20
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 70 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 130 -- How far does the damage go?
ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1
ENT.MeleeAttackBleedEnemyDamage = 3
ENT.SlowPlayerOnMeleeAttack = true

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "MiniStrider.body_joint", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(18, 0, -5), -- The offset for the controller when the camera is in first person
}

ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
-- ENT.SoundTbl_Breath = {"npc/combine_gunship/gunship_engine_loop3.wav"}
ENT.SoundTbl_FootStep = {
	"npc/ministrider/ministrider_footstep1.wav",
	"npc/ministrider/ministrider_footstep2.wav",
	"npc/ministrider/ministrider_footstep3.wav",
	"npc/ministrider/ministrider_footstep4.wav",
	"npc/ministrider/ministrider_footstep5.wav",
}
ENT.SoundTbl_Idle = {
	"npc/ministrider/hunter_idle1.wav",
	"npc/ministrider/hunter_idle2.wav",
	"npc/ministrider/hunter_idle3.wav",
}
ENT.SoundTbl_CombatIdle = {
	"npc/ministrider/hunter_angry1.wav",
	"npc/ministrider/hunter_angry2.wav",
	"npc/ministrider/hunter_angry3.wav",
}
ENT.SoundTbl_Alert = {
	"npc/ministrider/hunter_alert1.wav",
	"npc/ministrider/hunter_alert2.wav",
	"npc/ministrider/hunter_alert3.wav",
}
ENT.SoundTbl_CallForHelp = {
	"npc/ministrider/hunter_foundenemy1.wav",
	"npc/ministrider/hunter_foundenemy2.wav",
	"npc/ministrider/hunter_foundenemy3.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"npc/ministrider/hunter_foundenemy_ack1.wav",
	"npc/ministrider/hunter_foundenemy_ack2.wav",
	"npc/ministrider/hunter_foundenemy_ack3.wav",
}
ENT.SoundTbl_Investigate = {
	"npc/ministrider/hunter_scan1.wav",
	"npc/ministrider/hunter_scan2.wav",
	"npc/ministrider/hunter_scan3.wav",
	"npc/ministrider/hunter_scan4.wav",
}
ENT.SoundTbl_LostEnemy = {
	"npc/ministrider/hunter_scan1.wav",
	"npc/ministrider/hunter_scan2.wav",
	"npc/ministrider/hunter_scan3.wav",
	"npc/ministrider/hunter_scan4.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"npc/ministrider/hunter_laugh1.wav",
	"npc/ministrider/hunter_laugh2.wav",
	"npc/ministrider/hunter_laugh3.wav",
	"npc/ministrider/hunter_laugh4.wav",
	"npc/ministrider/hunter_laugh5.wav",
}
ENT.SoundTbl_Pain = {
	"npc/ministrider/hunter_pain2.wav",
	"npc/ministrider/hunter_pain4.wav",
}
ENT.SoundTbl_AllyDeath = {
	"npc/ministrider/hunter_defendstrider1.wav",
	"npc/ministrider/hunter_defendstrider2.wav",
	"npc/ministrider/hunter_defendstrider3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/ministrider/hunter_prestrike1.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/ministrider/ministrider_skewer1.wav"}
ENT.SoundTbl_Death = {
	"npc/ministrider/hunter_die2.wav",
	"npc/ministrider/hunter_die3.wav",
}

ENT.IdleSoundLevel = 90
ENT.AlertSoundLevel = 95
ENT.PainSoundLevel = 90
ENT.GeneralSoundPitch1 = 100
ENT.Flechette_Speed = 3000
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
	if ally:GetClass() == self:GetClass() then
		if !ally:BusyWithActivity() && !IsValid(ally:GetEnemy()) then
			ally:PlaySoundSystem("CallForHelp")
			local pickanim = VJ_PICK(ally.AnimTbl_CallForHelp)
			ally:VJ_ACT_PLAYACTIVITY(pickanim,ally.CallForHelpStopAnimations,ally:DecideAnimationLength(pickanim,ally.CallForHelpStopAnimationsTime),ally.CallForHelpAnimationFaceEnemy,ally.CallForHelpAnimationDelay,{PlayBackRate=ally.CallForHelpAnimationPlayBackRate,PlayBackRateCalculated=true})
			ally.NextCallForHelpAnimationT = CurTime() +ally.NextCallForHelpAnimationTime
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(18,18,100),Vector(-18,-18,0))

	self.Shots = 0
	self.CurrentEye = 4

	self.DoRangeAttack = false
	self.IsPlanted = false

	self.LastSawEnemy = NULL
	self.LastSawEnemyPosition = nil

	self.NextRangeT = CurTime() +1
	self.NextShootAnimT = 0
	self.NextShootT = 0
	self.NextRandMoveT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local a = dmginfo:GetAttacker()
	if IsValid(a) && a:GetClass() == self:GetClass() then
		dmginfo:SetDamage(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FireFlechette()
	if self.Shots < 12 then
		local proj = ents.Create("hunter_flechette")
		proj:SetPos(self:GetAttachment(self.CurrentEye).Pos)
		proj:SetAngles((self.LastSawEnemyPosition -self:GetAttachment(self.CurrentEye).Pos):Angle())
		proj:Spawn()
		proj:Activate()
		proj:SetOwner(self)
		proj:SetPhysicsAttacker(self)
		proj:SetVelocity(self:RangeAttackCode_GetShootPos(proj))
		VJ_EmitSound(self,"npc/ministrider/ministrider_fire1.wav",105,100)
		ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,self.CurrentEye)
		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", "4")
		FireLight1:SetKeyValue("distance", "120")
		FireLight1:SetPos(self:GetAttachment(self.CurrentEye).Pos)
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", "0 31 225")
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)
		self:SetEye()
		self.Shots = self.Shots +1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetEye()
	if self.CurrentEye == 4 then
		self.CurrentEye = 5
	else
		self.CurrentEye = 4
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	-- print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "range" then
		self:FireFlechette()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line",self:GetPos(),self.LastSawEnemyPosition +Vector(0,0,-50),self.Flechette_Speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:IsBulletDamage() then
		dmginfo:SetDamage(dmginfo:GetDamage() *0.6)
		self.DamageSpark1 = ents.Create("env_spark")
		self.DamageSpark1:SetKeyValue("Magnitude","1")
		self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
		self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
		self.DamageSpark1:SetAngles(self:GetAngles())
		self.DamageSpark1:SetParent(self)
		self.DamageSpark1:Spawn()
		self.DamageSpark1:Activate()
		self.DamageSpark1:Fire("StartSpark", "", 0)
		self.DamageSpark1:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(self.DamageSpark1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.HasMeleeAttack = !self.DoRangeAttack
	if !self.VJ_IsBeingControlled then
		if CurTime() > self.NextRangeT && !self.DoRangeAttack then
			if IsValid(self:GetEnemy()) then
				if self:GetEnemy():Visible(self) then
					self.LastSawEnemy = self:GetEnemy()
				end
				local dist = self:GetEnemy():GetPos():Distance(self:GetPos())
				if dist <= 3000 && dist > 175 && self.LastSawEnemy == self:GetEnemy() && self.LastSawEnemyPosition != nil && self:VisibleVec(self.LastSawEnemyPosition)/*self:GetEnemy():Visible(self)*/ then
					self.Shots = 0
					self.DoRangeAttack = true
				end
			end
		end
		if IsValid(self:GetEnemy()) && self:GetEnemy():Visible(self) then
			self.LastSawEnemyPosition = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
			local dist = self:GetEnemy():GetPos():Distance(self:GetPos())
			self.DisableChasingEnemy = dist < 3000 && dist > 400
			if CurTime() > self.NextRandMoveT && !self.DoRangeAttack && self.DisableChasingEnemy == true then
				local checkdist = self:VJ_CheckAllFourSides(400)
				local randmove = {}
				if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
				if checkdist.Right == true then randmove[#randmove+1] = "Right" end
				if checkdist.Left == true then randmove[#randmove+1] = "Left" end
				local pickmove = VJ_PICK(randmove)
				if pickmove == "Backward" then self:SetLastPosition(self:GetPos() +self:GetForward() *400) end
				if pickmove == "Right" then self:SetLastPosition(self:GetPos() +self:GetRight() *400) end
				if pickmove == "Left" then self:SetLastPosition(self:GetPos() +self:GetRight() *400) end
				if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.ConstantlyFaceEnemy = true end)
					self.NextRandMoveT = CurTime() +math.Rand(2,3)
				end
			end
		else
			self.DisableChasingEnemy = false
		end
	else
		if IsValid(self:GetEnemy()) then
			self.LastSawEnemy = self:GetEnemy()
			self.LastSawEnemyPosition = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
		end
		if self.VJ_TheController:KeyDown(IN_ATTACK2) then
			if CurTime() > self.NextRangeT && !self.DoRangeAttack then
				self.Shots = 0
				self.DoRangeAttack = true
			end
		end
	end
	if self.DoRangeAttack then
		if self.Dead then return end
		if self.Shots >= 12 then
			self.NextRangeT = CurTime() +math.Rand(3,6)
			self.DoRangeAttack = false
			self.IsPlanted = false
			return
		end
		if !self.IsPlanted && self:GetSequenceName(self:GetSequence()) != "plant" then
			self:VJ_ACT_PLAYACTIVITY("vjseq_plant",true,false,true)
			timer.Simple(self:SequenceDuration(self:LookupSequence("plant")),function() if IsValid(self) then self.IsPlanted = true end end)
		end
		if self.IsPlanted && CurTime() > self.NextShootAnimT then
			self:VJ_ACT_PLAYACTIVITY(ACT_GESTURE_RANGE_ATTACK2,true,false,true)
			self.NextShootAnimT = CurTime() +self:SequenceDuration(self:LookupSequence("shoot_unplanted")) -0.1
		end
		if self.IsPlanted && CurTime() > self.NextShootT then
			self:FireFlechette()
			self.NextShootT = CurTime() +0.08
		end
	end
end