/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("Half-Life Resurgence: Half Life 2", "NPC")
	
/*
	Credits:

	- Sabrean = Custom Zombie Models
*/

VJ.AddCeilingNPC = function(nName, nClass, spawnCategory)
	local NPC = {Name = nName, Class = nClass, Category = spawnCategory, OnCeiling = true}
	list.Set( "NPC", NPC.Class, NPC ) //NPC //VJBASE_SPAWNABLE_NPC
	list.Set( "VJBASE_SPAWNABLE_NPC", NPC.Class, NPC )
end

-- Source Engine -------------------------------------------------------
local spawnCategory = "HL Resurgence: Source"
	
	-- Misc.
	VJ.AddNPC("Mounted Turret", "sent_vj_hlr2_mountedturret", spawnCategory)
	-- VJ.AddNPC("Suppression Device", "sent_vj_hlr2_mortarturret", spawnCategory)

	-- Antlions
	-- VJ.AddNPC("Antlion (Beta)", "npc_vj_hlr2b_antlion", spawnCategory)

	-- VJ.AddNPC("Antlion Worker (EP2 Beta)", "npc_vj_hlr2b_antlion_worker", spawnCategory)

	VJ.AddNPC("Antlion", "npc_vj_hlr2_antlion", spawnCategory)
	VJ.AddNPC("Antlion Worker", "npc_vj_hlr2_antlion_worker", spawnCategory)
	VJ.AddNPC("Antlion Guard", "npc_vj_hlr2_antlion_guard", spawnCategory)
	VJ.AddNPC("Antlion Guardian", "npc_vj_hlr2_antlion_guardian", spawnCategory)

	-- Combine
	-- VJ.AddNPC_HUMAN("Overwatch Soldier (Beta)", "npc_vj_hlr2b_com_soldier", {"weapon_vj_hlr2b_oicw"}, spawnCategory)
	-- VJ.AddNPC_HUMAN("Overwatch Elite (Beta)", "npc_vj_hlr2b_com_elite", {"weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_ar2", "weapon_vj_ar2"}, spawnCategory)
	-- VJ.AddNPC_HUMAN("Civil Protection (Beta)", "npc_vj_hlr2b_com_civilp", {"weapon_vj_9mmpistol", "weapon_vj_smg1"}, spawnCategory)
	VJ.AddNPC("Overwatch Guard", "npc_vj_hlr2b_com_guard", spawnCategory)
	VJ.AddNPC("Overwatch Stalker (Beta)", "npc_vj_hlr2b_com_stalker", spawnCategory)
	VJ.AddNPC("Overwatch Prowler", "npc_vj_hlr2b_com_alienassassin", spawnCategory)
	-- VJ.AddNPC("Overwatch Combot", "npc_vj_hlr2b_com_combot", spawnCategory)
	VJ.AddNPC("Overwatch Cremator", "npc_vj_hlr2b_com_cremator", spawnCategory)
	-- VJ.AddNPC("Overwatch Shield Scanner (Beta)", "npc_vj_hlr2b_com_scanner_shield", spawnCategory)
	-- VJ.AddNPC("Overwatch Wasteland Scanner", "npc_vj_hlr2b_com_scanner_waste", spawnCategory)
	VJ.AddNPC("Overwatch Assassin", "npc_vj_hlr2b_com_assassin", spawnCategory)
	VJ.AddNPC("Overwatch Stalker", "npc_vj_hlr2_com_stalker", spawnCategory)
	-- VJ.AddNPC("Overwatch Manhack", "npc_vj_hlr2_com_manhack", spawnCategory)
	VJ.AddNPC("Overwatch City Scanner", "npc_vj_hlr2_com_scanner_city", spawnCategory)
	VJ.AddNPC("Overwatch Shield Scanner", "npc_vj_hlr2_com_scanner_shield", spawnCategory)
	VJ.AddNPC("Overwatch Hunter Synth", "npc_vj_hlr2_com_hunter", spawnCategory)
	VJ.AddNPC("Overwatch APC", "npc_vj_hlr2_com_apc", spawnCategory)
	VJ.AddNPC("Overwatch Strider Synth", "npc_vj_hlr2_com_strider", spawnCategory)
	VJ.AddNPC("Overwatch Advisor", "npc_vj_hlr2_com_advisor", spawnCategory)
	VJ.AddNPC("Overwatch Mortar Synth", "npc_vj_hlr2_com_mortar", spawnCategory)
	VJ.AddNPC("Overwatch Crab Synth", "npc_vj_hlr2_com_crab", spawnCategory)
	VJ.AddCeilingNPC("Overwatch Ceiling Turret", "npc_vj_hlr2_com_ceilingturret", spawnCategory)
	VJ.AddNPC("Overwatch Ion Cannon Turret", "npc_vj_hlr2_com_ionturret", spawnCategory)
	VJ.AddNPC("Overwatch Hunter Chopper", "npc_vj_hlr2_com_chopper", spawnCategory)
	VJ.AddNPC("Overwatch Heavy Chopper", "npc_vj_hlr2_com_chopper_heavy", spawnCategory)
	VJ.AddNPC("Overwatch Gunship Synth", "npc_vj_hlr2_com_gunship", spawnCategory)
	VJ.AddNPC("Overwatch Dropship Synth", "npc_vj_hlr2_com_dropship", spawnCategory)
	VJ.AddNPC("Vortigaunt Slave", "npc_vj_hlr2_vortigaunt_slave", spawnCategory)
	
	-- Unknown
	VJ.AddNPC("G-Man", "npc_vj_hlr2_gman", spawnCategory)

	-- Resistance
	VJ.AddNPC("Vortigaunt", "npc_vj_hlr2_vortigaunt", spawnCategory)
	VJ.AddNPC_HUMAN("Gordon Freeman", "npc_vj_hlr2_freeman", {"weapon_vj_smg1", "weapon_vj_ar2", "weapon_vj_spas12"}, spawnCategory)
	VJ.AddNPC("Lamarr", "npc_vj_hlr2_lamarr", spawnCategory)

	-- Xen Creatures
		-- Headcrab
		VJ.AddNPC("Zombie", "npc_vj_hlr2_zombie", spawnCategory)
		VJ.AddNPC("Prowler Zombie", "npc_vj_hlr2b_zombie_assassin", spawnCategory)
		VJ.AddNPC("Fast Zombie", "npc_vj_hlr2_zombie_fast", spawnCategory)
		VJ.AddNPC("Poison Zombie", "npc_vj_hlr2_zombie_poison", spawnCategory)
		VJ.AddNPC("Zombine", "npc_vj_hlr2_zombine", spawnCategory)
		VJ.AddNPC("Headcrab", "npc_vj_hlr2_headcrab", spawnCategory)
		VJ.AddNPC("Fast Headcrab", "npc_vj_hlr2_headcrab_fast", spawnCategory)
		VJ.AddNPC("Poison Headcrab", "npc_vj_hlr2_headcrab_poison", spawnCategory)

		VJ.AddNPC("Zombie (Slump)", "npc_vj_hlr2_zombie_slump", spawnCategory)
		VJ.AddNPC("Fast Zombie (Slump)", "npc_vj_hlr2_zombie_fast_slump", spawnCategory)
		VJ.AddNPC("Poison Zombie (Slump)", "npc_vj_hlr2_zombie_poison_slump", spawnCategory)
		VJ.AddNPC("Zombine (Slump)", "npc_vj_hlr2_zombine_slump", spawnCategory)

		VJ.AddNPC("Zombie (Beta)", "npc_vj_hlr2b_zombie", spawnCategory)
		-- VJ.AddNPC("Zombie (2002)", "npc_vj_hlr2b_zombie_fat", spawnCategory)
		VJ.AddNPC("Fast Zombie (Beta)", "npc_vj_hlr2b_zombie_fast", spawnCategory)
		VJ.AddNPC("Poison Zombie (Beta)", "npc_vj_hlr2b_zombie_poison", spawnCategory)
		VJ.AddNPC("Headcrab (Beta)", "npc_vj_hlr2b_headcrab", spawnCategory)
		VJ.AddNPC("Fast Headcrab (Beta)", "npc_vj_hlr2b_headcrab_fast", spawnCategory)
		VJ.AddNPC("Poison Headcrab (Beta)", "npc_vj_hlr2b_headcrab_poison", spawnCategory)
	
		-- Wild Life
		-- VJ.AddNPC("Blob", "npc_vj_hlr2_blob", spawnCategory) -- Probably won't keep
		VJ.AddNPC("Leech", "npc_vj_hlr2_leech", spawnCategory)
		VJ.AddNPC("Hydra", "npc_vj_hlr2b_hydra", spawnCategory)
		VJ.AddNPC("Bullsquid", "npc_vj_hlr2b_bullsquid", spawnCategory)
		VJ.AddNPC("Houndeye", "npc_vj_hlr2b_houndeye", spawnCategory)
		VJ.AddNPC("Ichthyosaur", "npc_vj_hlr2_ichthyosaur", spawnCategory)
		-- VJ.AddCeilingNPC("Barnacle", "npc_vj_hlr2_barnacle", spawnCategory)
		-- VJ.AddNPC("Sand Barnacle", "npc_vj_hlr2b_barnacle_sand", spawnCategory)

