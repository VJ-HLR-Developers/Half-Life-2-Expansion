AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJTag_ID_Boss = true
ENT.Model = {"models/vj_hlr/hl2/combine_heavychopper.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 4000
ENT.SightAngle = 360
ENT.HullType = HULL_LARGE
ENT.TurningSpeed = 2 -- How fast it can turn

ENT.PoseParameterLooking_Names = {pitch={"l_aim_pitch","r_aim_pitch"}, yaw={"l_aim_yaw","r_aim_yaw"}, roll={}}

ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Alerted = 350 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.Aerial_FlyingSpeed_Calm = 325 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_AnimTbl_Calm = {ACT_IDLE} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {ACT_IDLE} -- Animations it plays when it's moving while alerted
ENT.AA_GroundLimit = 1200 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 1000 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 4 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
ENT.AA_MoveDecelerate = 4 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x

ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch pose parameters (X)
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other

ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.ImmuneDamagesTable = {DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN}

ENT.HasMeleeAttack = false -- Can this NPC melee attack?

ENT.DeathCorpseCollisionType = COLLISION_GROUP_NONE -- Collision type for the corpse | NPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Chopper.Blade_Hull", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(140, 0, -45), -- The offset for the controller when the camera is in first person
}

ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it"s visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 7500

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 4000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it"s able to range attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don"t want any sounds to play
ENT.SoundTbl_Alert = {"npc/attack_helicopter/aheli_megabomb_siren1.wav"}
ENT.SoundTbl_Pain = {"npc/attack_helicopter/aheli_damaged_alarm1.wav"}
ENT.SoundTbl_Death = {"npc/attack_helicopter/aheli_crash_alert2.wav"}

