AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/hunter.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
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
ENT.MeleeAttackDistance = 70 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 130 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1
ENT.MeleeAttackBleedEnemyDamage = 3
ENT.SlowPlayerOnMeleeAttack = true

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE -- Death Animations

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
			local pickanim = VJ.PICK(ally.AnimTbl_CallForHelp)
			ally:VJ_ACT_PLAYACTIVITY(pickanim,ally.CallForHelpStopAnimations,ally:DecideAnimationLength(pickanim,ally.CallForHelpStopAnimationsTime),ally.CallForHelpAnimationFaceEnemy,0,{PlayBackRateCalculated=true})
			ally.NextCallForHelpAnimationT = CurTime() +ally.NextCallForHelpAnimationTime
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(18,18,100),Vector(-18,-18,0))
	-- self:CreateBoneFollowers()

	self.Shots = 0
	self.CurrentEye = 4

	self.DoRangeAttack = false
	self.IsPlanted = false

	self.LastSawEnemyPosition = nil

	self.NextRangeT = CurTime() +1
	self.NextShootAnimT = 0
	self.NextShootT = 0
	self.NextRandMoveT = 0

	self.ChargeAnimationCache = VJ.SequenceToActivity(self,"charge_loop")
	self.IsCharging = false
	self.ChargeT = 0

	self:SetStepHeight(28)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FireFlechette()
	if self.Shots < 12 then
		local targetPos = IsValid(self:GetEnemy()) && self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() or self:GetPos() +self:GetForward() *400 +VectorRand(-1,1) *math.Rand(0,100)
		local proj = ents.Create("obj_vj_hlr2_flechette")
		proj:SetPos(self:GetAttachment(self.CurrentEye).Pos)
		proj:SetAngles((targetPos -self:GetAttachment(self.CurrentEye).Pos):Angle())
		proj:Spawn()
		proj:Activate()
		proj:SetOwner(self)
		proj:SetPhysicsAttacker(self)
		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			local vel = self:RangeAttackProjVelocity(proj)
			phys:Wake()
			phys:SetVelocity(vel)
			proj:SetAngles(vel:GetNormal():Angle())
		end

		VJ.EmitSound(self,"^npc/ministrider/ministrider_fire1.wav",105,100)
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

		if self.CurrentEye == 4 then
			self.CurrentEye = 5
		else
			self.CurrentEye = 4
		end
		self.Shots = self.Shots +1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	-- print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	elseif key == "range" then
		self:FireFlechette()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	local ent = self:GetEnemy()
	local targetPos
	if IsValid(ent) && ent:Visible(self) then
		targetPos = ent:GetPos() +ent:OBBCenter()
	else
		targetPos = self.EnemyData && self.EnemyData.LastVisiblePos or projectile:GetPos() +projectile:GetForward() *1000
	end
	targetPos = targetPos +VectorRand(-35,35)
	return self:CalculateProjectile("Line",projectile:GetPos(),targetPos,self.Flechette_Speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:IsBulletDamage() then
		dmginfo:ScaleDamage(dmginfo:GetDamageType() == DMG_BUCKSHOT && 0.5 or 0.6)
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
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if self.IsPlanted then
			return ACT_RANGE_ATTACK2
		elseif self.IsCharging then
			return self.ChargeAnimationCache
		end
	elseif (act == ACT_WALK or act == ACT_RUN) then
		if self.IsCharging then
			return self.ChargeAnimationCache
		end
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local dist = self.NearestPointToEnemyDistance

	if self.IsCharging && !self:IsBusy() then
		if CurTime() > self.ChargeT then
			self:SetMaxYawSpeed(self.TurningSpeed)
			self.IsCharging = false
			self.ChargeT = 0
			self.DisableChasingEnemy = false
			self.HasMeleeAttack = true
			self:CapabilitiesAdd(CAP_MOVE_JUMP)
			self:SetState()
			self:VJ_ACT_PLAYACTIVITY("charge_miss_slide",true,false,false)
			return
		end

		self.DisableChasingEnemy = true
		self.HasMeleeAttack = false
		self:SetMaxYawSpeed(2)
		self:SetTurnTarget("Enemy",0.2)
		local tr = util.TraceHull({
			start = self:GetPos() +self:OBBCenter(),
			endpos = self:GetPos() +self:OBBCenter() +self:GetForward() *100,
			filter = self,
			mins = self:OBBMins() *0.85,
			maxs = self:OBBMaxs() *0.85,
		})
		self:SetLastPosition(tr.HitPos +tr.HitNormal *200)
		self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.FaceData = {Type = VJ.NPC_FACE_ENEMY} end)
		if self:OnGround() then
			self:SetVelocity(self:GetMoveVelocity() *1.01)
		end
		if tr.Hit then
			self:SetMaxYawSpeed(self.TurningSpeed)
			self.IsCharging = false
			self.ChargeT = 0
			self.HasMeleeAttack = true
			self.DisableChasingEnemy = false
			self:CapabilitiesAdd(CAP_MOVE_JUMP)
			self:SetState()
			if tr.HitWorld then
				self:VJ_ACT_PLAYACTIVITY("charge_crash",true,false,false)
				util.ScreenShake(self:GetPos(),1000,100,1,500)
			else
				self:VJ_ACT_PLAYACTIVITY("charge_miss_slide",true,false,false)
				local ent = tr.Entity
				local isProp = IsValid(ent) && VJ.IsProp(ent) or false
				if IsValid(ent) && (isProp or self:CheckRelationship(ent) == D_HT) then
					if isProp then
						local phys = ent:GetPhysicsObject()
						if IsValid(phys) then
							phys:ApplyForceCenter(self:GetForward() *1000 +self:GetUp() *200)
						end
					else
						local vel = self:GetForward() *600 +self:GetUp() *200
						ent:SetGroundEntity(NULL)
						ent:SetVelocity(vel)
					end
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(20)
					dmginfo:SetDamageType(bit.bor(DMG_CRUSH,DMG_SLASH))
					dmginfo:SetDamageForce(self:GetForward() *1000)
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamagePosition(tr.HitPos)
					ent:TakeDamageInfo(dmginfo)
				end
			end
			-- PrintTable(tr)
			-- VJ.DEBUG_TempEnt(tr.HitPos, self:GetAngles(), Color(255,0,0), 5)
		end
		return
	end

	if self.DoRangeAttack then
		if self.Shots >= 12 then
			self.NextRangeT = CurTime() +math.Rand(3,6)
			self.DoRangeAttack = false
			self.IsPlanted = false
			self.HasMeleeAttack = true
			self:VJ_ACT_PLAYACTIVITY("vjseq_unplant",true,false,true, 0, {OnFinish=function(interrupted, anim)
				if interrupted then
					return
				end
				self:SetState()
			end})
			return
		end
		if !self.IsPlanted && !self:IsBusy() then
			self:SetState(VJ_STATE_ONLY_ANIMATION)
			self:VJ_ACT_PLAYACTIVITY("vjseq_plant",true,false,true, 0, {OnFinish=function(interrupted, anim)
				if interrupted then
					return
				end
				self.IsPlanted = true
			end})
		elseif self.IsPlanted && CurTime() > self.NextShootT then
			self:FireFlechette()
			self.NextShootT = CurTime() +0.07
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack(ent,vis)
	if self.IsCharging then return end

	local dist = self.NearestPointToEnemyDistance
	if vis then
		if !self.VJ_IsBeingControlled && !self:IsBusy() && CurTime() > self.NextRandMoveT && !self.DoRangeAttack && dist > 400 then
			local checkdist = self:VJ_CheckAllFourSides(400)
			local randmove = {}
			if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
			if checkdist.Right == true then randmove[#randmove+1] = "Right" end
			if checkdist.Left == true then randmove[#randmove+1] = "Left" end
			local pickmove = VJ.PICK(randmove)
			if pickmove == "Backward" then self:SetLastPosition(self:GetPos() +self:GetForward() *400) end
			if pickmove == "Right" then self:SetLastPosition(self:GetPos() +self:GetRight() *400) end
			if pickmove == "Left" then self:SetLastPosition(self:GetPos() +self:GetRight() *400) end
			if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
				self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.FaceData = {Type = VJ.NPC_FACE_ENEMY} end)
				self.NextRandMoveT = CurTime() +math.Rand(2,3)
				return
			end
		end

		if dist > 500 && dist <= 2500 && !self.IsCharging && !self:IsBusy() && !self.DoRangeAttack && (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) or !self.VJ_IsBeingControlled && math.random(1,50) == 1) && math.abs(self:GetPos().z -ent:GetPos().z) <= 128 then
			self:VJ_ACT_PLAYACTIVITY("charge_start",true,false,true, 0, {OnFinish=function(interrupted, anim)
				if interrupted then
					return
				end
				self:CapabilitiesRemove(CAP_MOVE_JUMP)
			end})
			self.IsCharging = true
			-- self:SetState(VJ_STATE_ONLY_ANIMATION)
			self.ChargeT = CurTime() +6
			return
		end
	end

	if self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK2) && !self.DoRangeAttack && !self.IsCharging or !self.VJ_IsBeingControlled && !self.IsCharging && CurTime() > self.NextRangeT && !self.DoRangeAttack && dist > 250 && dist <= 2200 then
		if !self:VisibleVec(self.EnemyData && self.EnemyData.LastVisiblePos or ent:GetPos() +ent:OBBCenter()) then return end
		self.Shots = 0
		self.DoRangeAttack = true
		self.HasMeleeAttack = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
