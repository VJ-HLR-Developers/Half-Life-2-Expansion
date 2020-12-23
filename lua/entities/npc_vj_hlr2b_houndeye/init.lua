AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/houndeye.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 80
ENT.HullType = HULL_WIDE_SHORT
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.Immune_Sonic = true -- Immune to sonic damage
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 130 -- How close does it have to be until it attacks?
ENT.TimeUntilMeleeAttackDamage = 2.35 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageType = DMG_SONIC -- Type of Damage
ENT.MeleeAttackDSPSoundType = 34 -- What type of DSP effect? | Search online for the types
ENT.MeleeAttackDSPSoundUseDamage = false -- Should it only do the DSP effect if gets damaged x or greater amount
ENT.DisableDefaultMeleeAttackDamageCode = true -- Disables the default mel	ee attack damage code
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"} -- If it uses normal based animation, use this

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "HoundEye.Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 0), -- The offset for the controller when the camera is in first person
}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav",
}
ENT.SoundTbl_CallForHelp = {"vj_hlr/hl2_npc/houndeye/he_bark_group_attack.wav"}
ENT.SoundTbl_OnReceiveOrder = {"vj_hlr/hl2_npc/houndeye/he_bark_group_attack_reply.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl2_npc/houndeye/he_bark_group_retreat.wav"}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl2_npc/houndeye/he_idle1.wav",
	"vj_hlr/hl2_npc/houndeye/he_idle2.wav",
	"vj_hlr/hl2_npc/houndeye/he_idle3.wav",
	"vj_hlr/hl2_npc/houndeye/he_idle4.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl2_npc/houndeye/he_alert1.wav",
	"vj_hlr/hl2_npc/houndeye/he_alert2.wav",
	"vj_hlr/hl2_npc/houndeye/he_alert3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl2_npc/houndeye/he_attack1.wav",
	"vj_hlr/hl2_npc/houndeye/he_attack2.wav",
	"vj_hlr/hl2_npc/houndeye/he_attack3.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl2_npc/houndeye/he_pain1.wav",
	"vj_hlr/hl2_npc/houndeye/he_pain2.wav",
	"vj_hlr/hl2_npc/houndeye/he_pain3.wav",
	"vj_hlr/hl2_npc/houndeye/he_pain4.wav",
	"vj_hlr/hl2_npc/houndeye/he_pain5.wav",
	"vj_hlr/hl2_npc/houndeye/he_yelp1.wav"
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl2_npc/houndeye/he_die1.wav",
	"vj_hlr/hl2_npc/houndeye/he_die2.wav",
	"vj_hlr/hl2_npc/houndeye/he_die3.wav",
}

ENT.FootStepSoundLevel = 80
ENT.FootStepPitch = VJ_Set(110, 115)
ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(17,17,40),Vector(-17,-17,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "hunt" then
		VJ_EmitSound(self,"vj_hlr/hl2_npc/houndeye/he_hunt"..math.random(1,4)..".wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 then
		self:VJ_ACT_PLAYACTIVITY({"vjseq_madidle1","vjseq_madidle2","vjseq_madidle3"},true,false,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks()
	effects.BeamRingPoint(self:GetPos() +Vector(0,0,5),0.3,2,400,16,0,Color(248,0,35),{material="vj_hl/sprites/shockwave",framerate=20,flags=0})
	effects.BeamRingPoint(self:GetPos() +Vector(0,0,5),0.3,2,200,16,0,Color(248,0,35),{material="vj_hl/sprites/shockwave",framerate=20,flags=0})

	if self.HasSounds == true && GetConVarNumber("vj_npc_sd_meleeattack") == 0 then
		VJ_EmitSound(self,"vj_hlr/hl2_npc/houndeye/he_blast"..math.random(1,3)..".wav",100,math.random(80,100))
	end

	util.VJ_SphereDamage(self,self,self:GetPos(),400,self.MeleeAttackDamage,self.MeleeAttackDamageType,true,true,{DisableVisibilityCheck=true,Force=80})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup)
	if self.PlayingAttackAnimation == true then
		return false
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/