AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/crabsynth.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 850
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Blue" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 85
ENT.TimeUntilMeleeAttackDamage = 0.1 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 75 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 170 -- How far does the damage go?
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 800 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 800 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 150 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 150 -- How far it will push you up | Second in math.random
ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1
ENT.MeleeAttackBleedEnemyDamage = 3
ENT.SlowPlayerOnMeleeAttack = true

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackAnimationStopMovement = false
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeToMeleeDistance = 350 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 75 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.001 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 0.001 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.001 -- How much time until it can use any attack again? | Counted in Seconds
ENT.RangeDistance = 4000

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Box01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(15, 0, 20), -- The offset for the controller when the camera is in first person
}

ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"npc/combine_gunship/gunship_engine_loop3.wav"}
ENT.SoundTbl_FootStep = {"ambient/materials/clang1.wav"}
ENT.SoundTbl_FootStepHeavy = {"ambient/materials/door_hit1.wav"}
ENT.SoundTbl_Idle = {"npc/combine_gunship/ping_patrol.wav","npc/combine_gunship/ping_search.wav","npc/combine_gunship/gunship_ping_search.wav","npc/combine_gunship/gunship_moan.wav"}
ENT.SoundTbl_Alert = {"npc/combine_gunship/see_enemy.wav"}
ENT.SoundTbl_Pain = {"npc/combine_gunship/gunship_pain.wav"}
ENT.SoundTbl_Death = {}

ENT.BreathSoundLevel = 80
ENT.IdleSoundLevel = 90
ENT.AlertSoundLevel = 95
ENT.PainSoundLevel = 90
ENT.GeneralSoundPitch1 = 100

ENT.BulletSpread = 15
ENT.RPG_ReloadTime = 10
ENT.RPG_Speed = 2000
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(75,75,120), Vector(-75,-75,0))
	self.NextRocketT = CurTime() +2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "step_heavy" then
		VJ_EmitSound(self,self.SoundTbl_FootStepHeavy,88)
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line",self:GetPos(),self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),self.RPG_Speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	if CurTime() > self.NextRocketT then
		local proj = ents.Create("obj_vj_tank_shell")
		proj:SetPos(self:GetAttachment(self:LookupAttachment("rpg")).Pos)
		proj:SetAngles((self:GetEnemy():GetPos() -proj:GetPos()):Angle())
		proj:Spawn()
		proj:Activate()
		proj:SetOwner(self)
		proj:SetPhysicsAttacker(self)
		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(self:RangeAttackCode_GetShootPos(proj))
		end
		VJ_EmitSound(self,"weapons/stinger_fire1.wav",105,100)
		ParticleEffectAttach("vj_rifle_full",PATTACH_POINT_FOLLOW,self,2)
		ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,self,2)
		timer.Simple(self.RPG_ReloadTime -SoundDuration("npc/combine_gunship/attack_start2.wav"),function()
			if IsValid(self) then
				VJ_EmitSound(self,"vnpc/combine_gunship/attack_start2.wav",85,100)
			end
		end)
		self.NextRocketT = CurTime() +self.RPG_ReloadTime
	end
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetAttachment(self:LookupAttachment("muzzle")).Pos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment("muzzle")).Pos +Vector(math.random(-self.BulletSpread,self.BulletSpread),math.random(-self.BulletSpread,self.BulletSpread),math.random(-self.BulletSpread,self.BulletSpread))
	bullet.Spread = self.BulletSpread
	bullet.Tracer = 1
	bullet.TracerName = "AR2Tracer"
	bullet.Force = 3
	bullet.Damage = 5
	bullet.AmmoType = "AR2"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self,"weapons/airboat/airboat_gun_energy"..math.random(1,2)..".wav",100,100)
	
	ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,1)
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if hitgroup == 15 then
		dmginfo:SetDamage(dmginfo:GetDamage() *4.5)
		VJ_EmitSound(self,"ambient/energy/zap"..math.random(1,9)..".wav",70)
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
	else
		if dmginfo:IsBulletDamage() then
			dmginfo:SetDamage(1)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()

end