local angY45 = Angle(0, 45, 0)
local angY45 = Angle(0, 45, 0)
local angYN45 = Angle(0, -45, 0)
local angY90 = Angle(0, 90, 0)
local angYN90 = Angle(0, -90, 0)
local angY135 = Angle(0, 135, 0)
local angYN135 = Angle(0, -135, 0)
local angY180 = Angle(0, 180, 0)
--
function ENT:Controller_Movement(cont, ply, bullseyePos)
	if self.MovementType != VJ_MOVETYPE_STATIONARY then
		local gerta_lef = ply:KeyDown(IN_MOVELEFT)
		local gerta_rig = ply:KeyDown(IN_MOVERIGHT)
		local gerta_arak = ply:KeyDown(IN_SPEED)
		local aimVector = ply:GetAimVector()
		local FT = FrameTime() *(self.TurningSpeed *1.25)

		self.VJC_Data.TurnAngle = self.VJC_Data.TurnAngle or defAng

		if self.IsCharging then
			return
		end
		
		if ply:KeyDown(IN_FORWARD) then
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				self:AA_MoveTo(cont.VJCE_Bullseye, true, gerta_arak and "Alert" or "Calm", {IgnoreGround=true})
			else
				-- if gerta_lef then
				-- 	cont:StartMovement(aimVector, angY45)
				-- elseif gerta_rig then
				-- 	cont:StartMovement(aimVector, angYN45)
				-- else
				-- 	cont:StartMovement(aimVector, defAng)
				-- end
				self.VJC_Data.TurnAngle = LerpAngle(FT, self.VJC_Data.TurnAngle, gerta_lef && angY45 or gerta_rig && angYN45 or defAng)
				cont:StartMovement(aimVector, self.VJC_Data.TurnAngle)
			end
		elseif ply:KeyDown(IN_BACK) then
			-- if gerta_lef then
			-- 	cont:StartMovement(aimVector*-1, angYN45)
			-- elseif gerta_rig then
			-- 	cont:StartMovement(aimVector*-1, angY45)
			-- else
			-- 	cont:StartMovement(aimVector*-1, defAng)
			-- end
			self.VJC_Data.TurnAngle = LerpAngle(FT, self.VJC_Data.TurnAngle, gerta_lef && angY135 or gerta_rig && angYN135 or angY180)
			cont:StartMovement(aimVector, self.VJC_Data.TurnAngle)
		elseif gerta_lef then
			-- cont:StartMovement(aimVector, angY90)
			self.VJC_Data.TurnAngle = LerpAngle(FT, self.VJC_Data.TurnAngle, angY90)
			cont:StartMovement(aimVector, self.VJC_Data.TurnAngle)
		elseif gerta_rig then
			-- cont:StartMovement(aimVector, angYN90)
			self.VJC_Data.TurnAngle = LerpAngle(FT, self.VJC_Data.TurnAngle, angYN90)
			cont:StartMovement(aimVector, self.VJC_Data.TurnAngle)
		else
			self:StopMoving()
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				self:AA_StopMoving()
			end
		end
	end
end