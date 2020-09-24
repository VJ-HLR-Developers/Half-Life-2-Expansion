AddCSLuaFile("shared.lua")
include("movetype_aa.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/advisor_ep2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1000
ENT.HullType = HULL_TINY
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 200 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 325
ENT.Aerial_AnimTbl_Calm = {ACT_IDLE} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {ACT_IDLE_ANGRY} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 120 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 170 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 55

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
	{ent="npc_vj_hlr2_com_elite",offset=0,weapons={"weapon_vj_ar2"}},
	{ent="npc_vj_hlr2_com_engineer",offset=0,weapons={"weapon_vj_hlr2_reager"}},
}

util.AddNetworkString("VJ_HLR_AdvisorScreenFX")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(38,38,30), Vector(-38,-38,-30))
	
	self.NextScreenBlastT = CurTime() +math.Rand(3,8)
	self.NextSearchForEntitiesT = 0
	self.tbl_HeldEntities = {}
	self.NextSpawnT = CurTime()
	
	self:ShieldCode(true)

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
function ENT:ShieldCode(bEnable)
	self.HasShield = bEnable
	if bEnable then
		ParticleEffectAttach("advisor_psychic_shield_idle",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.ShieldHealth = 300
		self.CustomBlood_Particle = {"hunter_shield_impact"}
		return
	end
	self.CustomBlood_Particle = {nil}
	self:StopParticles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
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
	VJ_EmitSound(self,"vj_hlr/hl2_npc/advisor/advisor_blast6.wav")
	VJ_EmitSound(ent,"ambient/energy/whiteflash.wav")
	ent:GetPhysicsObject():ApplyForceCenter(ent:GetPos() +Vector(0,0,ent:GetPhysicsObject():GetMass() *1.5))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.AA_MoveTimeCur > CurTime() then
		local remaining = self.AA_MoveTimeCur -CurTime()
		if remaining < 1.75 then
			self:AAMove_Stop()
		end
	end

	if CurTime() > self.NextScreenBlastT && math.random(1,20) == 1 && GetConVarNumber("ai_ignoreplayers") == 0 then
		for _,v in pairs(player.GetAll()) do
			net.Start("VJ_HLR_AdvisorScreenFX")
				net.WriteEntity(v)
				net.WriteFloat(v:GetPos():Distance(self:GetPos()))
			net.Send(v)
		end
		self.NextScreenBlastT = CurTime() +math.Rand(5,12)
	end
	-- if IsValid(self:GetEnemy()) then
		if CurTime() > self.NextSearchForEntitiesT then
			for _,v in ipairs(ents.FindInSphere(self:GetPos(),750)) do
				if v:GetClass() == "prop_physics" && !VJ_HasValue(self.tbl_HeldEntities,v) then
					if IsValid(v:GetPhysicsObject()) && v:GetPhysicsObject():GetMass() <= 1500 && v:Visible(self) then
						self:GrabEntity(v)
					end
				end
			end
		end
		if #self.tbl_HeldEntities > 0 then
			for _,v in ipairs(self.tbl_HeldEntities) do
				v:GetPhysicsObject():EnableGravity(false)
				-- if v:GetPos():Distance(self:GetPos()) > 750 then
					-- v:GetPhysicsObject():ApplyForceCenter((self:GetPos() -v:GetPos()):GetNormal() *v:GetPhysicsObject():GetMass())
				-- end -- Crashes
			end
		end
	-- end
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
	local type = VJ_PICK(self.Spawnables)
	local ally = ents.Create(type.ent)
	ally:SetPos(spawnpos +Vector(0,0,type.offset))
	ally:SetAngles(self:GetAngles())
	ally:Spawn()
	ally:Activate()
	if type.weapons then
		ally:Give(VJ_PICK(type.weapons))
		ally:GetActiveWeapon():Equip(ally)
	end
	
	ParticleEffect("aurora_shockwave",ally:GetPos(),Angle(0,0,0),nil)
	ParticleEffect("electrical_arc_01_system",ally:GetPos(),Angle(0,0,0),nil)
	VJ_EmitSound(ally,"ambient/energy/whiteflash.wav",90)
	return ally
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	if IsValid(self:GetEnemy()) && CurTime() > self.NextSpawnT && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self.NextSpawnT = CurTime() +self:SpawnAlly()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if #self.tbl_HeldEntities > 0 then
		for _,v in ipairs(self.tbl_HeldEntities) do
			if IsValid(v) then
				v:GetPhysicsObject():EnableGravity(true)
			end
		end
	end
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
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/