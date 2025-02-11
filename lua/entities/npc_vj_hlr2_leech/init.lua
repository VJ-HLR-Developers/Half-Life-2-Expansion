AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/leech.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 15
ENT.HullType = HULL_TINY
ENT.AA_ConstantlyMove = true
ENT.TurningUseAllAxis = true -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.MovementType = VJ_MOVETYPE_AQUATIC -- How the NPC moves around
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 200 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.Aquatic_AnimTbl_Calm = {ACT_IDLE} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {ACT_IDLE} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.HasBloodPool = false
ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.MeleeAttackDamage = 1
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 40 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 20 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.HasDeathCorpse = false
ENT.PropInteraction = false
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/leech/leech_alert1.wav","vj_hlr/hl1_npc/leech/leech_alert2.wav"}
//ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/leech/leech_alert1.wav","vj_hlr/hl1_npc/leech/leech_alert2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/leech/leech_bite1.wav","vj_hlr/hl1_npc/leech/leech_bite2.wav","vj_hlr/hl1_npc/leech/leech_bite3.wav"}

-- Custom
ENT.Leech_FollowOffsetPos = 0

Leech_Leader = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(4,4,3),Vector(-4,-4,-2))
	self.Leech_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))
	if !IsValid(Leech_Leader) then
		Leech_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !self.Dead && self:WaterLevel() == 0 then
		self:TakeDamage(1,self,self)
	end
	if IsValid(Leech_Leader) then
		if Leech_Leader != self then
			self.DisableWandering = true
			self.AA_ConstantlyMove = false
			if !IsValid(self:GetEnemy()) then
				self:AA_MoveTo(Leech_Leader, true, "Calm", {AddPos=self.Leech_FollowOffsetPos}) -- Medzavorin haladz e (Kharen deghme)
			end
		end
	else
		self.DisableWandering = false
		self.AA_ConstantlyMove = true
		Leech_Leader = self
	end
end