-- Weapons --
VJ.AddNPCWeapon("VJ_HL2B_HMG1", "weapon_vj_hlr2b_hmg1", spawnCategory)
-- VJ.AddNPCWeapon("VJ_HL2B_SMG1", "weapon_vj_hlr2b_mp5k", spawnCategory)
-- VJ.AddNPCWeapon("VJ_HL2B_SMG2", "weapon_vj_hlr2b_mp7", spawnCategory)
-- VJ.AddNPCWeapon("VJ_HL2B_AR1", "weapon_vj_hlr2b_ar1", spawnCategory)
-- VJ.AddNPCWeapon("VJ_HL2B_MissileLauncher", "weapon_vj_hlr2b_missilelauncher", spawnCategory)

-- ConVars --
VJ.AddParticle("particles/advisor.pcf", {})
VJ.AddParticle("particles/advisor_fx.pcf", {})
VJ.AddParticle("particles/vj_hlr_flechette_projectile.pcf", {"hunter_flechette_trail", "hunter_projectile_explosion_1"})
VJ.AddParticle("particles/vj_hlr_hunter_shield.pcf", {"vj_hlr_huntershield_impact1"})
VJ.AddParticle("particles/vj_hlr_cremator.pcf", {"vj_hlr_cremator_range", "vj_hlr_cremator_projectile", "vj_hlr_cremator_projectile_impact"})
VJ.AddParticle("particles/vj_hlr_alienassassin.pcf", {"vj_hlr_assassin_bodysmoke", "vj_hlr_assassin_smokegrenade", "vj_hlr_assassin_smokegrenade_b"})

