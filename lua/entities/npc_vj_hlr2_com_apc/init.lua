AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/overwatch_apc.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table 
ENT.StartHealth = 750
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 40, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "APC.Gun_Base", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 50), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.DeathCorpseModel = {"models/combine_apc_destroyed_gib01.mdl"} -- Model(s) to spawn as the NPC's corpse | false = Use the NPC's model | Can be a single string or a table of strings

ENT.SoundTbl_Breath = {"vehicles/apc/apc_idle1.wav"}
ENT.SoundTbl_Idle = {
	"npc/overwatch/radiovoice/accomplicesoperating.wav",
	"npc/overwatch/radiovoice/politistablizationmarginal.wav",
	"npc/overwatch/radiovoice/reminder100credits.wav",
	"npc/overwatch/radiovoice/remindermemoryreplacement.wav",
	"npc/overwatch/radiovoice/reporton.wav",
	"npc/overwatch/radiovoice/reportplease.wav",
	"npc/overwatch/radiovoice/rewardnotice.wav",
	"npc/overwatch/radiovoice/teamsreportstatus.wav",
}
ENT.SoundTbl_CombatIdle = {
	"npc/overwatch/radiovoice/engagingteamisnoncohesive.wav",
	"npc/overwatch/radiovoice/failuretotreatoutbreak.wav",
	"npc/overwatch/radiovoice/promotingcommunalunrest.wav",
	"npc/overwatch/radiovoice/publicnoncompliance507.wav",
	"npc/overwatch/radiovoice/resistingpacification148.wav",
	"npc/overwatch/radiovoice/restrictedincursioninprogress.wav",
	"npc/overwatch/radiovoice/riot404.wav",
	"npc/overwatch/radiovoice/socialfractureinprogress.wav",
	"npc/overwatch/radiovoice/youarechargedwithterminal.wav",
	"npc/overwatch/radiovoice/youarejudgedguilty.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"npc/overwatch/radiovoice/beginscanning10-0.wav",
	"npc/overwatch/radiovoice/officerclosingonsuspect.wav",
}
ENT.SoundTbl_LostEnemy = {
	"npc/overwatch/radiovoice/allunitsreturntocode12.wav",
	"npc/overwatch/radiovoice/disengaged647e.wav",
	"npc/overwatch/radiovoice/recievingconflictingdata.wav",
	"npc/overwatch/radiovoice/recklessoperation99.wav",
	"npc/overwatch/radiovoice/switchcomtotac3.wav",
}
ENT.SoundTbl_Investigate = {
	"npc/overwatch/radiovoice/allunitsbolfor243suspect.wav",
	"npc/overwatch/radiovoice/investigateandreport.wav",
	"npc/overwatch/radiovoice/recalibratesocioscan.wav",
	"npc/overwatch/radiovoice/statuson243suspect.wav",
	"npc/overwatch/radiovoice/suspendnegotiations.wav",
	"npc/overwatch/radiovoice/switchtotac5reporttocp.wav",
}
ENT.SoundTbl_Alert = {
	"npc/overwatch/radiovoice/allunitsbeginwhitnesssterilization.wav",
	"npc/overwatch/radiovoice/allunitsdeliverterminalverdict.wav",
	"npc/overwatch/radiovoice/attemptedcrime27.wav",
	"npc/overwatch/radiovoice/completesentencingatwill.wav",
	"npc/overwatch/radiovoice/criminaltrespass63.wav",
	"npc/overwatch/radiovoice/disturbingunity415.wav",
	"npc/overwatch/radiovoice/illegalcarrying95.wav",
	"npc/overwatch/radiovoice/illegalinoperation63s.wav",
	"npc/overwatch/radiovoice/incitingpopucide.wav",
	"npc/overwatch/radiovoice/lockdownlocationsacrificecode.wav",
	"npc/overwatch/radiovoice/posession69.wav",
	"npc/overwatch/radiovoice/prepareforfinalsentencing.wav",
	"npc/overwatch/radiovoice/preparetoreceiveverdict.wav",
	"npc/overwatch/radiovoice/violationofcivictrust.wav",
	"npc/overwatch/radiovoice/weapon94.wav",
}
ENT.SoundTbl_CallForHelp = {
	"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
	"npc/overwatch/radiovoice/allunitsapplyforwardpressure.wav",
	"npc/overwatch/radiovoice/confirmupialert.wav",
	"npc/overwatch/radiovoice/disturbancemental10-103m.wav",
	"npc/overwatch/radiovoice/leadersreportratios.wav",
	"npc/overwatch/radiovoice/level5anticivilactivity.wav",
	"npc/overwatch/radiovoice/preparetoinnoculate.wav",
	"npc/overwatch/radiovoice/preparevisualdownload.wav",
	"npc/overwatch/radiovoice/threattoproperty51b.wav",
	"npc/overwatch/radiovoice/reinforcementteamscode3.wav",
	"npc/overwatch/radiovoice/unlawfulentry603.wav",
}
ENT.SoundTbl_OnPlayerSight = {
	"npc/overwatch/radiovoice/freeman.wav",
	"npc/overwatch/radiovoice/fugitive17f.wav",
	"npc/overwatch/radiovoice/highpriorityregion.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"npc/overwatch/radiovoice/finalverdictadministered.wav",
	"npc/overwatch/radiovoice/sociostabilizationrestored.wav",
	"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
	"npc/overwatch/radiovoice/suspectisnow187.wav",
}
ENT.SoundTbl_AllyDeath = {
	"npc/overwatch/radiovoice/assault243.wav",
	"npc/overwatch/radiovoice/destrutionofcpt.wav",
	"npc/overwatch/radiovoice/disassociationfromcivic.wav",
	"npc/overwatch/radiovoice/lostbiosignalforunit.wav",
	"npc/overwatch/radiovoice/nonsanctionedarson51.wav",
	"npc/overwatch/radiovoice/unitdeserviced.wav",
}
ENT.SoundTbl_Death = {
	"^weapons/explode3.wav",
	"^weapons/explode4.wav",
	"^weapons/explode5.wav",
}

