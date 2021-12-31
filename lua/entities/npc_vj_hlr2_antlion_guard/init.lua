AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/antlion_guard.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ANTLION"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 70 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 150 -- How far does the damage go?
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackDamageType = DMG_CRUSH
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 400 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 500 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 300 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 300 -- How far it will push you up | Second in math.random
ENT.Immune_Physics = true
ENT.FootStepTimeRun = 0.21 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
-- ENT.SoundTbl_Breath = {"npc/antlion_guard/growl_idle.wav"}
ENT.SoundTbl_FootStep = {"npc/antlion_guard/foot_heavy1.wav","npc/antlion_guard/foot_heavy2.wav","npc/antlion_guard/foot_light1.wav","npc/antlion_guard/foot_light2.wav"}
ENT.SoundTbl_Death = {"npc/antlion_guard/antlion_guard_die1.wav","npc/antlion_guard/antlion_guard_die2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/antlion_guard/angry1.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/antlion_guard/shove1.wav"}

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Antlion_Guard.head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 3), -- The offset for the controller when the camera is in first person
}

ENT.BreathSoundLevel = 70

ENT.IsGuardian = false
ENT.ChargePercentage = 0.65
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("MOUSE2: Charge Attack")
	ply:ChatPrint("RELOAD: Summon Antlions (Only works on weak surfaces [Grass, Snow, Sand, etc])")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(40,40,80),Vector(-40,-40,0))
	self.IsDiging = false
	self.ChargeAnim = VJ_SequenceToActivity(self, "charge_loop")
	self.Breath = CreateSound(self,"npc/antlion_guard/growl_idle.wav")
	self.Breath:PlayEx(0.65,100)
	self.ChargeBreath = CreateSound(self,"npc/antlion_guard/growl_high.wav")
	self.ChargeBreath:PlayEx(0,0)

	self.NextSummonT = CurTime() +6
	self.NextChargeT = CurTime() +5
	self.StopChargingT = CurTime()
	self.Charging = false
	self.BreathPitch = 100

	if self.IsGuardian then self:SetSkin(1) end
	if self:IsDirt(self:GetPos()) then
		self.IsDiging = true
		self:SetNoDraw(true)
		timer.Simple(0.000001,function()
			self:VJ_ACT_PLAYACTIVITY("floor_break",true,VJ_GetSequenceDuration(self,"floor_break"),false)
			self.HasMeleeAttack = false
			timer.Simple(0.5,function()
				if IsValid(self) then
					self:SetNoDraw(false)
					self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					if self.IsGuardian then self:CreateEffects() end
				end
			end)
			timer.Simple(0.7,function()
				if IsValid(self) then
					self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				end
			end)
			timer.Simple(1.4,function()
				if IsValid(self) then
					self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				end
			end)
			timer.Simple(2,function()
				if IsValid(self) then
					self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				end
			end)
			timer.Simple(2.5,function()
				if IsValid(self) then
					self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
					ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				end
			end)
			timer.Simple(VJ_GetSequenceDuration(self,"floor_break"),function()
				if IsValid(self) then
					self.IsDiging = false
					self.HasMeleeAttack = true
				end
			end)
		end)
	else
		if self.IsGuardian then self:CreateEffects() end
	end
	//charge_cancel, charge_crash, charge_loop, charge_stop, floor_break, flinch1, flinch2, pain
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateEffects()
	local glow1 = ents.Create("env_sprite")
	glow1:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow1:SetKeyValue("scale","1")
	glow1:SetKeyValue("rendermode","5")
	glow1:SetKeyValue("rendercolor","127 225 0")
	glow1:SetKeyValue("spawnflags","1") -- If animated
	glow1:SetParent(self)
	glow1:Fire("SetParentAttachment","attach_glow1",0)
	glow1:Spawn()
	glow1:Activate()
	self:DeleteOnRemove(glow1)
	local glow2 = ents.Create("env_sprite")
	glow2:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow2:SetKeyValue("scale","0.4")
	glow2:SetKeyValue("rendermode","5")
	glow2:SetKeyValue("rendercolor","127 225 0")
	glow2:SetKeyValue("spawnflags","1") -- If animated
	glow2:SetParent(self)
	glow2:Fire("SetParentAttachment","attach_glow2",0)
	glow2:Spawn()
	glow2:Activate()
	self:DeleteOnRemove(glow2)
	local glow3 = ents.Create("env_sprite")
	glow3:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow3:SetKeyValue("scale","0.4")
	glow3:SetKeyValue("rendermode","5")
	glow3:SetKeyValue("rendercolor","127 225 0")
	glow3:SetKeyValue("spawnflags","1") -- If animated
	glow3:SetParent(self)
	glow3:Fire("SetParentAttachment","0",0)
	glow3:Spawn()
	glow3:Activate()
	self:DeleteOnRemove(glow3)
	local glow4 = ents.Create("env_sprite")
	glow4:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow4:SetKeyValue("scale","0.4")
	glow4:SetKeyValue("rendermode","5")
	glow4:SetKeyValue("rendercolor","127 225 0")
	glow4:SetKeyValue("spawnflags","1") -- If animated
	glow4:SetParent(self)
	glow4:Fire("SetParentAttachment","1",0)
	glow4:Spawn()
	glow4:Activate()
	self:DeleteOnRemove(glow4)
	local glowlight = ents.Create("light_dynamic")
	glowlight:SetKeyValue("_light","127 225 0 200")
	glowlight:SetKeyValue("brightness","1")
	glowlight:SetKeyValue("distance","200")
	glowlight:SetKeyValue("style","0")
	glowlight:SetPos(self:GetPos())
	glowlight:SetParent(self)
	glowlight:Spawn()
	glowlight:Activate()
	glowlight:Fire("SetParentAttachment","attach_glow2")
	glowlight:Fire("TurnOn","",0)
	glowlight:DeleteOnRemove(self)
	local glowlight_top = ents.Create("light_dynamic")
	glowlight_top:SetKeyValue("_light","127 225 0 200")
	glowlight_top:SetKeyValue("brightness","2")
	glowlight_top:SetKeyValue("distance","150")
	glowlight_top:SetKeyValue("style","0")
	glowlight_top:SetPos(self:GetPos())
	glowlight_top:SetParent(self)
	glowlight_top:Spawn()
	glowlight_top:Activate()
	glowlight_top:Fire("SetParentAttachment","attach_glow1")
	glowlight_top:Fire("TurnOn","",0)
	glowlight_top:DeleteOnRemove(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsDirt(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0,0,40),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	local mat = tr.MatType
	return tr.HitWorld && (mat == MAT_SAND || mat == MAT_DIRT || mat == MAT_FOLIAGE || mat == MAT_SLOSH || mat == 85)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SummonAllies(anim)
	if self:BusyWithActivity() or self.Charging then return end
	local anim = anim or "bark"
	self:VJ_ACT_PLAYACTIVITY(anim,true,false,false)
	timer.Simple(0.5,function()
		if IsValid(self) then
			VJ_CreateSound(self,"npc/antlion_guard/angry2.wav",95,100)
			for i = 1,math.random(4,self.IsGuardian && 10 or 6) do
				self:CreateAntlion(self:GetRight() *math.random(-350,350) +self:GetForward()*math.random(-350,350))
			end
		end
	end)
	if anim == "bark" then
		timer.Simple(1,function()
			if IsValid(self) then
				VJ_CreateSound(self,"npc/antlion_guard/angry3.wav",95,100)
			end
		end)
		timer.Simple(1.65,function()
			if IsValid(self) then
				self:EmitSound("npc/antlion_guard/angry2.wav",95,100)
			end
		end)
	else
		timer.Simple(1.4,function()
			if IsValid(self) then
				VJ_CreateSound(self,"npc/antlion_guard/angry1.wav",95,100)
			end
		end)
	end
	self.NextSummonT = CurTime() +math.Rand(25,45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self:BusyWithActivity() or self.Charging then return end
	self.NextChargeT = CurTime() +5
	if math.random(1,3) == 1 && CurTime() > self.NextSummonT then
		self:SummonAllies(VJ_PICK({"bark","roar"}))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateAntlion(pos)
	local class = "npc_vj_hlr2_antlion"
	if math.random(1,3) == 1 then
		class = "npc_vj_hlr2_antlion_worker"
	end
	local antlion = ents.Create(class)
	antlion:SetPos(self:GetPos() +pos +Vector(0,0,10))
	antlion:SetAngles(self:GetAngles())
	antlion:Spawn()
	antlion:Activate()
	antlion:Dig(true)
	ParticleEffect("advisor_plat_break",antlion:GetPos(),antlion:GetAngles(),antlion)
	ParticleEffect("strider_impale_ground",antlion:GetPos(),antlion:GetAngles(),antlion)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:IsBulletDamage() then
		dmginfo:SetDamage(math.random(1,2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local ent = self:GetEnemy()
	local hasEnemy = IsValid(ent)
	local controlled = IsValid(self.VJ_TheController)
	if self.Charging then
		local tPos = hasEnemy && ent:GetPos() or self:GetPos() +self:GetForward() *500
		local setangs = self:GetFaceAngle((tPos -self:GetPos()):Angle())
		self:SetAngles(Angle(setangs.p,self:GetAngles().y,setangs.r))
		self:SetIdealYawAndUpdate(setangs.y)
		self:AutoMovement(self:GetAnimTimeInterval() *self.ChargePercentage) -- For some reason, letting it go at 100% forces the walkframe speed to be doubled, essentially ignoring the walkframes in the animation. Basically, think how NextBots just slide everywhere faster than their animation is supposed to
		self:SetGroundEntity(NULL)
		local tr = util.TraceHull({
			start = self:GetPos() +self:OBBCenter(),
			endpos = self:GetPos() +self:OBBCenter() +self:GetForward() *135,
			filter = self,
			mins = self:OBBMins() /2,
			maxs = self:OBBMaxs() /2
		})
		local hitEnt = NULL
		for _,v in pairs(ents.FindInSphere(self:GetPos() +self:GetForward(),135)) do
			if IsValid(v) && v != self && (v != self.VJ_TheController && v != self.VJ_TheControllerBullseye) then
				-- print(v,self:DoRelationshipCheck(v))
				if self:DoRelationshipCheck(v) then
					hitEnt = v
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(35)
					dmginfo:SetDamageType(DMG_CRUSH)
					dmginfo:SetDamagePosition(v:GetPos() +v:OBBCenter())
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					v:TakeDamageInfo(dmginfo,self,self)
					v:SetGroundEntity(NULL)
					v:SetVelocity(self:GetForward() *math.random(self.MeleeAttackKnockBack_Forward1, self.MeleeAttackKnockBack_Forward2) *2 + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1, self.MeleeAttackKnockBack_Up2) *2 + self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1, self.MeleeAttackKnockBack_Right2) *2)

					local gesture = self:AddGestureSequence(self:LookupSequence("charge_hit"))
					self:SetLayerPriority(gesture,1)
					self:SetLayerPlaybackRate(gesture,0.5)
				end
			end
		end
		if CurTime() > self.StopChargingT or tr.HitWorld == true or IsValid(hitEnt) then
			self:StopCharging(tr && tr.HitWorld)
		end
	end
	self.BreathPitch = Lerp(FrameTime() *10, self.BreathPitch, hasEnemy && 110 or 90)
	self.Breath:ChangeVolume(hasEnemy && 1 or 0.65,1)
	self.Breath:ChangePitch(self.BreathPitch)
	self.ChargeBreath:ChangePitch(self.BreathPitch)
	if hasEnemy then
		if ((controlled && self.VJ_TheController:KeyDown(IN_RELOAD)) or !controlled && math.random(1,75) == 1) && CurTime() > self.NextSummonT then
			self:SummonAllies()
		end
		if ((controlled && self.VJ_TheController:KeyDown(IN_ATTACK2)) or !controlled) && ent:GetPos():Distance(self:GetPos()) <= 2500 && !self:BusyWithActivity() && CurTime() > self.NextChargeT && !self.Charging && ent:Visible(self) && self:GetSequenceName(self:GetSequence()) != "charge_startfast" then
			self:VJ_ACT_PLAYACTIVITY("charge_startfast",true,false,true)
			VJ_CreateSound(self,{"npc/antlion_guard/angry1.wav","npc/antlion_guard/angry2.wav","npc/antlion_guard/angry3.wav"},72)
			self.ChargeBreath:Play()
			self.ChargeBreath:ChangeVolume(1,1)
			timer.Simple(self:SequenceDuration(self:LookupSequence("charge_startfast")),function()
				if IsValid(self) then
					self.StopChargingT = CurTime() +15
					self.Charging = true
					self:SetMaxYawSpeed(4)
					self.AnimTbl_IdleStand = {self.ChargeAnim}
					self.AnimTbl_Walk = {self.ChargeAnim}
					self.AnimTbl_Run = {self.ChargeAnim}
					self:SetState(VJ_STATE_ONLY_ANIMATION)
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCharging(crash)
	self:SetState()
	self.Charging = false
	self.StopChargingT = CurTime()
	self:SetMaxYawSpeed(self.TurningSpeed)
	self.NextChargeT = CurTime() +math.Rand(8,15)
	if crash then
		util.ScreenShake(self:GetPos(),16,100,2,1500)
		VJ_CreateSound(self,"npc/antlion_guard/shove1.wav",75)
	end
	self:VJ_ACT_PLAYACTIVITY(crash && {"charge_crash","charge_crash02","charge_crash03"} or "charge_stop",true,false,false)
	self.AnimTbl_IdleStand = {ACT_IDLE}
	self.AnimTbl_Walk = {ACT_WALK}
	self.AnimTbl_Run = {ACT_RUN}
	self.ChargeBreath:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.Breath:Stop()
	self.ChargeBreath:Stop()
end