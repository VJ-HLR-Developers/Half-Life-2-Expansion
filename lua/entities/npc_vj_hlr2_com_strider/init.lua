AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/strider.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other

ENT.BloodColor = "White" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.Immune_Bullet = true
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Dissolve = true
ENT.Immune_Fire = true

ENT.PoseParameterLooking_InvertYaw = true
ENT.PoseParameterLooking_Names = {pitch={"minigunPitch"},yaw={"minigunYaw"},roll={}}

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 100 -- How far does the damage go?
ENT.MeleeAttackDamage = 150
ENT.TimeUntilMeleeAttackDamage = false

ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
ENT.IdleSoundVolume = 150
ENT.IdleCombatSoundVolume = 150
ENT.AlertSoundVolume = 150
ENT.BeforeMeleeAttackSoundVolume = 150
ENT.PainSoundVolume = 150
ENT.DeathSoundVolume = 150

ENT.NoChaseAfterCertainRange = false -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 5000
ENT.NoChaseAfterCertainRange_CloseDistance = 400
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack

ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 5000 -- How close does it have to be until it starts to face the enemy?

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Combine_Strider.Neck_Bone", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(8, 0, -60), -- The offset for the controller when the camera is in first person
}

ENT.CanFlinch = 2 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 1
ENT.NextFlinchTime = 2
ENT.AnimTbl_Flinch = {"dodgeleft","dodgeright"} -- If it uses normal based animation, use this
-- ENT.AnimTbl_Flinch = {"vjges_flinch_gesture","vjges_flinch_gesture2","vjges_flinch_gesture_big"} -- If it uses normal based animation, use this

ENT.SoundTbl_FootStep = {
	"NPC_Strider.Footstep"
	-- "npc/strider/strider_step1.wav",
	-- "npc/strider/strider_step2.wav",
	-- "npc/strider/strider_step3.wav",
	-- "npc/strider/strider_step4.wav",
	-- "npc/strider/strider_step5.wav",
	-- "npc/strider/strider_step6.wav",
}
ENT.SoundTbl_Alert = {
	-- "NPC_Strider.Alert"
	"npc/strider/striderx_alert2.wav",
	"npc/strider/striderx_alert4.wav",
	"npc/strider/striderx_alert5.wav",
	"npc/strider/striderx_alert6.wav",
}
ENT.SoundTbl_IdleCombat = {
	"NPC_Strider.Hunt"
}
ENT.SoundTbl_BeforeMeleeAttack = {
	-- "NPC_Strider.Creak"
	"npc/strider/creak1.wav",
	"npc/strider/creak2.wav",
	"npc/strider/creak3.wav",
	"npc/strider/creak4.wav",
}
ENT.SoundTbl_Pain = {
	-- "NPC_Strider.Pain"
	"npc/strider/striderx_pain2.wav",
	"npc/strider/striderx_pain5.wav",
	"npc/strider/striderx_pain7.wav",
	"npc/strider/striderx_pain8.wav",
}
ENT.SoundTbl_Death = {
	-- "NPC_Strider.Death",
	"npc/strider/striderx_die1.wav"
}

