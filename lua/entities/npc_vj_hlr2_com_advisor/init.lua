AddCSLuaFile("shared.lua")
include("movetype_aa.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2/advisor_ep2.mdl"
ENT.StartHealth = 500
ENT.HullType = HULL_TINY
ENT.VJ_ID_Boss = true
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 200
ENT.Aerial_FlyingSpeed_Alerted = 325
ENT.Aerial_AnimTbl_Calm = ACT_IDLE
ENT.Aerial_AnimTbl_Alerted = ACT_IDLE_ANGRY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.MeleeAttackDistance = 120
ENT.MeleeAttackDamageDistance = 170
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDamage = 55

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_MELEE_ATTACK1
ENT.RangeAttackProjectiles = "obj_vj_hlr2_mortar"
ENT.TimeUntilRangeAttackProjectileRelease = 0.7
ENT.NextRangeAttackTime = 10
ENT.RangeAttackMaxDistance = 5000
ENT.RangeAttackMinDistance = 400

ENT.HasExtraMeleeAttackSounds = true

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_IfVisible = true
ENT.ConstantlyFaceEnemy_IfAttacking = false
ENT.ConstantlyFaceEnemy_Postures = "Both"
ENT.ConstantlyFaceEnemy_MinDistance = 7500

ENT.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "advisor.camera",
    FirstP_Offset = Vector(8, 0, 4),
}

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = 4000
ENT.LimitChaseDistance_Min = 0

ENT.SoundTbl_Breath = {"ambient/atmosphere/city_beacon_loop1.wav"}
ENT.SoundTbl_Idle = {
	"vj_hlr/src/npc/advisor/advisor_speak01.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/src/npc/advisor/advisorattack03.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/src/npc/advisor/pain.wav"}
ENT.SoundTbl_Death = {"vj_hlr/src/npc/advisor/advisor_scream.wav"}

ENT.BreathSoundLevel = 50

ENT.Spawnables = {
	{ent="npc_vj_hlr2_com_strider", offset=0, weapons=nil},
	{ent="npc_vj_hlr2_com_mortar", offset=50, weapons=nil},
	{ent="npc_vj_hlr2_com_crab", offset=0, weapons=nil},
	{ent="npc_vj_hlr2_com_hunter", offset=0, weapons=nil},
	{ent="npc_vj_hlr2_com_soldier", offset=0, weapons={"weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_ar2", "weapon_vj_ar2"}},
	{ent="npc_vj_hlr2_com_shotgunner", offset=0, weapons={"weapon_vj_spas12"}},
	{ent="npc_vj_hlr2_com_elite", offset=0, weapons={"weapon_vj_ar2", "weapon_vj_ar2", "weapon_vj_hlr2_reager"}},
	-- {ent="npc_vj_hlr2_com_engineer", offset=0, weapons={"weapon_vj_hlr2_reager"}},
}

util.AddNetworkString("VJ_HLR_AdvisorScreenFX")

