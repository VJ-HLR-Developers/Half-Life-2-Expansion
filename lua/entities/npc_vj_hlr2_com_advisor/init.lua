AddCSLuaFile("shared.lua")
include("movetype_aa.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/advisor_ep2.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 500
ENT.HullType = HULL_TINY
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Calm = 200 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 325
ENT.Aerial_AnimTbl_Calm = {ACT_IDLE} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {ACT_IDLE_ANGRY} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1 -- Melee Attack Animations
ENT.MeleeAttackDistance = 120 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 170 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 55

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.AnimTbl_RangeAttack = {ACT_MELEE_ATTACK1} -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_mortar" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.TimeUntilRangeAttackProjectileRelease = 0.7
ENT.NextRangeAttackTime = 10 -- How much time until it can use a range attack?
ENT.RangeDistance = 5000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 400 -- How close does it have to be until it uses melee?

ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds

ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it"s visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 7500

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "advisor.camera", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(8, 0, 4), -- The offset for the controller when the camera is in first person
}

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 4000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it"s able to range attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"ambient/atmosphere/city_beacon_loop1.wav"}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl2_npc/advisor/advisor_speak01.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl2_npc/advisor/advisorattack03.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl2_npc/advisor/pain.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl2_npc/advisor/advisor_scream.wav"}

ENT.BreathSoundLevel = 50

ENT.Spawnables = {
	{ent="npc_vj_hlr2_com_strider",offset=0,weapons=nil},
	{ent="npc_vj_hlr2_com_mortar",offset=50,weapons=nil},
	{ent="npc_vj_hlr2_com_crab",offset=0,weapons=nil},
	{ent="npc_vj_hlr2_com_hunter",offset=0,weapons=nil},
	{ent="npc_vj_hlr2_com_soldier",offset=0,weapons={"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2","weapon_vj_ar2"}},
	{ent="npc_vj_hlr2_com_shotgunner",offset=0,weapons={"weapon_vj_spas12"}},
	{ent="npc_vj_hlr2_com_elite",offset=0,weapons={"weapon_vj_ar2","weapon_vj_ar2","weapon_vj_hlr2_reager"}},
	-- {ent="npc_vj_hlr2_com_engineer",offset=0,weapons={"weapon_vj_hlr2_reager"}},
}

util.AddNetworkString("VJ_HLR_AdvisorScreenFX")