ENT.MinigunDelay = 0.1
ENT.MinigunSpread = 15
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSightDirection()
	return self:GetAttachment(self:LookupAttachment("eyes")).Ang:Forward()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- self:SetCollisionBounds(Vector(35,35,42),Vector(-35,-35,-500)) // For default strider model
	self:SetCollisionBounds(Vector(35,35,500),Vector(-35,-35,0))
	VJ.CreateBoneFollower(self)

	self.NextFireT = 0
	self.NextWarpT = 0
	self.NextRandMoveT = 0
	self.Shots = 0
	self.LastSawEnemyPosition = nil
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
function ENT:CustomOnThink()
	if !self.VJ_IsBeingControlled then
		if IsValid(self:GetEnemy()) && self:GetEnemy():Visible(self) then
			self.LastSawEnemyPosition = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
			self.DisableChasingEnemy = true
			if CurTime() > self.NextRandMoveT then
				local checkdist = self:VJ_CheckAllFourSides(1000)
				local randmove = {}
				if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
				if checkdist.Right == true then randmove[#randmove+1] = "Right" end
				if checkdist.Left == true then randmove[#randmove+1] = "Left" end
				local pickmove = VJ.PICK(randmove)
				if pickmove == "Backward" then self:SetLastPosition(self:GetPos() +self:GetForward() *1000) end
				if pickmove == "Right" then self:SetLastPosition(self:GetPos() +self:GetRight() *1000) end
				if pickmove == "Left" then self:SetLastPosition(self:GetPos() +self:GetRight() *1000) end
				if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.ConstantlyFaceEnemy = true end)
					self.NextRandMoveT = CurTime() +math.Rand(2,4)
				end
			end
		else
			self.DisableChasingEnemy = false
		end
	else
		self.DisableChasingEnemy = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTrace(tPos)
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("WarpCannon")).Pos
	tracedata.endpos = tPos +Vector(math.Rand(-50,50),math.Rand(-50,50),math.Rand(-50,50))
	tracedata.filter = {self}
	return util.TraceLine(tracedata).HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WarpCannon(tPos)
	local attackpos = self:DoTrace(tPos)

	local beam = EffectData()
	beam:SetStart(self:GetAttachment(2).Pos)
	beam:SetOrigin(attackpos)
	beam:SetEntity(self)
	beam:SetAttachment(2)
	util.Effect("VJ_HLR_StriderBeam",beam)
	
	local hitTime = 1 /math.min(1,self:GetAttachment(2).Pos:Distance(attackpos) /10000)
	hitTime = math.Clamp(hitTime,0,1) ^0.5
	timer.Simple(hitTime,function()
		if IsValid(self) then
			VJ.ApplyRadiusDamage(self,self,attackpos,300,500,bit.bor(DMG_DISSOLVE,DMG_BLAST),true,false,{Force=175})
			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness", "8")
			FireLight1:SetKeyValue("distance", "300")
			FireLight1:SetPos(self:GetAttachment(self:LookupAttachment("WarpCannon")).Pos)
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
	timer.Simple(0.5,function()
		if IsValid(self) then
			VJ.EmitSound(self,"npc/strider/fire.wav",130,self:VJ_DecideSoundPitch(100,110))

			ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,2)
			timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness", "4")
			FireLight1:SetKeyValue("distance", "120")
			FireLight1:SetPos(self:GetAttachment(self:LookupAttachment("WarpCannon")).Pos)
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
	self.NextFireT = CurTime() +4
	self.NextWarpT = CurTime() +(self:Health() <= self:GetMaxHealth() *0.5 && math.Rand(8,15) or (doLastPos && math.Rand(8,15) or math.Rand(20,40)))
	VJ.CreateSound(self,"npc/strider/charging.wav",110)

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
	muz:Fire("SetParentAttachment","WarpCannon")
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",SoundDuration("npc/strider/charging.wav") +0.3)

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
	pinch:Fire("SetParentAttachment","WarpCannon")
	pinch:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	pinch:Spawn()
	pinch:Activate()
	pinch:Fire("Kill","",SoundDuration("npc/strider/charging.wav") +1)

	local target = self:GetEnemy()
	local targetPos = self:GetPos() +self:GetForward() *800
	if IsValid(target) then
		targetPos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
	end
	if doLastPos then
		targetPos = self.LastSawEnemyPosition != nil && self.LastSawEnemyPosition or self:GetPos() +self:GetForward() *800
	end
	sound.EmitHint(SOUND_DANGER, targetPos, 500, SoundDuration("npc/strider/charging.wav") +1, self)

	timer.Simple(SoundDuration("npc/strider/charging.wav"),function()
		if IsValid(self) then
			local target = self:GetEnemy()
			local targetPos = self:GetPos() +self:GetForward() *800
			if IsValid(target) then
				targetPos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
			end
			if doLastPos then
				targetPos = self.LastSawEnemyPosition != nil && self.LastSawEnemyPosition or self:GetPos() +self:GetForward() *800
			end
			self:WarpCannon(targetPos)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControllAI(enemy,dist,cos)
	local rmb = self.VJ_TheController:KeyDown(IN_ATTACK2)
	local space = self.VJ_TheController:KeyDown(IN_JUMP)
	if enemy:Visible(self) && cos then
		if rmb then
			if CurTime() > self.NextFireT then
				if self.Shots == 15 then
					self.NextFireT = CurTime() +2
					self.Shots = 0
					self.MinigunDelay = math.random(1,3) == 1 && 0.08 or 0.1
					return
				end
				local bullet = {}
				bullet.Num = 1
				bullet.Src = self:GetAttachment(self:LookupAttachment("MiniGun")).Pos
				bullet.Dir = (self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()) -self:GetAttachment(self:LookupAttachment("MiniGun")).Pos +Vector(math.random(-self.MinigunSpread,self.MinigunSpread) -self.Shots,math.random(-self.MinigunSpread,self.MinigunSpread) -self.Shots,math.random(-self.MinigunSpread,self.MinigunSpread) -self.Shots)
				bullet.Spread = self.MinigunSpread -self.Shots
				bullet.Tracer = 1
				bullet.TracerName = "AR2Tracer"
				bullet.Force = 3
				bullet.Damage = 5
				bullet.AmmoType = "AR2"
				self:FireBullets(bullet)
				self.Shots = self.Shots +1

				-- VJ.EmitSound(self,{"npc/strider/strider_minigun.wav","npc/strider/strider_minigun2.wav"},110,100)
				VJ.EmitSound(self,"NPC_Strider.FireMinigun",110,100)

				local muz = ents.Create("env_sprite")
				muz:SetKeyValue("model","effects/strider_muzzle.vmt")
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
				muz:Fire("SetParentAttachment","MiniGun")
				muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
				muz:Spawn()
				muz:Activate()
				muz:Fire("Kill","",0.09)
				
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

				self.NextFireT = CurTime() +self.MinigunDelay
			end
		end
		if space then
			if CurTime() > self.NextWarpT then
				self:StartWarpCannon()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	local controlled = self.VJ_IsBeingControlled
	local enemy = self:GetEnemy()
	if IsValid(enemy) then
		local dist = self.NearestPointToEnemyDistance
		local cos = (self:GetForward():Dot((enemy:GetPos() +enemy:OBBCenter() -self:GetPos() + self:OBBCenter()):GetNormalized()) > math.cos(math.rad(80)))
		if controlled then
			self:ControllAI(enemy,dist,cos)
			return
		end
		if dist <= self.NoChaseAfterCertainRange_FarDistance && dist >= self.NoChaseAfterCertainRange_CloseDistance then
			if enemy:Visible(self) && cos then
				if CurTime() > self.NextFireT then
					if self.Shots == 15 then
						self.NextFireT = CurTime() +2
						self.Shots = 0
						self.MinigunDelay = math.random(1,3) == 1 && 0.08 or 0.1
						return
					end
					local bullet = {}
					bullet.Num = 1
					bullet.Src = self:GetAttachment(self:LookupAttachment("MiniGun")).Pos
					bullet.Dir = (self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()) -self:GetAttachment(self:LookupAttachment("MiniGun")).Pos +Vector(math.random(-self.MinigunSpread,self.MinigunSpread) -self.Shots,math.random(-self.MinigunSpread,self.MinigunSpread) -self.Shots,math.random(-self.MinigunSpread,self.MinigunSpread) -self.Shots)
					bullet.Spread = self.MinigunSpread -self.Shots
					bullet.Tracer = 1
					bullet.TracerName = "AR2Tracer"
					bullet.Force = 3
					bullet.Damage = 5
					bullet.AmmoType = "AR2"
					self:FireBullets(bullet)
					self.Shots = self.Shots +1

					-- VJ.EmitSound(self,{"npc/strider/strider_minigun.wav","npc/strider/strider_minigun2.wav"},110,100)
					VJ.EmitSound(self,"NPC_Strider.FireMinigun",110,100)

					local muz = ents.Create("env_sprite")
					muz:SetKeyValue("model","effects/strider_muzzle.vmt")
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
					muz:Fire("SetParentAttachment","MiniGun")
					muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
					muz:Spawn()
					muz:Activate()
					muz:Fire("Kill","",0.09)
					
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

					self.NextFireT = CurTime() +self.MinigunDelay
				end
				if CurTime() > self.NextWarpT && math.random(1,100) == 1 then
					self:StartWarpCannon()
				end
			elseif !enemy:Visible(self) && cos then
				if CurTime() > self.NextWarpT && math.random(1,20) == 1 && (self:GetEnemyLastKnownPos() != defPos) then
					self:StartWarpCannon(true)
				end
			end
		end
	end
end