ENT.PsionicAttacking = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 35 + self:GetForward() * 70
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:CalculateProjectile("Curve", self:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), self:GetPos():Distance(self:GetEnemy():GetPos()))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(38, 38, 30), Vector(-38, -38, -30))
	
	self.NextScreenBlastT = CurTime() +math.Rand(3, 8)
	self.NextSearchForEntitiesT = 0
	self.tbl_HeldEntities = {}
	self.NextSpawnT = CurTime()
	self.NextPsionicAttackT = CurTime() +math.Rand(2, 4)
	
	self:ShieldCode(true)
	self:SetNW2Bool("PsionicEffect", false)

	local cont = true
	local EntsTbl = ents.GetAll()
	for x = 1, #EntsTbl do
		if EntsTbl[x]:GetClass() == self:GetClass() && EntsTbl[x] != self then
			cont = false
		end
	end
	if cont then
		self.OriginalGravity = GetConVarNumber("sv_gravity")
		RunConsoleCommand("sv_gravity", 200)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "melee" then
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetPsionicAttack()
	self.PsionicAttacking = false
	self.NextPsionicAttackT = CurTime() + math.Rand(4, 7)
	self:SetState()
	self:SetNW2Bool("PsionicEffect", false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_MeleeAttack() return self.PsionicAttacking != true end -- Not returning true will not let the melee attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack() return self.PsionicAttacking != true end -- Not returning true will not let the melee attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ShieldCode(bEnable)
	self.HasShield = bEnable
	if bEnable then
		ParticleEffectAttach("advisor_psychic_shield_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		self.ShieldHealth = 1500
		self.BloodParticle = {"hunter_shield_impact"}
		return
	end
	self.BloodParticle = {"vj_blood_impact_yellow"}
	self:StopParticles()
	ParticleEffect("vj_aurora_shockwave", self:GetPos() + self:OBBCenter(), Angle(0, 0, 0), nil)
	ParticleEffect("electrical_arc_01_system", self:GetPos() + self:OBBCenter(), Angle(0, 0, 0), nil)
	VJ.CreateSound(self, "ambient/energy/whiteflash.wav", 120)
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 8000)) do
		if VJ.IsProp(v) && self:Visible(v) then
			local phys = v:GetPhysicsObject()
			if IsValid(phys) && phys:GetMass() <= 6000 then
				constraint.RemoveConstraints(v, "Weld")
				phys:EnableMotion(true)
				phys:Wake()
				phys:EnableGravity(true)
				phys:EnableDrag(true)
				phys:ApplyForceCenter((v:GetPos() -self:GetPos()) *phys:GetMass())
			end
		end
	end
	timer.Simple(20, function()
		if IsValid(self) then
			self:ShieldCode(true)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && self.HasShield then
		self:RemoveAllDecals()
		self.ShieldHealth = self.ShieldHealth -dmginfo:GetDamage()
		dmginfo:SetDamage(0)
		if self.ShieldHealth <= 0 then
			self:ShieldCode(false)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrabEntity(ent)
	table.insert(self.tbl_HeldEntities, ent)
	VJ.EmitSound(self, "vj_hlr/src/npc/advisor/advisor_blast6.wav")
	VJ.EmitSound(ent, "ambient/energy/whiteflash.wav")
	ent:GetPhysicsObject():ApplyForceCenter(ent:GetPos() +Vector(0, 0, ent:GetPhysicsObject():GetMass() *1.5))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, enemy)
	if CurTime() > self.NextPsionicAttackT && self.EnemyData.Distance <= 8500 && !self:IsBusy("Activities") && self.PsionicAttacking == false && self:Visible(self:GetEnemy()) then
		//print("SEARCH ----")
		local pTbl = {} -- Table of props that it found
		for _, v in ipairs(ents.FindInSphere(self:GetEnemy():GetPos(), 2000)) do
			if VJ.IsProp(v) && self:Visible(v) && self:GetEnemy():Visible(v) then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) && phys:GetMass() <= 4000 && v.BeingControlledByAdvisor != true then
					//print("Prop -", v)
					pTbl[#pTbl + 1] = v
				end
			end
		end
		//print(pTbl)
		if #pTbl > 0 then -- If greater then 1, then we found an object!
			self:SetNW2Bool("PsionicEffect", true)
			VJ.EmitSound(self, "vj_hlr/src/npc/advisor/advisorattack03.wav", 95)
			self.PsionicAttacking = true
			self:SetState(VJ_STATE_ONLY_ANIMATION)
			for _, v in ipairs(pTbl) do
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					v.BeingControlledByAdvisor = true
					v:SetNW2Bool("BeingControlledByAdvisor", true)
					constraint.RemoveConstraints(v, "Weld")
					phys:EnableMotion(true)
					phys:Wake()
					phys:EnableGravity(false)
					phys:EnableDrag(false)
					phys:ApplyForceCenter(v:GetUp() *phys:GetMass())
					phys:AddAngleVelocity(v:GetForward() *600 + v:GetRight() *600)
				end
			end
			timer.Simple(3.42225, function()
				local selfValid = IsValid(self)
				for _, v in ipairs(pTbl) do
					if IsValid(v) then
						local phys = v:GetPhysicsObject()
						if IsValid(phys) then
							VJ.EmitSound(self, "vj_hlr/src/npc/advisor/advisorattack02.wav", 95)
							v.BeingControlledByAdvisor = false
							v:SetNW2Bool("BeingControlledByAdvisor", false)
							phys:EnableGravity(true)
							phys:EnableDrag(true)
							if selfValid && IsValid(self:GetEnemy()) then -- We check self here, in case self is removed, we will reset the props at least
								local force = phys:GetMass() *math.random(3, 8)
								phys:SetVelocity(self:CalculateProjectile("Line", v:GetPos(), self:GetEnemy():GetPos(), math.Clamp(force, 3000, force)))
								-- self:PlayAnim(ACT_MELEE_ATTACK1, true, false, false)
							end
						end
					end
				end
				if selfValid then self:ResetPsionicAttack() end -- Here so in case the prop is deleted, we make sure to still reset
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.AA_MoveTimeCur > CurTime() then
		local remaining = self.AA_MoveTimeCur -CurTime()
		if remaining < 2 then
			self:AA_StopMoving()
		end
	end

	if CurTime() > self.NextScreenBlastT && math.random(1, 20) == 1 && !VJ_CVAR_IGNOREPLAYERS then
		for _, v in pairs(player.GetAll()) do
			net.Start("VJ_HLR_AdvisorScreenFX")
				net.WriteEntity(v)
				net.WriteFloat(v:GetPos():Distance(self:GetPos()))
			net.Send(v)
		end
		self.NextScreenBlastT = CurTime() +math.Rand(5, 12)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnAlly()
	if !IsValid(self.Ally1) then
		self.Ally1 = self:CreateAlly()
		return 15
	elseif !IsValid(self.Ally2) then
		self.Ally2 = self:CreateAlly()
		return 15
	elseif !IsValid(self.Ally3) then
		self.Ally3 = self:CreateAlly()
		return 15
	elseif !IsValid(self.Ally4) then
		self.Ally4 = self:CreateAlly()
		return 15
	elseif !IsValid(self.Ally5) then
		self.Ally5 = self:CreateAlly()
		return 15
	end
	return 8
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateAlly()
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +self:GetForward() *math.Rand(-10000, 10000) +self:GetRight() *math.Rand(-10000, 10000) +self:GetUp() *-1000,
		filter = self,
		mask = MASK_ALL,
	})

	local spawnpos = tr.HitPos +tr.HitNormal *30
	local type = VJ.PICK(self.Spawnables)
	local ally = ents.Create(type.ent)
	ally:SetPos(spawnpos +Vector(0, 0, type.offset))
	ally:SetAngles(self:GetAngles())
	ally:Spawn()
	ally:Activate()
	if type.weapons then
		ally:Give(VJ.PICK(type.weapons))
		ally:GetActiveWeapon():Equip(ally)
	end
	
	ParticleEffect("vj_aurora_shockwave", ally:GetPos(), Angle(0, 0, 0), nil)
	ParticleEffect("electrical_arc_01_system", ally:GetPos(), Angle(0, 0, 0), nil)
	VJ.EmitSound(ally, "ambient/energy/whiteflash.wav", 90)
	return ally
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead then return end
	for _, v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
		if string.find(v:GetClass(), "rocket") or string.find(v:GetClass(), "missile") then
			ParticleEffect("vj_aurora_shockwave", v:GetPos(), Angle(0, 0, 0), nil)
			ParticleEffect("electrical_arc_01_system", v:GetPos(), Angle(0, 0, 0), nil)
			VJ.EmitSound(v, "ambient/energy/whiteflash.wav", 90)
			SafeRemoveEntity(v)
		end
	end
	if IsValid(self:GetEnemy()) && CurTime() > self.NextSpawnT && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self.NextSpawnT = CurTime() +self:SpawnAlly()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	local cont = true
	local EntsTbl = ents.GetAll()
	for x = 1, #EntsTbl do
		if EntsTbl[x]:GetClass() == self:GetClass() && EntsTbl[x] != self then
			cont = false
		end
	end
	if cont then
		RunConsoleCommand("sv_gravity", self.OriginalGravity)
	end
end