ENT.AlertSoundLevel = 150
ENT.PainSoundLevel = 150
ENT.DeathSoundLevel = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	return self:CalculateProjectile("Line",self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos,self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(140,140,100),Vector(-140,-140,-75))
	self:SetPos(self:GetPos() +Vector(0,0,400))
	
	self.IdleLP = CreateSound(self,"npc/attack_helicopter/aheli_rotor_loop1.wav")
	self.IdleLP:SetSoundLevel(115)
	self.IdleLP:Play()
	self.IdleLP:ChangeVolume(1)
	self.IdleLP:ChangePitch(72)
	
	self.FireLP = CreateSound(self,"weapons/airboat/airboat_gun_loop2.wav")
	self.FireLP:SetSoundLevel(120)
	self.FireLP:ChangeVolume(1)
	
	self.Charged = false
	self.Charging = false
	self.NextFireT = 0
	self.NextBombT = 0
	self.CarpetBombing = false
	self.CarpetBombPos = Vector(0, 0, 0)
	self.NextCarpetBombT = 0
	self.NextDropCarpetT = 0
	
	self.RangeUseAttachmentForPosID = "Damage0"
	
	self:CreateBoneFollowers()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(ent)
	self.RangeUseAttachmentForPosID = self.RangeUseAttachmentForPosID == "Damage0" && "Damage3" or "Damage0"
	VJ.CreateSound(ent,"weapons/rpg/rocketfire1.wav",80)
	VJ.CreateSound(ent,"vj_base/weapons/rpg/rpg1_single_dist.wav",120)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateFakeBullet(att)
	local startPos = self:GetAttachment(self:LookupAttachment(att)).Pos

	local FakeSpawn = ents.Create("prop_vj_animatable")
	FakeSpawn:SetPos(startPos)
	FakeSpawn:SetParent(self)
	FakeSpawn:Spawn()
    FakeSpawn:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	FakeSpawn:SetNoDraw(true)
	FakeSpawn:DrawShadow(false)
	self:DeleteOnRemove(FakeSpawn)
	
	return FakeSpawn
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FireBullet()
	local spread = 60
	sound.EmitHint(SOUND_DANGER, self:GetEnemy():GetPos(), 250, 0.25, self)
	for i = 1,3 do
		local ent = self:CreateFakeBullet("Muzzle1")
		VJ.EmitSound(ent,{"weapons/airboat/airboat_gun_energy1.wav","weapons/airboat/airboat_gun_energy2.wav"},95)

		local startpos = self:GetAttachment(self:LookupAttachment("Muzzle1")).Pos
		local bulletPos = ent:GetPos()
		local bullet = {}
		bullet.Num = 1
		bullet.Src = bulletPos
		bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) -startpos
		bullet.Spread = Vector(math.random(-spread,spread),math.random(-spread,spread),0)
		bullet.Tracer = 1
		bullet.TracerName = "AirboatGunTracer"
		bullet.Force = 5
		bullet.Damage = self:ScaleByDifficulty(7)
		bullet.AmmoType = "AR2"
		bullet.IgnoreEntity = ent
		bullet.Attacker = self
		bullet.Callback = function(attacker, tr, dmginfo)
			local laserhit = EffectData()
			laserhit:SetOrigin(tr.HitPos)
			laserhit:SetNormal(tr.HitNormal)
			laserhit:SetScale(25)
			util.Effect("AR2Impact",laserhit)
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamageType(bit.bor(2,4098,2147483648))
			
			util.ScreenShake(tr.HitPos,16,100,0.5,175)
			sound.Play("weapons/fx/nearmiss/bulletltor0" .. math.random(3,9) .. ".wav",tr.HitPos +tr.HitNormal *60,60,100,1)
			if tr.MatType && VJ.HasValue({MAT_METAL,MAT_GRATE,MAT_CONCRETE,MAT_COMPUTER,MAT_VENT},tr.MatType) then
				sound.Play("weapons/fx/rics/ric" .. math.random(1,5) .. ".wav",tr.HitPos,65,100,1)
			end
		end
		ent:FireBullets(bullet)
		SafeRemoveEntity(ent)

		local ent = self:CreateFakeBullet("Muzzle2")
		VJ.EmitSound(ent,{"weapons/airboat/airboat_gun_energy1.wav","weapons/airboat/airboat_gun_energy2.wav"},95)

		local startposB = self:GetAttachment(self:LookupAttachment("Muzzle2")).Pos
		local bulletPos = ent:GetPos()
		local bullet = {}
		bullet.Num = 1
		bullet.Src = bulletPos
		bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) -startposB
		bullet.Spread = Vector(math.random(-spread,spread),math.random(-spread,spread),0)
		bullet.Tracer = 1
		bullet.TracerName = "AirboatGunTracer"
		bullet.Force = 5
		bullet.Damage = self:ScaleByDifficulty(7)
		bullet.AmmoType = "AR2"
		bullet.IgnoreEntity = ent
		bullet.Attacker = self
		bullet.Callback = function(attacker, tr, dmginfo)
			local laserhit = EffectData()
			laserhit:SetOrigin(tr.HitPos)
			laserhit:SetNormal(tr.HitNormal)
			laserhit:SetScale(25)
			util.Effect("AR2Impact",laserhit)
			dmginfo:SetDamageType(bit.bor(2,4098,2147483648))
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
			
			util.ScreenShake(tr.HitPos,16,100,0.5,175)
			sound.Play("weapons/fx/nearmiss/bulletltor0" .. math.random(3,9) .. ".wav",tr.HitPos +tr.HitNormal *60,60,100,1)
			if tr.MatType && VJ.HasValue({MAT_METAL,MAT_GRATE,MAT_CONCRETE,MAT_COMPUTER,MAT_VENT},tr.MatType) then
				sound.Play("weapons/fx/rics/ric" .. math.random(1,5) .. ".wav",tr.HitPos,65,100,1)
			end
		end
		ent:FireBullets(bullet)
		SafeRemoveEntity(ent)

		ParticleEffect("vj_rifle_full_blue", startpos, self:GetAngles(), self)
		ParticleEffect("vj_rifle_full_blue", startposB, self:GetAngles(), self)

		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", "4")
		FireLight1:SetKeyValue("distance", "120")
		FireLight1:SetPos(startpos)
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", "0 161 255 255")
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)

		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", "4")
		FireLight1:SetKeyValue("distance", "120")
		FireLight1:SetPos(startposB)
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", "0 161 255 255")
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BarrageFire()
	timer.Create("vj_timer_fire_" .. self:EntIndex(),0.1,150,function()
		if IsValid(self:GetEnemy()) && !self.Dead then
			self:FireBullet()
		else
			timer.Remove("vj_timer_fire_" .. self:EntIndex())
			self.NextFireT = CurTime() +1
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	if IsValid(self:GetEnemy()) then
		local dist = self.NearestPointToEnemyDistance
		if CurTime() > self.NextBombT then
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = (self:GetPos() +self:GetUp() *-15000),
				mins = self:OBBMins(),
				maxs = self:OBBMaxs(),
				filter = self
			})
			if IsValid(tr.Entity) && self:Disposition(tr.Entity) == D_HT then
				local bomb = ents.Create("combine_mine")
				bomb:SetPos(self:GetAttachment(5).Pos)
				bomb:Spawn()
				local phys = bomb:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(((tr.Entity:GetPos() +(tr.Entity:GetRight() *math.Rand(-400,400))) -bomb:LocalToWorld(Vector(0,0,0))))
				end
				constraint.NoCollide(bomb,self,0,0)
				self.NextBombT = CurTime() +math.Rand(2,4)
			elseif !IsValid(tr.Entity) then
				if dist <= 2300 && math.random(1,150) == 1 then
					local bomb = ents.Create("npc_rollermine")
					bomb:SetPos(self:GetAttachment(5).Pos)
					bomb:Spawn()
					constraint.NoCollide(bomb,self,0,0)
					self.NextBombT = CurTime() +math.Rand(8,14)
				end
			end
		end
		if dist <= 4000 && self:Visible(self:GetEnemy()) then
			if CurTime() > self.NextFireT then
				if !self.Charged then
					if !self.Charging then
						self.Charging = true
						VJ.EmitSound(self,"weapons/cguard/charging.wav",105,85)
						local dur = SoundDuration("weapons/cguard/charging.wav")
						timer.Simple(dur +(dur *0.85),function()
							if IsValid(self) then
								self.Charged = true
								self.Charging = false
							end
						end)
					end
					return
				end
				self:BarrageFire()
				self.Charged = false
				self.NextFireT = CurTime() +20
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local velNorm = self:GetVelocity():GetNormal()
	local speed = FrameTime()*4
	self:SetPoseParameter("tilt_x", Lerp(speed, self:GetPoseParameter("tilt_x"), velNorm.x))
	self:SetPoseParameter("tilt_y", Lerp(speed, self:GetPoseParameter("tilt_y"), velNorm.y))

	if timer.Exists("vj_timer_fire_" .. self:EntIndex()) then
		self.FireLP:Play()
	else
		self.FireLP:Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,self,8)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,4)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,6)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	local pos,ang = self:GetBonePosition(0)
	corpseEnt:SetPos(pos)
	corpseEnt:GetPhysicsObject():SetVelocity(((self:GetPos() +self:GetRight() *-700 +self:GetForward() *-300 +self:GetUp() *-200) -self:GetPos()))
	util.BlastDamage(self, self, corpseEnt:GetPos(), 400, 40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)

	VJ.EmitSound(self,"vj_base/ambience/explosion2.wav",100,100)
	VJ.EmitSound(self,"vj_base/ambience/explosion3.wav",100,100)
	util.BlastDamage(self,self,corpseEnt:GetPos(),200,40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)
	if self.HasGibOnDeathEffects == true then ParticleEffect("vj_explosion2",corpseEnt:GetPos(),Angle(0,0,0),nil) end

	if math.random(1,3) == 1 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/combine_soldier.mdl",{Pos=corpseEnt:GetPos()+corpseEnt:GetUp()*90+corpseEnt:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0); extraent:SetColor(Color(90,90,90)) end)
	end

	if self.HasGibOnDeathEffects == true then
		ParticleEffect("vj_explosion3",corpseEnt:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",corpseEnt:GetPos() +corpseEnt:GetForward()*-130,Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",corpseEnt:GetPos() +corpseEnt:GetForward()*130,Angle(0,0,0),nil)
		ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,corpseEnt,8)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,1)
		
		local explosioneffect = EffectData()
		explosioneffect:SetOrigin(corpseEnt:GetPos())
		util.Effect("VJ_Medium_Explosion1",explosioneffect)
		util.Effect("Explosion", explosioneffect)
		
		local dusteffect = EffectData()
		dusteffect:SetOrigin(corpseEnt:GetPos())
		dusteffect:SetScale(800)
		util.Effect("ThumperDust",dusteffect)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.IdleLP:Stop()
	self.FireLP:Stop()
	timer.Remove("vj_timer_fire_" .. self:EntIndex())
end