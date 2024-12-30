AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2/mortarsynth.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 80
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Calm = 180 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 250
ENT.Aerial_AnimTbl_Calm = ACT_IDLE -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = "mortar_forward" -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = VJ.BLOOD_COLOR_BLUE -- The blood type, this will determine what it should use (decal, particle, etc.)

ENT.HasMeleeAttack = false -- Can this NPC melee attack?
//ENT.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1
//ENT.MeleeAttackDistance = 60 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
//ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
//ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
//ENT.NextAnyAttackTime_Melee = 1.3 -- How much time until it can use any attack again? | Counted in Seconds
//ENT.MeleeAttackDamage = 30

ENT.HasDeathCorpse = false -- Should a corpse spawn when it's killed?
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_mortar" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.TimeUntilRangeAttackProjectileRelease = 0.7
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.RangeDistance = 2500 -- How far can it range attack?
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 3 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextFlinchTime = 2 -- How much time until it can flinch again?
ENT.AnimTbl_Flinch = {"Mortar_Flinch_Front"}

ENT.NoChaseAfterCertainRange = true -- Should the NPC stop chasing when the enemy is within the given far and close distances?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack

ENT.SoundTbl_Breath = {"vj_hlr/hl2_npc/mortarsynth/hover.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl2_npc/combot/cbot_battletalk1.wav","vj_hlr/hl2_npc/combot/cbot_battletalk2.wav","vj_hlr/hl2_npc/combot/cbot_battletalk3.wav","vj_hlr/hl2_npc/combot/cbot_battletalk4.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl2_npc/combot/cbot_scan1.wav","vj_hlr/hl2_npc/combot/cbot_scan2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl2_npc/combot/cbot_alert1.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl2_npc/mortarsynth/attack_shoot.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl2_npc/combot/cbot_servoscared.wav","vj_hlr/hl2_npc/combot/cbot_servosurprise.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl2_npc/waste_scanner/grenade_fire.wav"}

ENT.BreathSoundLevel = 75
ENT.AlertSoundLevel = 90
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(33, 33, 26), Vector(-33, -33, -30))

	local glowFX = ents.Create("light_dynamic")
	glowFX:SetKeyValue("brightness","2")
	glowFX:SetKeyValue("distance","125")
	glowFX:SetLocalPos(self:GetPos() +self:OBBCenter() +self:GetForward() *20 +self:GetUp() *-4)
	glowFX:SetLocalAngles(self:GetAngles())
	glowFX:Fire("Color","0 50 255")
	glowFX:SetParent(self)
	glowFX:Spawn()
	glowFX:Activate()
	glowFX:Fire("TurnOn","",0)
	-- glowFX:Fire("SetParentAttachment","2",0)
	self:DeleteOnRemove(glowFX)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * 10 + self:GetForward() * -20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	return self:CalculateProjectile("Curve", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "PriorExecution" then
		local dmgtype = dmginfo:GetDamageType()
		if (dmgtype == DMG_BULLET or dmgtype == DMG_SLASH) then
			self.AnimTbl_Flinch = {"Mortar_Flinch_Back","Mortar_Flinch_Left","Mortar_Flinch_Right","Mortar_Flinch_Front"}
		else
			self.AnimTbl_Flinch = {"Mortar_BigFlinch_Back","Mortar_BigFlinch_Left","Mortar_BigFlinch_Right","Mortar_BigFlinch_Front"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		ParticleEffect("explosion_turret_break",self:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("electrical_arc_01_system",self:GetPos(),Angle(0,0,0),nil)
		util.BlastDamage(self,self,self:GetPos(),80,20)
	end
end