AddCSLuaFile("shared.lua")
include("shared.lua")
/*
	Barnacle is very fucking annoying to mess with. I'm not fucking with it. The model has been modified to use pose-
	parameters and it has events, so have fun.
*/
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
-- ENT.Model = {"models/barnacle.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.Model = {"models/vj_hlr/hl2/barnacle.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.SightDistance = 1024 -- How far it can see
ENT.SightAngle = 360
ENT.StartHealth = 30
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How the NPC moves around
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.HullType = HULL_SMALL_CENTERED
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = VJ.BLOOD_COLOR_RED -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 10 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDistance = 30 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the NPC | 180 = All around the NPC
ENT.MeleeAttackDamageAngleRadius = 180 -- What is the damage angle radius? | 100 = In front of the NPC | 180 = All around the NPC

ENT.CanReceiveOrders = false -- Can the NPC receive orders from others? | Ex: Allies calling for help, allies requesting backup on damage, etc.
ENT.BringFriendsOnDeath = false -- Should the NPC's allies come to its position while it's dying?
ENT.AlertFriendsOnDeath = true -- Should the NPC's allies get alerted while it's dying? | Its allies will also need to have this variable set to true!
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForHelp = false -- Can the NPC request allies for help while in combat?
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathCorpseEntityClass = "prop_vj_animatable" -- Corpse's class | false = Let the base automatically detect the class
	-- ====== Sound Paths ====== --
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
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:DrawShadow(false)
	corpseEnt:SetPoseParameter("tongue_height", self.Barnacle_LastHeight)
	self:SetBoneController(0,self.Barnacle_LastHeight)
	corpseEnt:ResetSequence("Death")
	corpseEnt:SetCycle(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(18,18,10),Vector(-18,-18,-50))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
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

	if IsValid(trent) && (trent:IsNPC() or trent:IsPlayer()) && self:CheckRelationship(trent) == D_HT && trent.VJTag_ID_Boss != true then
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
				VJ.EmitSound(self, "vj_hlr/hl1_npc/barnacle/bcl_alert2.wav")
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
function ENT:OnThinkActive()
	if self.Dead then return end
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
/*function ENT:CustomAttackCheck_MeleeAttack()
	return IsValid(self.Barnacle_CurEnt)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent, inflictor, wasLast)
	VJ.EmitSound(self, "vj_hlr/hl1_npc/barnacle/bcl_bite3.wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		self:Barnacle_ResetEnt()
	elseif status == "Finish" then
		self:SetPos(self:GetPos() + self:GetUp()*-4)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodeffect:SetColor(VJ.Color2Byte(Color(130,19,10)))
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
	
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = true}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:Barnacle_ResetEnt()
end