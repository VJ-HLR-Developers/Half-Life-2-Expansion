AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/combine_guard.mdl"}
ENT.StartHealth = 500
ENT.SightAngle = 190
ENT.HullType = HULL_HUMAN

ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, -40), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}

ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Dissolve = true

ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 85
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDamage = 20

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {ACT_ARM}
ENT.RangeDistance = 3500
ENT.RangeToMeleeDistance = 500
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 5
ENT.DisableDefaultRangeAttackCode = true

ENT.NoChaseAfterCertainRange = true
ENT.NoChaseAfterCertainRange_FarDistance = 1800
ENT.NoChaseAfterCertainRange_CloseDistance = 500
ENT.NoChaseAfterCertainRange_Type = "OnlyRange"
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true

ENT.SoundTbl_FootStep = {
	"vj_hlr/hl2_npc/combine_guard/step1.wav",
	"vj_hlr/hl2_npc/combine_guard/step2.wav",
}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl2_npc/combine_guard/assault1.wav",
	"vj_hlr/hl2_npc/combine_guard/assault2.wav",
	"vj_hlr/hl2_npc/combine_guard/assault3.wav",
	"vj_hlr/hl2_npc/combine_guard/go_alert1.wav",
	"vj_hlr/hl2_npc/combine_guard/go_alert2.wav",
	"vj_hlr/hl2_npc/combine_guard/go_alert3.wav",
	"vj_hlr/hl2_npc/combine_guard/refind_enemy1.wav",
	"vj_hlr/hl2_npc/combine_guard/refind_enemy2.wav",
	"vj_hlr/hl2_npc/combine_guard/refind_enemy3.wav",
	"vj_hlr/hl2_npc/combine_guard/refind_enemy4.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vj_hlr/hl2_npc/combine_guard/flank1.wav",
	"vj_hlr/hl2_npc/combine_guard/flank2.wav",
	"vj_hlr/hl2_npc/combine_guard/flank3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl2_npc/combine_guard/kick1.wav",
	"vj_hlr/hl2_npc/combine_guard/kick2.wav",
}
ENT.SoundTbl_BeforeRangeAttack = {
	"vj_hlr/hl2_npc/combine_guard/announce1.wav",
	"vj_hlr/hl2_npc/combine_guard/announce2.wav",
	"vj_hlr/hl2_npc/combine_guard/announce3.wav",
	"vj_hlr/hl2_npc/combine_guard/throw_grenade1.wav",
	"vj_hlr/hl2_npc/combine_guard/throw_grenade2.wav",
	"vj_hlr/hl2_npc/combine_guard/throw_grenade3.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vj_hlr/hl2_npc/combine_guard/man_down1.wav",
	"vj_hlr/hl2_npc/combine_guard/man_down2.wav",
	"vj_hlr/hl2_npc/combine_guard/man_down3.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vj_hlr/hl2_npc/combine_guard/player_dead1.wav",
	"vj_hlr/hl2_npc/combine_guard/player_dead2.wav",
	"vj_hlr/hl2_npc/combine_guard/player_dead3.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vj_hlr/hl2_npc/combine_guard/lost_long1.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_long2.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_long3.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_long4.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_long5.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_long6.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_long7.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_short1.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_short2.wav",
	"vj_hlr/hl2_npc/combine_guard/lost_short3.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl2_npc/combine_guard/pain1.wav",
	"vj_hlr/hl2_npc/combine_guard/pain2.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl2_npc/combine_guard/die1.wav",
	"vj_hlr/hl2_npc/combine_guard/die2.wav",
	"vj_hlr/hl2_npc/combine_guard/die3.wav",
}
ENT.SoundTbl_MeleeAttackExtra = {"vj_base/impact/metal_crush1.wav","vj_base/impact/metal_crush2.wav","vj_base/impact/metal_crush3.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20,20,90),Vector(-20,-20,0))

	self.NextKnockdownT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && self.Alerted then
		return ACT_IDLE_ANGRY
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt,isProp)
	if hitEnt:IsPlayer() then
		hitEnt:ViewPunch(Angle(-20,-100,0))
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	elseif key == "charge" then
		self:StartWarpCannon(true)
	elseif key == "range" then
		local targetPos = self.TargetPos or self:GetPos() +self:GetForward() *1250
		self:WarpCannon(targetPos)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer(seed)
	-- self:PlayAnim("idleact",true,false,true,0,{OnFinish=function(interrupted,anim)
	-- 	if interrupted then return end
	-- 	self:PlayAnim(ACT_RANGE_ATTACK1,true,false,false)
	-- end})
	self:PlayAnim(ACT_RANGE_ATTACK1,true,false,false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bit_band = bit.band
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" then
		if hitgroup == 100 then
			dmginfo:ScaleDamage(0.1) -- Shield
		elseif hitgroup == 101 then
			dmginfo:ScaleDamage(0) -- Gun
		elseif hitgroup == 1 then
			dmginfo:ScaleDamage(2)
			local pos = dmginfo:GetDamagePosition()
			if pos == defPos then pos = self:GetPos() + self:OBBCenter() end
			
			local particle = ents.Create("info_particle_system")
			particle:SetKeyValue("effect_name", "vj_impact1_red")
			particle:SetPos(pos)
			particle:Spawn()
			particle:Activate()
			particle:Fire("Start")
			particle:Fire("Kill", "", 0.1)
		else
			if dmginfo:IsBulletDamage() then
				if self.HasSounds == true && self.HasImpactSounds == true then
					VJ.EmitSound(self, "vj_base/impact/armor"..math.random(1, 10)..".wav", 70)
				end
				if math.random(1, 3) == 1 then
					dmginfo:ScaleDamage(0.50)
					local effectData = EffectData()
					effectData:SetOrigin(dmginfo:GetDamagePosition())
					effectData:SetNormal(dmginfo:GetDamageForce():GetNormalized())
					effectData:SetMagnitude(3)
					effectData:SetScale(1)
					util.Effect("ElectricSpark", effectData)
				else
					dmginfo:ScaleDamage(0.80)
				end
			end
		end
	elseif status == "PostDamage" then
		local explosion = dmginfo:IsExplosionDamage()
		if self:Health() > 0 && (explosion or bit_band(dmginfo:GetDamageType(),DMG_VEHICLE) == DMG_VEHICLE) && CurTime() > self.NextKnockdownT then
			local dmgAng = ((explosion && dmginfo:GetDamagePosition() or dmginfo:GetAttacker():GetPos()) -self:GetPos()):Angle()
			dmgAng.p = 0
			dmgAng.r = 0
			self:TaskComplete()
			self:StopMoving()
			self:ClearSchedule()
			self:ClearGoal()
			self:SetAngles(dmgAng)
			self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
			local _,dur = self:PlayAnim("physfall",true,false,false,0,{OnFinish=function(interrupted)
				self:PlayAnim("physgetup",true,false,false,0,{OnFinish=function(interrupted)
					self:SetState()
				end})
			end})
			self.NextKnockdownT = CurTime() +(dur *2)
			self.NextCallForBackUpOnDamageT = CurTime() +dur
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		local explosion = dmginfo:IsExplosionDamage()
		if (explosion or bit_band(dmginfo:GetDamageType(),DMG_VEHICLE) == DMG_VEHICLE) && CurTime() > self.NextKnockdownT then
			self.HasDeathAnimation = true
			self.AnimTbl_Death = "physfall"
			self.DeathDelayTime = self:DecideAnimationLength("physfall",false) + self:DecideAnimationLength("physdeath",false) - 1
			timer.Simple(self:DecideAnimationLength("physfall",false),function()
				if IsValid(self) then
					self:PlayAnim("physdeath",true,false,false)
				end
			end)
		end
	elseif status == "Finish" then
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTrace(tPos)
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("muzzle")).Pos
	tracedata.endpos = tPos +VectorRand() *50
	tracedata.filter = {self}
	return util.TraceLine(tracedata).HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WarpCannon(tPos)
	local attackpos = self:DoTrace(tPos)

	local beam = EffectData()
	beam:SetStart(self:GetAttachment(1).Pos)
	beam:SetOrigin(attackpos)
	beam:SetEntity(self)
	beam:SetAttachment(1)
	util.Effect("VJ_HLR_StriderBeam",beam)
	
	local hitTime = 1 /math.min(1,self:GetAttachment(1).Pos:Distance(attackpos) /10000)
	hitTime = math.Clamp(hitTime,0,1) ^0.5
	timer.Simple(hitTime,function()
		if IsValid(self) then
			VJ.ApplyRadiusDamage(self,self,attackpos,300,500,bit.bor(DMG_DISSOLVE,DMG_BLAST),true,false,{Force=175})
			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness", "8")
			FireLight1:SetKeyValue("distance", "300")
			FireLight1:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos)
			FireLight1:SetLocalAngles(self:GetAngles())
			FireLight1:Fire("Color", "0 31 225")
			FireLight1:SetParent(self)
			FireLight1:Spawn()
			FireLight1:Activate()
			FireLight1:Fire("TurnOn","",0)
			FireLight1:Fire("Kill","",0.1)
			self:DeleteOnRemove(FireLight1)
		end
	end)
	timer.Simple(0.49,function()
		if IsValid(self) then
			VJ.EmitSound(self,"^npc/strider/fire.wav",130,self:VJ_DecideSoundPitch(100,110))

			ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,2)
			timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness", "4")
			FireLight1:SetKeyValue("distance", "120")
			FireLight1:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos)
			FireLight1:SetLocalAngles(self:GetAngles())
			FireLight1:Fire("Color", "0 31 225")
			FireLight1:SetParent(self)
			FireLight1:Spawn()
			FireLight1:Activate()
			FireLight1:Fire("TurnOn","",0)
			FireLight1:Fire("Kill","",0.07)
			self:DeleteOnRemove(FireLight1)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartWarpCannon(doLastPos)
	VJ.CreateSound(self,"^npc/strider/charging.wav",110)

	local pinch = ents.Create("env_sprite")
	pinch:SetKeyValue("model","effects/strider_pinch_dudv.vmt")
	pinch:SetKeyValue("scale",tostring(math.Rand(0.2,0.4)))
	pinch:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	pinch:SetKeyValue("HDRColorScale","1.0")
	pinch:SetKeyValue("renderfx","14")
	pinch:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	pinch:SetKeyValue("renderamt","255") -- Transparency
	pinch:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	pinch:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	pinch:SetKeyValue("spawnflags","0")
	pinch:SetParent(self)
	pinch:Fire("SetParentAttachment","muzzle")
	pinch:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	pinch:Spawn()
	pinch:Activate()
	pinch:Fire("Kill","",SoundDuration("npc/strider/charging.wav") +1)

	local muz = ents.Create("env_sprite")
	muz:SetKeyValue("model","effects/strider_bulge_dx60.vmt")
	muz:SetKeyValue("scale",tostring(math.Rand(1,1.5)))
	muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment","muzzle")
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",SoundDuration("npc/strider/charging.wav") +0.3)

	local target = self:GetEnemy()
	local targetPos = self:GetPos() +self:GetForward() *1250
	if IsValid(target) then
		targetPos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
	end
	if doLastPos then
		targetPos = self.EnemyData != nil && self.EnemyData.LastVisiblePos or self:GetPos() +self:GetForward() *1250
	end
	sound.EmitHint(SOUND_DANGER, targetPos, 500, 1, self)

	self.TargetPos = targetPos
end