ENT.SoundTbl_Fire = {"weapons/ar2/fire1.wav"}
ENT.SoundTbl_FireRocket = {"weapons/stinger_fire1.wav"}

-- Tank Base
ENT.Tank_SoundTbl_DrivingEngine = {"vehicles/apc/apc_firstgear_loop1.wav"}
ENT.Tank_SoundTbl_Track = false
ENT.Tank_DefaultSoundTbl_Track = false

ENT.Tank_DriveAwayDistance = 500 -- If the enemy is closer than this number, than move by either running over them or moving away for the gunner to fire
ENT.Tank_DriveTowardsDistance = 2000 -- If the enemy is higher than this number, than move towards the enemy
ENT.Tank_RanOverDistance = 400
ENT.Tank_TurningSpeed = 5 -- How fast the chassis moves as it's driving
ENT.Tank_DrivingSpeed = 800 -- How fast the tank drives

ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 130
ENT.Tank_DeathDriverCorpse = "models/police.mdl"

-- Custom
ENT.APC_DmgForce = 0
ENT.APC_DoorOpen = false
ENT.APC_HasLOS = false
ENT.APC_HasSpawnedSoldiers = false
ENT.VJ_ForceRocketFollow = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Init()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(80000)
	end

	self.APC_DeployedUnits = {}
	
	self.NextFireT = 0
	self.NextRocketT = 0
	self.Ammo = 2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_Fire,sdFile) or VJ.HasValue(self.SoundTbl_FireRocket,sdFile) or VJ.HasValue(self.SoundTbl_Breath,sdFile) or VJ.HasValue(self.Tank_SoundTbl_DrivingEngine,sdFile) or VJ.HasValue(self.Tank_SoundTbl_Track,sdFile) then return end
	VJ.EmitSound(self, "npc/overwatch/radiovoice/on3.wav")
	timer.Simple(SoundDuration(sdFile),function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self,"npc/overwatch/radiovoice/off2.wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Deploy Civil-Protection Squad (1 time)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateMoveParticles()
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetEntity(self)
	effectData:SetOrigin(self:GetPos() + self:GetRight() * -130 + self:GetForward() * 58)
	util.Effect("VJ_VehicleMove", effectData, true, true)
	effectData:SetOrigin(self:GetPos() + self:GetRight() * -130 + self:GetForward() * -58)
	util.Effect("VJ_VehicleMove", effectData, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.APC_HasLOS = false
	else
		self.APC_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	local enemy = self:GetEnemy()
	if !IsValid(enemy) then return end
	
	if CurTime() > self.NextRocketT && enemy:Visible(self) then
		if self.Ammo <= 0 then
			local t = SoundDuration("ambient/machines/thumper_shutdown1.wav")
			VJ.CreateSound(self,"ambient/machines/thumper_shutdown1.wav",75)
			timer.Simple(t,function()
				if IsValid(self) then
					VJ.CreateSound(self,"ambient/machines/thumper_startup1.wav",75)
					self.Ammo = 2
				end
			end)
			self.NextRocketT = CurTime() +t +2.5
			return
		end
		
		local rocket = ents.Create("obj_vj_hlr2_rocket")
		rocket:SetPos(self:GetAttachment(2).Pos)
		rocket:SetAngles(self:GetAttachment(2).Ang)
		rocket:SetOwner(self)
		rocket:Spawn()
		
		self.Ammo = self.Ammo -1
		self.NextRocketT = CurTime() +SoundDuration("weapons/stinger_fire1.wav")
	end
	
	if CurTime() > self.NextFireT && self.APC_HasLOS && enemy:Visible(self) then
		local startpos = self:GetAttachment(1).Pos
		local bullet = {}
		bullet.Num = 1
		bullet.Src = startpos
		bullet.Dir = (self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()) -startpos
		bullet.Spread = Vector(math.random(-15,15), math.random(-15,15), math.random(-15,15))
		bullet.Tracer = 1
		bullet.TracerName = "AR2Tracer"
		bullet.Force = 5
		bullet.Damage = 6
		bullet.AmmoType = "AR2"
		self:FireBullets(bullet)
		
		VJ.EmitSound(self,self.SoundTbl_Fire,90,math.random(100,110))
		
		ParticleEffect("vj_rifle_full_blue",startpos,self:GetAngles(),self)
		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", "4")
		FireLight1:SetKeyValue("distance", "120")
		FireLight1:SetPos(startpos)
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", "0 31 225")
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)
		
		self.NextFireT = CurTime() +0.08
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThink()
	-- If moving then close the door
	if self.Tank_Status == 0 && self.APC_DoorOpen == true then
		self.APC_DoorOpen = false
	end
	
	-- Deploy soldiers
	if self.Tank_Status == 1 && self.APC_HasSpawnedSoldiers == false && self.APC_DoorOpen == false && IsValid(self:GetEnemy()) && ((!self.VJ_IsBeingControlled && math.random(1,60) == 1) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self.APC_DoorOpen = true
		self.APC_HasSpawnedSoldiers = true
		timer.Simple(0.5, function()
			if IsValid(self) then
				if self.APC_DoorOpen == false then -- Door was suddenly closed, so try again later
					self.APC_HasSpawnedSoldiers = false
				else
					local ene = self:GetEnemy()
					for i = 1,math.random(2,3) do
						local combine = ents.Create("npc_vj_hlr2_com_civilp")
						local opSide = ((i % 2 == 0) and -25) or 25 -- Make every other grunt spawn to the opposite side
						combine:SetPos(self:GetPos() + self:GetForward()*(i <= 2 and -160 or (i <= 4 and -220 or -290)) + self:GetRight()*opSide + self:GetUp()*5)
						combine:SetAngles(Angle(0, self:GetAngles().y + 180, 0))
						combine:Spawn()
						combine:Give(VJ.PICK({"weapon_vj_9mmpistol","weapon_vj_smg1"}))
						combine:ForceSetEnemy(ene, true)
						combine:SetState(VJ_STATE_FREEZE)
						timer.Simple(0.2, function()
							if IsValid(combine) then
								combine:SetState(VJ_STATE_NONE)
								combine:SetLastPosition(combine:GetPos() + combine:GetForward()*200 + combine:GetRight()*opSide)
								combine:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH")
							end
						end)
						self.APC_DeployedUnits[#self.APC_DeployedUnits + 1] = combine -- Register the grunt
					end
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randPos = math.random(1,5)
	if randPos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*120)
	elseif randPos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*60 + self:GetForward()*-40 + self:GetUp()*81)
	elseif randPos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-60 + self:GetForward()*-40 + self:GetUp()*81)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnDeathCorpse(dmginfo, hitgroup, corpseEnt, status, statusData)
	if status == "Override" then
		corpseEnt:SetAngles(self:GetAngles() +Angle(0,270,0))
		self:CreateExtraDeathCorpse("prop_physics","models/combine_apc_destroyed_gib02.mdl",{Pos=corpseEnt:GetPos(),Ang=corpseEnt:GetAngles()})
		self:CreateExtraDeathCorpse("prop_physics","models/combine_apc_destroyed_gib03.mdl",{Pos=corpseEnt:GetPos(),Ang=corpseEnt:GetAngles()})
		self:CreateExtraDeathCorpse("prop_physics","models/combine_apc_destroyed_gib04.mdl",{Pos=corpseEnt:GetPos(),Ang=corpseEnt:GetAngles()})
		self:CreateExtraDeathCorpse("prop_physics","models/combine_apc_destroyed_gib05.mdl",{Pos=corpseEnt:GetPos(),Ang=corpseEnt:GetAngles()})
		self:CreateExtraDeathCorpse("prop_physics","models/combine_apc_destroyed_gib06.mdl",{Pos=corpseEnt:GetPos(),Ang=corpseEnt:GetAngles()})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if !self.Dead then
		for _, v in pairs(self.APC_DeployedUnits) do
			if IsValid(v) then v:Remove() end
		end
	end
end