if CLIENT then
	local math_abs = math.abs
	local blueFX = Vector(0, 0.4, 6)
	local whiteFX = Vector(1, 1, 1)
	matproxy.Add({
		name = "HLR.Camo", -- Used for Combine Assassin's new cloak materials. It's made with her in mind, so if we use it for other stuff it might not function properly in it's current state
		init = function(self, mat, values)
			self.Result = values.resultvar
			self.CloakColorTint = mat:GetVector("$cloakcolortint") or whiteFX
		end,
		bind = function(self, mat, ent)
			if (!IsValid(ent)) then return end
			
			local parent = ent:GetParent()
			local checkEnt = IsValid(parent) && parent or ent
			ent.Mat_cloakfactor = ent.Mat_cloakfactor or (IsValid(parent) && parent.Mat_cloakfactor or 0)
			local curValue = ent.Mat_cloakfactor
			local finalResult = curValue or 0
			if checkEnt.HLR_UsesCloakSystem then
				if checkEnt:GetCloaked() then
					finalResult = checkEnt:IsNPC() && (checkEnt:GetVelocity():Length() > 60 && 0.97 or checkEnt:GetFireTime() > CurTime() && 0.92) or 0.997
				else
					finalResult = 0
				end
			end
			ent.Mat_cloakfactor = Lerp(FrameTime() *0.3, curValue, finalResult)
			self.CloakColorTint = LerpVector(FrameTime() *0.3, self.CloakColorTint, math_abs(curValue -finalResult) > 0.1 && blueFX or whiteFX)
			mat:SetVector("$cloakcolortint", self.CloakColorTint)
			mat:SetFloat(self.Result, ent.Mat_cloakfactor)
		end
	})
end