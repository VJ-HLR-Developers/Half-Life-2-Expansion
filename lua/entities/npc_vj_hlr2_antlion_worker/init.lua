AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2/antlion_worker.mdl"
ENT.StartHealth = 60

ENT.CustomBlood_Particle = {"antlion_spit_player_splat"}

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_antlionspit"
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 1.5
ENT.RangeDistance = 2000
ENT.RangeToMeleeDistance = 400

ENT.NoChaseAfterCertainRange = true
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance"
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance"
ENT.NoChaseAfterCertainRange_Type = "OnlyRange"

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {"explode"}
ENT.GibOnDeathDamagesTable = {"All"}
ENT.SoundTbl_Death = {
	"npc/antlion/antlion_preburst_scream1.wav",
	"npc/antlion/antlion_preburst_scream2.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 30
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	timer.Simple(0.89999995708466,function()
		if IsValid(self) then
			VJ.EmitSound(self,"npc/antlion/antlion_burst" .. math.random(1,2) .. ".wav",75,100)
			ParticleEffect("antlion_gib_02",self:GetPos(),Angle(0,0,0),nil)
			ParticleEffect("antlion_gib_02",self:GetPos(),Angle(0,0,0),nil)
			VJ.ApplyRadiusDamage(self, self, self:GetPos(), 160, 50, DMG_ACID, true, false, {Force = 50})

			local head = self:GetPos() +self:GetForward() *50 +self:GetRight() *0 +self:GetUp() *30
			local lF = self:GetPos() +self:GetForward() *40 +self:GetRight() *-15 +self:GetUp() *30
			local lB = self:GetPos() +self:GetForward() *-45 +self:GetRight() *-15 +self:GetUp() *30
			local rF = self:GetPos() +self:GetForward() *40 +self:GetRight() *15 +self:GetUp() *30
			local rB = self:GetPos() +self:GetForward() *-45 +self:GetRight() *15 +self:GetUp() *30
			self:CreateGibEntity("prop_ragdoll","models/gibs/antlion_worker_gibs_backlegl.mdl",{BloodType="Yellow",Pos=lF})
			self:CreateGibEntity("prop_ragdoll","models/gibs/antlion_worker_gibs_backlegr.mdl",{BloodType="Yellow",Pos=rF})
			self:CreateGibEntity("prop_ragdoll","models/gibs/antlion_worker_gibs_frontlegl.mdl",{BloodType="Yellow",Pos=lF})
			self:CreateGibEntity("prop_ragdoll","models/gibs/antlion_worker_gibs_frontlegr.mdl",{BloodType="Yellow",Pos=rF})
			self:CreateGibEntity("obj_vj_gib","models/gibs/antlion_worker_gibs_head.mdl",{BloodType="Yellow",Pos=head})
		end
	end)
	return true, {DeathAnim=true}
end