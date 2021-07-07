AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/zombie_poison.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.BloodColor = "Yellow"
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}

ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 150 -- How far does the damage go?
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageType = bit.bor(DMG_POISON,DMG_ACID)

ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/bullchicken/bc_spithit1.wav","vj_hlr/hl1_npc/bullchicken/bc_spithit2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer()
	timer.Simple(self.TimeUntilMeleeAttackDamage,function()
		if IsValid(self) && self.MeleeAttacking then
			VJ_EmitSound(self,"vj_hlr/hl1_npc/bullchicken/bc_spithit3.wav")

			local pos,ang = self:GetBonePosition(53)
			ParticleEffect("antlion_gib_01",pos,ang,nil)
			-- local effectdata = EffectData()
			-- effectdata:SetOrigin(pos)
			-- effectdata:SetAngles(ang)
			-- effectdata:SetScale(1)
			-- util.Effect("StriderBlood",effectdata)
			-- util.Effect("StriderBlood",effectdata)
			-- util.Effect("StriderBlood",effectdata)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PoisonHeadcrabAttack(type)
	local throwpos = self:ChooseCrab()
	if type == "throw" then
		local dur = VJ_GetSequenceDuration(self,"ThrowWarning") -0.2
		self:VJ_ACT_PLAYACTIVITY("ThrowWarning",true,dur,false)
		timer.Simple(dur,function() if self:IsValid() && ((self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy())) or self.VJ_IsBeingControlled == true) then
			local throwdur = VJ_GetSequenceDuration(self,"Throw") -0.2
			self:VJ_ACT_PLAYACTIVITY("Throw",true,throwdur,false)
			timer.Simple(dur,function() if self:IsValid() && ((self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy())) or self.VJ_IsBeingControlled == true) then
				local crab = ents.Create("npc_vj_hlr2b_headcrab_poison")
				crab:SetPos(throwpos +Vector(0,0,18))
				crab:SetAngles(self:GetAngles())
				crab:Spawn()
				crab:Activate()
				crab:OnThrown(self:GetEnemy(),self)
				self.BlackHeadcrabs = self.BlackHeadcrabs -1
				self:StopAttacks()
			end end)
		end end)
	else
		local dur = VJ_GetSequenceDuration(self,"headcrab2Leap") -0.2
		self:VJ_ACT_PLAYACTIVITY("headcrab2Leap",true,dur,false)
		timer.Simple(dur,function() if self:IsValid() && ((self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy())) or self.VJ_IsBeingControlled == true) then
				local crab = ents.Create("npc_vj_hlr2b_headcrab_poison")
				crab:SetPos(throwpos +Vector(0,0,18))
				crab:SetAngles(self:GetAngles())
				crab:Spawn()
				crab:Activate()
				crab:OnThrown(self:GetEnemy(),self)
				self.BlackHeadcrabs = self.BlackHeadcrabs -1
				self:StopAttacks()
		end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	if self:GetBodygroup(1) == 0 then return false end
	local randcrab = math.random(1,3)
	local dmgtype = dmginfo:GetDamageType()
	if hitgroup == HITGROUP_HEAD then randcrab = math.random(1,2) end
	if dmgtype == DMG_CLUB or dmgtype == DMG_SLASH then randcrab = 1 end
	if randcrab == 1 then
		self:SetBodygroup(1,1)
	end
	if randcrab == 2 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/vj_hlr/hl2b/headcrab_poison.mdl",{Pos=self:GetPos() +Vector(0,0,self:OBBMaxs())})
		self.Corpse:SetBodygroup(1,0)
	end
	if randcrab == 3 then
		self.Corpse:SetBodygroup(1,0)
		local spawncrab = ents.Create("npc_vj_hlr2b_headcrab_poison")
		local enemy = self:GetEnemy()
		local pos = self:GetPos() +Vector(0,0,self:OBBMaxs())
		spawncrab:SetPos(pos)
		spawncrab:SetAngles(self:GetAngles())
		spawncrab:SetVelocity(dmginfo:GetDamageForce()/58)
		spawncrab:Spawn()
		spawncrab:Activate()
		if self.Corpse:IsOnFire() then spawncrab:Ignite(math.Rand(8,10),0) end
		timer.Simple(0.05,function()
			if spawncrab != nil then
				spawncrab:SetPos(pos)
				if IsValid(enemy) then spawncrab:SetEnemy(enemy) spawncrab:VJ_SetSchedule(SCHED_CHASE_ENEMY) end
			end
		end)
	end
end