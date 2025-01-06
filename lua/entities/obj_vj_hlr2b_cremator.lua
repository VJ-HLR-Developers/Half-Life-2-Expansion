/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= ""
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

if CLIENT then
	local Name = "Overwatch Cremator"
	local LangName = "obj_vj_hlr2b_cremator"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/spitball_medium.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 200
ENT.RadiusDamage = 45
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = bit.bor(DMG_BURN,DMG_DISSOLVE, DMG_ENERGYBEAM)
ENT.SoundTbl_Idle = "vj_hlr/hl1_npc/kingpin/kingpin_move.wav"
ENT.SoundTbl_OnCollide = "vj_hlr/hl2_npc/cremator/plasma_stop.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	self:DrawShadow(false)

	ParticleEffectAttach("vj_hlr_cremator_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
	VJ.EmitSound(self,"vj_hlr/hl2_npc/cremator/plasma_ignite.wav",75)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	sound.EmitHint(SOUND_DANGER, self:GetPos() +self:GetVelocity(), self.RadiusDamageRadius, 1, self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	ParticleEffect("vj_hlr_cremator_projectile_impact",data.HitPos,Angle(0,0,0))
end