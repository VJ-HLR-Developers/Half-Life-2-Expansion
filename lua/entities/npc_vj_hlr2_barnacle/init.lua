AddCSLuaFile("shared.lua")
include('shared.lua')
/*
	Barnacle is very fucking annoying to mess with. I'm not fucking with it. The model has been modified to use pose-
	parameters and it has events, so have fun.
*/
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
-- ENT.Model = {"models/barnacle.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.Model = {"models/vj_hlr/hl2/barnacle.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.SightDistance = 1024 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.StartHealth = 30
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.HullType = HULL_SMALL_CENTERED
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 10 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.MeleeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageAngleRadius = 180 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC

ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.DeathCorpseEntityClass = "prop_vj_animatable" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/barnacle/bcl_tongue1.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/barnacle/bcl_chew1.wav","vj_hlr/hl1_npc/barnacle/bcl_chew2.wav","vj_hlr/hl1_npc/barnacle/bcl_chew3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/barnacle/bcl_die1.wav","vj_hlr/hl1_npc/barnacle/bcl_die3.wav"}

ENT.GeneralSoundPitch1 = 100

	-- Custom
ENT.Barnacle_LastHeight = 180
ENT.Barnacle_CurEnt = NULL
ENT.Barnacle_CurEntMoveType = MOVETYPE_WALK
ENT.Barnacle_Status = 0
ENT.Barnacle_NextPullSoundT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt:DrawShadow(false)
	corpseEnt:SetPoseParameter("tongue_height", self.Barnacle_LastHeight)
	self:SetBoneController(0,self.Barnacle_LastHeight)
	corpseEnt:ResetSequence("Death")
	corpseEnt:SetCycle(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(18,18,10),Vector(-18,-18,-50))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "melee_attack" then
		self:MeleeAttackCode()
	end
	if key == "death_gibs" then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_bone.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_gib.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_guts.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_hmeat.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_lung.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_legbone.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-25))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("SetupMove","VJ_Barnacle_SetupMove", function(ply, mv)
	-- Make the player not be able to walk
	if ply.Barnacle_Grabbed == true then
    	mv:SetMaxClientSpeed(0)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Barnacle_CalculateTongue()
	-- print(self:GetBoneController(0))
	-- print(self.Barnacle_LastHeight)
	-- print(self:GetPoseParameter("tongue_height"))
	-- self:SetPoseParameter("tongue_height",0)
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +self:GetUp() *-1024,
		filter = self
	})
	local trent = tr.Entity
	local trpos = tr.HitPos
	local height = self:GetPos():Distance(trpos) +250
	self.Barnacle_LastHeight = math.Clamp(height,128,1024)
	self:SetPoseParameter("tongue_height",-math.Clamp(height,-128,1024))

	if IsValid(trent) && (trent:IsNPC() or trent:IsPlayer()) && self:DoRelationshipCheck(trent) == true && trent.VJ_IsHugeMonster != true then
		-- If the grabbed enemy is a new enemy then reset the enemy values
		if self.Barnacle_CurEnt != trent then
			self:Barnacle_ResetEnt()
			self.Barnacle_CurEntMoveType = trent:GetMoveType()
		end
		self.Barnacle_CurEnt = trent
		trent.Barnacle_Grabbed = true
		if trent:IsNPC() then
			trent:StopMoving()
			trent:SetVelocity(Vector(0,0,2))
			trent:SetMoveType(MOVETYPE_FLY)
			if trent.IsVJBaseSNPC == true then
				trent:SetState(VJ_STATE_FREEZE, 10)
			end
		elseif trent:IsPlayer() then
			trent:SetMoveType(MOVETYPE_NONE)
		end
		trent:SetGroundEntity(NULL)
		if height >= 50 then
			local setpos = trent:GetPos() + trent:GetUp()*10
			setpos.x = trpos.x
			setpos.y = trpos.y
			trent:SetPos(setpos) -- Set the position for the enemy
			-- Play the pulling sound
			if CurTime() > self.Barnacle_NextPullSoundT then
				VJ_EmitSound(self, "vj_hlr/hl1_npc/barnacle/bcl_alert2.wav")
				self.Barnacle_NextPullSoundT = CurTime() + SoundDuration("vj_hlr/hl1_npc/barnacle/bcl_alert2.wav")
			end
		end
		-- self:SetPoseParameter("tongue_height",self.Barnacle_LastHeight)
		-- self:SetBoneController(0,-(self:GetPos():Distance(trpos + self:GetUp()*125)))
		return true
	else
		self:Barnacle_ResetEnt()
	end
	-- self:SetPoseParameter("tongue_height",self.Barnacle_LastHeight)
	-- self:SetBoneController(0,-(self:GetPos():Distance(trpos + self:GetUp()*193)))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Barnacle_ResetEnt()
	if !IsValid(self.Barnacle_CurEnt) then return end
	self.Barnacle_CurEnt.Barnacle_Grabbed = false
	self.Barnacle_CurEnt:SetMoveType(self.Barnacle_CurEntMoveType) -- Reset the enemy's move type
	self.Barnacle_CurEnt = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	local calc = self:Barnacle_CalculateTongue()
	if calc == true && self.Barnacle_Status != 1 then
		self.Barnacle_Status = 1
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {ACT_BARNACLE_PULL}
	elseif calc == false && self.Barnacle_Status != 0 then
		self.Barnacle_Status = 0
		self.NextIdleStandTime = 0
		self.AnimTbl_IdleStand = {ACT_IDLE}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetDynamicOrigin()
	return self:GetPos() + self:GetUp()*-100 -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetMeleeAttackDamageOrigin()
	return self:GetPos() + self:GetUp()*-100 -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:CustomAttackCheck_MeleeAttack()
	return IsValid(self.Barnacle_CurEnt)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(ent, attacker, inflictor)
	VJ_EmitSound(self, "vj_hlr/hl1_npc/barnacle/bcl_bite3.wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialKilled(dmginfo, hitgroup)
	self:Barnacle_ResetEnt()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	self:SetPos(self:GetPos() + self:GetUp()*-4)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,-20))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:Barnacle_ResetEnt()
end