ENT.PsionicAttacking = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * 35 + self:GetForward() * 70
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	return self:CalculateProjectile("Curve", self:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), self:GetPos():Distance(self:GetEnemy():GetPos()))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(38,38,30), Vector(-38,-38,-30))
	
	self.NextScreenBlastT = CurTime() +math.Rand(3,8)
	self.NextSearchForEntitiesT = 0
	self.tbl_HeldEntities = {}
	self.NextSpawnT = CurTime()
	self.NextPsionicAttackT = CurTime() +math.Rand(2,4)
	
	self:ShieldCode(true)
	self:SetNW2Bool("PsionicEffect", false)

	local cont = true
	local EntsTbl = ents.GetAll()
	for x = 1,#EntsTbl do
		if EntsTbl[x]:GetClass() == self:GetClass() && EntsTbl[x] != self then
			cont = false
		end
	end
	if cont then
		self.OriginalGravity = GetConVarNumber("sv_gravity")
		RunConsoleCommand("sv_gravity",200)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetPsionicAttack()
	self.PsionicAttacking = false
	self.NextPsionicAttackT = CurTime() + math.Rand(4,7)
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
		ParticleEffectAttach("advisor_psychic_shield_idle",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.ShieldHealth = 1500
		self.CustomBlood_Particle = {"hunter_shield_impact"}
		return
	end
	self.CustomBlood_Particle = {"vj_impact1_yellow"}
	self:StopParticles()
	ParticleEffect("aurora_shockwave",self:GetPos() + self:OBBCenter(),Angle(0,0,0),nil)
	ParticleEffect("electrical_arc_01_system",self:GetPos() + self:OBBCenter(),Angle(0,0,0),nil)
	VJ.CreateSound(self,"ambient/energy/whiteflash.wav",120)
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),8000)) do
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
	timer.Simple(20,function()
		if IsValid(self) then
			self:ShieldCode(true)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if self.HasShield then
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
	table.insert(self.tbl_HeldEntities,ent)
	VJ.EmitSound(self,"vj_hlr/hl2_npc/advisor/advisor_blast6.wav")
	VJ.EmitSound(ent,"ambient/energy/whiteflash.wav")
	ent:GetPhysicsObject():ApplyForceCenter(ent:GetPos() +Vector(0,0,ent:GetPhysicsObject():GetMass() *1.5))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	if CurTime() > self.NextPsionicAttackT && self.LatestEnemyDistance <= 8500 && !self:BusyWithActivity() && self.PsionicAttacking == false && self:Visible(self:GetEnemy()) then
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
			VJ.EmitSound(self,"vj_hlr/hl2_npc/advisor/advisorattack03.wav", 95)
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
							VJ.EmitSound(self,"vj_hlr/hl2_npc/advisor/advisorattack02.wav", 95)
							v.BeingControlledByAdvisor = false
							v:SetNW2Bool("BeingControlledByAdvisor", false)
							phys:EnableGravity(true)
							phys:EnableDrag(true)
							if selfValid && IsValid(self:GetEnemy()) then -- We check self here, in case self is removed, we will reset the props at least
								local force = phys:GetMass() *math.random(3,8)
								phys:SetVelocity(self:CalculateProjectile("Line", v:GetPos(), self:GetEnemy():GetPos(), math.Clamp(force,3000,force)))
								-- self:VJ_ACT_PLAYACTIVITY(ACT_MELEE_ATTACK1, true, false, false)
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
function ENT:CustomOnThink()
	if self.AA_MoveTimeCur > CurTime() then
		local remaining = self.AA_MoveTimeCur -CurTime()
		if remaining < 2 then
			self:AA_StopMoving()
		end
	end

	if CurTime() > self.NextScreenBlastT && math.random(1,20) == 1 && !VJ_CVAR_IGNOREPLAYERS then
		for _,v in pairs(player.GetAll()) do
			net.Start("VJ_HLR_AdvisorScreenFX")
				net.WriteEntity(v)
				net.WriteFloat(v:GetPos():Distance(self:GetPos()))
			net.Send(v)
		end
		self.NextScreenBlastT = CurTime() +math.Rand(5,12)
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
		endpos = self:GetPos() +self:GetForward() *math.Rand(-10000,10000) +self:GetRight() *math.Rand(-10000,10000) +self:GetUp() *-1000,
		filter = self,
		mask = MASK_ALL,
	})

	local spawnpos = tr.HitPos +tr.HitNormal *30
	local type = VJ.PICK(self.Spawnables)
	local ally = ents.Create(type.ent)
	ally:SetPos(spawnpos +Vector(0,0,type.offset))
	ally:SetAngles(self:GetAngles())
	ally:Spawn()
	ally:Activate()
	if type.weapons then
		ally:Give(VJ.PICK(type.weapons))
		ally:GetActiveWeapon():Equip(ally)
	end
	
	ParticleEffect("aurora_shockwave",ally:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("electrical_arc_01_system",ally:GetPos(),Angle(0,0,0),nil)
	VJ.EmitSound(ally,"ambient/energy/whiteflash.wav",90)
	return ally
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead then return end
	for _,v in pairs(ents.FindInSphere(self:GetPos(),300)) do
		if string.find(v:GetClass(),"rocket") or string.find(v:GetClass(),"missile") then
			ParticleEffect("aurora_shockwave",v:GetPos(),Angle(0,0,0),nil)
			ParticleEffect("electrical_arc_01_system",v:GetPos(),Angle(0,0,0),nil)
			VJ.EmitSound(v,"ambient/energy/whiteflash.wav",90)
			-- if v.SetDeathVariablesTrue then v:SetDeathVariablesTrue({HitPos=v:GetPos()},nil,true) end
			-- v:Fire("Kill")
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
	for x = 1,#EntsTbl do
		if EntsTbl[x]:GetClass() == self:GetClass() && EntsTbl[x] != self then
			cont = false
		end
	end
	if cont then
		RunConsoleCommand("sv_gravity",self.OriginalGravity)
	end
end