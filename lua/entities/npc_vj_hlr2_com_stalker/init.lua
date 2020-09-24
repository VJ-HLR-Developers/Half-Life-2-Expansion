AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/stalker_ep2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)

ENT.HasMeleeAttack = false

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 1600 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {
	"npc/stalker/stalker_footstep_left1.wav",
	"npc/stalker/stalker_footstep_left2.wav",
	"npc/stalker/stalker_footstep_right1.wav",
	"npc/stalker/stalker_footstep_right2.wav",
}
ENT.SoundTbl_Idle = {
	"npc/stalker/breathing3.wav",
	"npc/stalker/stalker_alert1b.wav",
	"npc/stalker/stalker_alert2b.wav",
	"npc/stalker/stalker_alert3b.wav",
	"npc/stalker/stalker_ambient01.wav",
}
ENT.SoundTbl_Alert = {
	"npc/stalker/stalker_scream1.wav",
	"npc/stalker/stalker_scream2.wav",
	"npc/stalker/stalker_scream3.wav",
	"npc/stalker/stalker_scream4.wav",
}
ENT.SoundTbl_CallForHelp = {
	"npc/stalker/go_alert2a.wav",
}
ENT.SoundTbl_Pain = {
	"npc/stalker/stalker_pain1.wav",
	"npc/stalker/stalker_pain2.wav",
	"npc/stalker/stalker_pain3.wav",
}
ENT.SoundTbl_Death = {
	"npc/stalker/stalker_die1.wav",
	"npc/stalker/stalker_die2.wav",
}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20,20,65),Vector(-20,-20,0))
	self.Laser = CreateSound(self,"npc/stalker/laser_burn.wav")
	self.Laser:SetSoundLevel(75)
	self.NextLAnimT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FireLaser()
	if IsValid(self:GetEnemy()) then
		local startpos =  self:GetAttachment(1).Pos
		local tr = util.TraceLine({
			start = self:GetAttachment(1).Pos,
			endpos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() +VectorRand() *4,
			filter = self
		})
		local hitpos = tr.HitPos

		if tr.Hit then
			local elec = EffectData()
			elec:SetStart(startpos)
			elec:SetOrigin(hitpos)
			elec:SetEntity(self)
			elec:SetAttachment(1)
			util.Effect("VJ_HLR_StalkerBeam",elec)

			util.VJ_SphereDamage(self,self,hitpos,30,2,DMG_BURN,true,false,{Force=1})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LaserReset()
	self.IsLaserAttacking = false
	self.Laser:Stop()
	self:StopAttacks(true)
	self.NextChaseTime = CurTime()
	self.NextIdleTime = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.IsLaserAttacking then
		if CurTime() > self.NextLAnimT then
			self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1,true,false,true)
			self.NextLAnimT = CurTime() +self:SequenceDuration(self:LookupSequence("rangeattack")) -0.1
		end
		self:FireLaser()
		if !self.Laser:IsPlaying() then
			self.Laser:Play()
		end
	else
		self.NextLAnimT = 0
	end
	if !self.VJ_IsBeingControlled then
		local ent = self:GetEnemy()
		if IsValid(ent) then
			if self:Visible(ent) && ent:GetPos():Distance(self:GetPos()) < self.NoChaseAfterCertainRange_FarDistance then
				if !self.IsLaserAttacking then
					self.IsLaserAttacking = true
					VJ_EmitSound(self,"vj_hlr/hl2_npc/beta_stalker/laser_start.wav",70,100)
				end
			else
				if self.IsLaserAttacking then
					self:LaserReset()
				end
			end
		end
	else
		if self.VJ_TheController:KeyDown(IN_ATTACK2) then
			if !self.IsLaserAttacking then
				self.IsLaserAttacking = true
				VJ_EmitSound(self,"vj_hlr/hl2_npc/beta_stalker/laser_start.wav",70,100)
			end
		else
			if self.IsLaserAttacking then
				self:LaserReset()
			end
		end
	end
	if !IsValid(self:GetEnemy()) || IsValid(self:GetEnemy()) && self:GetEnemy():Health() <= 0 then
		if self.IsLaserAttacking then
			self:LaserReset()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.Laser:Stop()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/