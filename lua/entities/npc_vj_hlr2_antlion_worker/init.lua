AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/antlion_worker.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ANTLION"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"antlion_spit_player_splat"}
ENT.MeleeAttackDistance = 15 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1 -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr2_antlionspit" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 1.5 -- How much time until it can use a range attack?
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 400 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
ENT.RangeAttackPos_Up = 20
ENT.RangeAttackPos_Forward = 30

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange"

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"explode"}
ENT.GibOnDeathDamagesTable = {"All"}
ENT.SoundTbl_Death = {
	"npc/antlion/antlion_preburst_scream1.wav",
	"npc/antlion/antlion_preburst_scream2.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	timer.Simple(0.89999995708466,function()
		if IsValid(self) then
			VJ.EmitSound(self,"npc/antlion/antlion_burst" .. math.random(1,2) .. ".wav",75,100)
			ParticleEffect("antlion_gib_02",self:GetPos(),Angle(0,0,0),nil)
			ParticleEffect("antlion_gib_02",self:GetPos(),Angle(0,0,0),nil)
			local find = ents.FindInSphere(self:GetPos(),200)
			for index,ent in pairs(find) do
				if (ent:IsNPC() && ent != self && !VJ.HasValue(ent.VJ_NPC_Class,"CLASS_ANTLION")) || (ent:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS) then
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(55)
					dmginfo:SetDamageType(DMG_ACID)
					dmginfo:SetDamagePosition(ent:GetPos() +ent:OBBCenter())
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					ent:TakeDamageInfo(dmginfo)
				end
			end

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