AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.Model = {"models/vj_hlr/hl2/combine_helicopter.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 2000
ENT.HullType = HULL_LARGE
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 2 -- How fast it can turn

ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Alerted = 450 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Calm = 400 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {ACT_IDLE} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {ACT_IDLE} -- Animations it plays when it's moving while alerted
ENT.AA_GroundLimit = 1200 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 1000 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 8 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
ENT.AA_MoveDecelerate = 4 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x

ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch pose parameters (X)
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw pose parameters (Y)
ENT.PoseParameterLooking_Names = {pitch={"weapon_pitch"},yaw={"weapon_yaw"},roll={}}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.FindEnemy_UseSphere = true

ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.ImmuneDamagesTable = {DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN}

ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableRangeAttackAnimation = true
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_rocket" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.TimeUntilRangeAttackProjectileRelease = 0
ENT.NextRangeAttackTime = 5 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 10 -- How much time until it can use a range attack?
ENT.RangeDistance = 7500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeAttackExtraTimers = {1}

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathCorpseCollisionType = COLLISION_GROUP_NONE -- Collision type for the corpse | SNPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!

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
-- ENT.SoundTbl_Death = {"npc/attack_helicopter/aheli_crash_alert2.wav"}

ENT.AlertSoundLevel = 150
ENT.PainSoundLevel = 150
ENT.DeathSoundLevel = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line",self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos,self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(140,140,100),Vector(-140,-140,-75))
	self:SetPos(self:GetPos() +Vector(0,0,400))
	
	self.IdleLP = CreateSound(self,"npc/attack_helicopter/aheli_rotor_loop1.wav")
	self.IdleLP:SetSoundLevel(105)
	self.IdleLP:Play()
	self.IdleLP:ChangeVolume(1)
	
	self.FireLP = CreateSound(self,"npc/attack_helicopter/aheli_weapon_fire_loop3.wav")
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

	local eyeglow = ents.Create("env_sprite")
	eyeglow:SetKeyValue("model","sprites/light_glow01.vmt")
	eyeglow:SetKeyValue("scale","5")
	eyeglow:SetKeyValue("rendermode","9")
	eyeglow:SetKeyValue("rendercolor","225 225 225 0")
	eyeglow:SetKeyValue("spawnflags","1") -- If animated
	eyeglow:SetParent(self)
	eyeglow:Fire("SetParentAttachment","spotlight",0)
	eyeglow:Spawn()
	eyeglow:Activate()
	self:DeleteOnRemove(eyeglow)

	local spotlight = ents.Create("env_projectedtexture")
	spotlight:SetPos( self:GetPos() + Vector(0, 0, 0) )
	spotlight:SetAngles( self:GetAngles() + Angle(0,0,0) )
	spotlight:SetKeyValue("lightcolor", "225 225 225 255")
	spotlight:SetKeyValue("lightfov", "75")
	spotlight:SetKeyValue("farz", "2500")
	spotlight:SetKeyValue("nearz", "0.1")
	spotlight:SetKeyValue("enableshadows", "1")
	spotlight:SetKeyValue("shadowquality", "1")
	spotlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
	spotlight:SetOwner(self)
	spotlight:SetParent(self)
	spotlight:Spawn()
	spotlight:Activate()
	spotlight:Fire("setparentattachment", "spotlight")
	self:DeleteOnRemove(spotlight)
	
	self:CreateBoneFollowers()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(ent)
	self.RangeUseAttachmentForPosID = self.RangeUseAttachmentForPosID == "Damage0" && "Damage3" or "Damage0"
	VJ.CreateSound(ent,"weapons/rpg/rocketfire1.wav",80)
	VJ.CreateSound(ent,"vj_weapons/rpg/rpg_fire_far.wav",120)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BarrageFire()
	local bomb = self.CarpetBombing
	timer.Create("vj_timer_fire_" .. self:EntIndex(),0.1,50,function()
		if IsValid(self:GetEnemy()) && !self.Dead then
			if bomb then timer.Remove("vj_timer_fire_" .. self:EntIndex()) return end
			sound.EmitHint(SOUND_DANGER, self:GetEnemy():GetPos(), 250, 0.25, self)
			for i = 1,3 do
				local att = self:GetAttachment(2)
				local bullet = {}
				bullet.Num = 1
				bullet.Src = att.Pos
				bullet.Dir = (self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() -att.Pos):Angle():Forward()
				bullet.Callback = function(attacker, tr, dmginfo)
					local laserhit = EffectData()
					laserhit:SetOrigin(tr.HitPos)
					laserhit:SetNormal(tr.HitNormal)
					laserhit:SetScale(25)
					util.Effect("AR2Impact",laserhit)
					dmginfo:SetDamageType(bit.bor(2,4098,2147483648))
				end
				bullet.Spread = Vector(0.05,0.05,0)
				bullet.Tracer = 1
				bullet.TracerName = "AirboatGunTracer"
				bullet.Force = 3
				bullet.Damage = self:VJ_GetDifficultyValue(7)
				bullet.AmmoType = "AR2"
				self:FireBullets(bullet)
			end

			ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,2)
			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness",8)
			FireLight1:SetKeyValue("distance",300)
			FireLight1:SetLocalPos(self:GetAttachment(2).Pos)
			FireLight1:SetLocalAngles(self:GetAngles())
			FireLight1:Fire("Color","0 161 255 255")
			FireLight1:Spawn()
			FireLight1:Activate()
			FireLight1:Fire("TurnOn","",0)
			FireLight1:Fire("Kill","",0.07)
			self:DeleteOnRemove(FireLight1)
		else
			timer.Remove("vj_timer_fire_" .. self:EntIndex())
			self.NextFireT = CurTime() +1
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "explosion" then
		local pos,ang = self:GetBonePosition(0)
		VJ.EmitSound(self,"vj_fire/explosion2.wav",100,100)
		util.BlastDamage(self,self,pos,200,40)
		util.ScreenShake(pos, 100, 200, 1, 2500)
		if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",pos,Angle(0,0,0),nil) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	if self.CarpetBombing then
		self.NextChaseTime = CurTime() +1
	end
	self.HasRangeAttack = !self.CarpetBombing
	local ent = self:GetEnemy()
	if IsValid(ent) then
		local dist = self.NearestPointToEnemyDistance
		if self:Health() <= self:GetMaxHealth() *0.5 then
			if !self.CarpetBombing && CurTime() > self.NextCarpetBombT then
				self.CarpetBombing = true
				local entPos = ent:GetPos()
				entPos.z = self:GetPos().z
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos() +(entPos - self:GetPos()):GetNormalized() *7500,
					filter = self,
					mins = self:OBBMins(),
					maxs = self:OBBMaxs(),
				})
				self.CarpetBombPos = tr.HitPos +tr.HitNormal *100
				self.NextCarpetBombT = CurTime() +9999
			end
			if self.CarpetBombing then
				self:AA_MoveTo(self.CarpetBombPos, false, "Alert", {FaceDest=true, FaceDestTarget=false, IgnoreGround=true})
				local resMe, resPos = self:VJ_GetNearestPointToVector(self.CarpetBombPos, true)
				if resMe:Distance(resPos) <= 100 then
					self:AA_StopMoving()
					self.CarpetBombing = false
					self.NextCarpetBombT = CurTime() +math.Rand(30,60)
					return
				end
				self:SetEnemy(NULL)
				-- self:SetTurnTarget(self.CarpetBombPos)
				if CurTime() > self.NextDropCarpetT then
					local pos = {
						[1] = {SpawnPos=self:GetAttachment(3).Pos,Right=0},
						[2] = {SpawnPos=self:GetAttachment(3).Pos +self:GetRight() *50,Right=-1000},
						[3] = {SpawnPos=self:GetAttachment(3).Pos +self:GetRight() *-50,Right=1000}
					}
					for i = 1,3 do
						local bomb = ents.Create("grenade_helicopter")
						bomb:SetPos(pos[i].SpawnPos)
						bomb:Fire("ExplodeIn",3)
						bomb:Spawn()
						local phys = bomb:GetPhysicsObject()
						if IsValid(phys) then
							phys:SetVelocity(((self:GetPos() +Vector(0,0,-500) +self:GetRight() *pos[i].Right) -self:GetPos()))
						end
						constraint.NoCollide(bomb,self,0,0)
					end
					self.NextDropCarpetT = CurTime() +0.35
				end
			end
		end
		if self.CarpetBombing then return end
		if CurTime() > self.NextBombT then
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = (self:GetPos() +self:GetUp() *-15000),
				mins = Vector(-100,-100,-100),
				maxs = Vector(100,100,100),
				filter = self
			})
			if IsValid(tr.Entity) && self:Disposition(tr.Entity) == D_HT then
				local count = self:Health() <= self:GetMaxHealth() *0.5 && 3 or 1
				local pos = {
					[1] = self:GetAttachment(3).Pos,
					[2] = self:GetAttachment(3).Pos +self:GetRight() *50,
					[3] = self:GetAttachment(3).Pos +self:GetRight() *-50
				}
				for i = 1,count do
					local bomb = ents.Create("grenade_helicopter")
					bomb:SetPos(pos[i])
					bomb:Spawn()
					local offset = i > 1 && (tr.Entity:GetRight() *math.Rand(-400,400)) or Vector(0, 0, 0)
					local phys = bomb:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(((tr.Entity:GetPos() +offset) -bomb:LocalToWorld(Vector(0, 0, 0))))
					end
					constraint.NoCollide(bomb,self,0,0)
				end
			end
			self.NextBombT = CurTime() +math.Rand(2,4)
		end
		if dist <= 4000 && self:Visible(self:GetEnemy()) then
			if CurTime() > self.NextFireT then
				if !self.Charged then
					if !self.Charging then
						self.Charging = true
						VJ.EmitSound(self,"npc/attack_helicopter/aheli_charge_up.wav",105)
						timer.Simple(SoundDuration("npc/attack_helicopter/aheli_charge_up.wav"),function()
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
				self.NextFireT = CurTime() +10
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.ConstantlyFaceEnemy = !self.CarpetBombing
	self:SetPoseParameter("move_yaw", Lerp(FrameTime()*4, self:GetPoseParameter("move_yaw"), self:GetVelocity():GetNormal().y))
	
	if timer.Exists("vj_timer_fire_" .. self:EntIndex()) then
		self.FireLP:Play()
	else
		self.FireLP:Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,self,8)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,4)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,6)

	-- self:DoChangeMovementType(VJ_MOVETYPE_GROUND) // VJ_MOVETYPE_PHYSICS

	-- for i=0,1,0.5 do
		-- timer.Simple(i,function()
			-- if IsValid(self) then
				-- VJ.EmitSound(self,"vj_fire/explosion2.wav",100,100)
				-- util.BlastDamage(self,self,self:GetPos(),200,40)
				-- util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
				-- if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
			-- end
		-- end)
	-- end
	
	-- timer.Simple(1.5,function()
		-- if IsValid(self) then
			-- VJ.EmitSound(self,"vj_fire/explosion2.wav",100,100)
			-- VJ.EmitSound(self,"vj_fire/explosion3.wav",100,100)
			-- util.BlastDamage(self,self,self:GetPos(),200,40)
			-- util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			-- if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
		-- end
	-- end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	local pos,ang = self:GetBonePosition(0)
	corpseEnt:SetPos(pos)
	corpseEnt:GetPhysicsObject():SetVelocity(((self:GetPos() +self:GetRight() *-700 +self:GetForward() *-300 +self:GetUp() *-200) -self:GetPos()))
	util.BlastDamage(self, self, corpseEnt:GetPos(), 400, 40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)

	VJ.EmitSound(self,"vj_fire/explosion2.wav",100,100)
	VJ.EmitSound(self,"vj_fire/explosion3.wav",100,100)
	util.BlastDamage(self,self,corpseEnt:GetPos(),200,40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)
	if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",corpseEnt:GetPos(),Angle(0,0,0),nil) end

	if math.random(1,3) == 1 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/combine_soldier.mdl",{Pos=corpseEnt:GetPos()+corpseEnt:GetUp()*90+corpseEnt:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0); extraent:SetColor(Color(90,90,90)) end)
	end

	if self.HasGibDeathParticles == true then
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