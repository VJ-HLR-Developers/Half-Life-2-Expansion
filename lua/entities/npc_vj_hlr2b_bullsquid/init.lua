AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/bullsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.MeleeAttackDamage = 20
ENT.TimeUntilRangeAttackProjectileRelease = 0.8
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_antlionspit" -- The entity that is spawned when range attacking
ENT.RangeAttackExtraTimers = {0.8,0.8,0.8}
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.Aquatic_SwimmingSpeed_Calm = 200 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 300 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {ACT_SWIM} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {ACT_SWIM}
ENT.AA_ConstantlyMove = true

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bullsquid.Head_Bone1", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(8, 0, 5), -- The offset for the controller when the camera is in first person
}

ENT.Accuracy = 30
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(40, 40 , 40), Vector(-40, -40, 0))
	self.SoundTbl_FootStep = {"npc/zombie_poison/pz_left_foot1.wav"}
	self.SoundTbl_Idle = {
		"vj_hlr/hl2_npc/bullsquid/idle1.wav",
		"vj_hlr/hl2_npc/bullsquid/idle2.wav",
		"vj_hlr/hl2_npc/bullsquid/idle3.wav",
		"vj_hlr/hl2_npc/bullsquid/idle4.wav",
		"vj_hlr/hl2_npc/bullsquid/idle5.wav",
		"vj_hlr/hl2_npc/bullsquid/snort1.wav",
		"vj_hlr/hl2_npc/bullsquid/snort2.wav",
		"vj_hlr/hl2_npc/bullsquid/snort3.wav",
	}
	self.SoundTbl_Alert = {"vj_hlr/hl2_npc/bullsquid/excited1.wav"}
	self.SoundTbl_BeforeMeleeAttack = {
		"vj_hlr/hl2_npc/bullsquid/attack2.wav",
		"vj_hlr/hl2_npc/bullsquid/attackgrowl1.wav",
		"vj_hlr/hl2_npc/bullsquid/attackgrowl2.wav",
		"vj_hlr/hl2_npc/bullsquid/attackgrowl3.wav",
	}
	self.SoundTbl_MeleeAttack = {}
	self.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl2_npc/bullsquid/tail_whip1.wav"}
	self.SoundTbl_RangeAttack = {
		"vj_hlr/hl2_npc/bullsquid/attack1.wav",
		"vj_hlr/hl2_npc/bullsquid/attack3.wav",
	}
	self.SoundTbl_Pain = {
		"vj_hlr/hl2_npc/bullsquid/pain1.wav",
		"vj_hlr/hl2_npc/bullsquid/pain2.wav",
		"vj_hlr/hl2_npc/bullsquid/pain3.wav",
		"vj_hlr/hl2_npc/bullsquid/pain4.wav",
	}
	self.SoundTbl_Death = {
		"vj_hlr/hl2_npc/bullsquid/die1.wav",
		"vj_hlr/hl2_npc/bullsquid/die2.wav",
		"vj_hlr/hl2_npc/bullsquid/die3.wav",
	}
	self.CustomBlood_Decal = {"VJ_Blood_Yellow"}
	self.HasBloodPool = true
	self.tbl_Headcrabs = {
		"npc_vj_hlr1_headcrab",
		"npc_vj_hlr1_headcrab_baby",
		"npc_headcrab",
		"npc_headcrab_black",
		"npc_headcrab_fast",
		"npc_vj_hlr2_headcrab",
		"npc_vj_hlr2_headcrab_fast",
		"npc_vj_hlr2_headcrab_poison",
		"npc_vj_hlr2b_headcrab",
		"npc_vj_hlr2b_headcrab_fast",
		"npc_vj_hlr2b_headcrab_poison",
	}
	self:ManipulateBoneJiggle(3,1)
	self:ManipulateBoneJiggle(4,1)
	self:ManipulateBoneJiggle(5,1)
	self:ManipulateBoneJiggle(6,1)
	self:ManipulateBoneJiggle(7,1)
	self:ManipulateBoneJiggle(8,1)
	self:ManipulateBoneJiggle(9,1)
	self:ManipulateBoneJiggle(10,1)
	self:ManipulateBoneJiggle(11,1)
	self:ManipulateBoneJiggle(12,1)
	self:ManipulateBoneJiggle(13,1)
	self:ManipulateBoneJiggle(14,1)
	self:ManipulateBoneJiggle(15,1)
	self:ManipulateBoneJiggle(16,1)
	self:ManipulateBoneJiggle(17,1)
	self:ManipulateBoneJiggle(18,1)
	self:ManipulateBoneJiggle(19,1)
	self:ManipulateBoneJiggle(20,1)
	self:ManipulateBoneJiggle(21,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "attack" then
		self:MeleeAttackCode()
	end
	-- if key == "range" then
		-- self:RangeAttackCode()
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:WaterLevel() > 1 then
		if self.MovementType != VJ_MOVETYPE_AQUATIC then
			self:DoChangeMovementType(VJ_MOVETYPE_AQUATIC)
		end
		self.HasMeleeAttack = false
		self.HasRangeAttack = false
		if IsValid(self:GetEnemy()) && self:GetEnemy():WaterLevel() < 3 then
			self:AA_MoveTo(self:GetEnemy(),true)
		end
	else
		if self.MovementType != VJ_MOVETYPE_GROUND then
			self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
		end
		self.HasMeleeAttack = true
		self.HasRangeAttack = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Curve", self:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() +VectorRand() *self.Accuracy, 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self:WaterLevel() < 2 then
		if VJ_HasValue(self.tbl_Headcrabs,ent:GetClass()) && math.random(1,2) == 1 then
			self:VJ_ACT_PLAYACTIVITY("hc_spot",true,false,true)
		else
			if math.random(1,3) == 1 then
				self:VJ_ACT_PLAYACTIVITY(ACT_HOP,true,false,true)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_MoveTo(Ent,ShouldPlayAnim,vAdditionalFeatures)
	if !IsValid(Ent) then return end
	vAd_AdditionalFeatures = vAdditionalFeatures or {}
	vAd_PosForward = vAd_AdditionalFeatures.PosForward or 1 -- This will add the given value to the set position's forward
	vAd_PosUp = vAd_AdditionalFeatures.PosUp or 1 -- This will add the given value to the set position's up
	vAd_PosRight = vAd_AdditionalFeatures.PosRight or 1 -- This will add the given value to the set position's right
	local MoveSpeed = self.Aerial_FlyingSpeed_Calm
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if Debug == true then
			print("--------")
			print("ME WL: "..self:WaterLevel())
			print("Move To Pos WL: "..Ent:WaterLevel())
		end
		if self:WaterLevel() <= 1 && self:GetVelocity():Length() > 0 then self:AA_IdleWander(true,true) return end
		if Ent:WaterLevel() <= 1 then -- Yete 0-en ver e, ere vor nayi yete gerna teshanmi-in gerna hasnil
			local trene = util.TraceLine({
				start = Ent:GetPos() + self:OBBCenter(),
				endpos = (Ent:GetPos() + self:OBBCenter()) + Ent:GetUp()*-20,
				filter = self,
				mins = self:OBBMins(),
				maxs = self:OBBMaxs()
			})
			if trene.Hit == true then return end
		end
		MoveSpeed = self.Aquatic_SwimmingSpeed_Alerted
	end
	
	local Debug = self.AA_EnableDebug
	ShouldPlayAnim = ShouldPlayAnim or false
	NoFace = NoFace or false

	if ShouldPlayAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = "Calm"
	else
		self.AA_CanPlayMoveAnimation = false
	end
	
	local vel_for = 1
	local vel_stop = false
	local nearpos = self:VJ_GetNearestPointToEntity(Ent)
	local startpos = nearpos.MyPosition // self:GetPos()
	local endpos = nearpos.EnemyPosition // Ent:GetPos()+Ent:OBBCenter()
	local tr = util.TraceHull({
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs()
	})
	local tr_hitpos = tr.HitPos
	local dist_selfhit = startpos:Distance(tr_hitpos)
	if Debug == true then util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr_hitpos,false,self:EntIndex(),0) end //vortigaunt_beam
	if dist_selfhit <= 16 && tr.HitWorld == true then
		if Debug == true then print("AA: Forward Blocked! [CHASE]") end
		vel_for = 1
	end
	local enepos = (Ent:GetPos() + Ent:OBBCenter()) + Ent:GetForward()*vAd_PosForward + Ent:GetUp()*vAd_PosUp + Ent:GetRight()*vAd_PosRight
	if self.MovementType == VJ_MOVETYPE_AQUATIC && Ent:WaterLevel() < 3 then
		enepos = Ent:GetPos() + Ent:GetForward()*vAd_PosForward + Ent:GetUp()*vAd_PosUp + Ent:GetRight()*vAd_PosRight
	end
	local vel_up = MoveSpeed
	local dist_selfhit_z = enepos.z - startpos.z -- Get the distance between the hit position and the start position
	if dist_selfhit_z > 0 then -- Yete 0-en ver e, ere vor 20-en minchev sahmani tive hasni
		if Debug == true then print("AA: GOING UP [CHASE]") end
		vel_up = math.Clamp(dist_selfhit_z, 20, MoveSpeed)
	elseif dist_selfhit_z < 0 then -- Yete 0-en var e, ere vor nevaz 20-en minchev nevaz sahmani tive hasni
		if Debug == true then print("AA: GOING DOWN [CHASE]") end
		vel_up = -math.Clamp(math.abs(dist_selfhit_z), 20, MoveSpeed)
	else
		vel_up = 0
	end
	if dist_selfhit < 100 then -- Yete 100-en var e tive, esel e vor modig e, ere vor gamatsna
		MoveSpeed = math.Clamp(dist_selfhit, 100, MoveSpeed)
	end
	if vel_stop == false then
		local vel_set = ((enepos) - (self:GetPos() + self:OBBCenter())):GetNormal()*MoveSpeed + self:GetUp()*vel_up + self:GetForward()*vel_for
		self.AA_CurrentTurnAng = self:GetFaceAngle(self:GetFaceAngle((vel_set):Angle()))
		self:SetLocalVelocity(vel_set)
		local vel_len = CurTime() + (tr.HitPos:Distance(startpos) / vel_set:Length())
		self.AA_MoveLength_Wander = 0
		if vel_len == vel_len then -- Check for NaN
			self.AA_MoveLength_Chase = vel_len
			self.NextIdleTime = vel_len
		end
		if Debug == true then ParticleEffect("vj_impact1_centaurspit", enepos, Angle(0,0,0), self) end
	else
		self:AA_StopMoving()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/