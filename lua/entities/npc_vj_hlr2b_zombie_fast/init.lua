AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/zombie_fast.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.BloodColor = "Yellow"
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}

ENT.SoundTbl_Idle = {"vj_hlr/hl2_npc/beta_zombiefast/breath1.wav","vj_hlr/hl2_npc/beta_zombiefast/breath2.wav"}
ENT.SoundTbl_Breath = {"vj_hlr/hl2_npc/beta_zombiefast/throat_loop1.wav","vj_hlr/hl2_npc/beta_zombiefast/tremble_loop1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	if self:GetBodygroup(1) == 0 then return false end
	local randcrab = math.random(1,2)
	local dmgtype = dmginfo:GetDamageType()
	if dmgtype == DMG_CLUB or dmgtype == DMG_SLASH then randcrab = 2 end
	if randcrab == 1 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/headcrab.mdl",{Pos=self:GetPos() +Vector(0,0,self:OBBMaxs())},function(crab) crab:SetMaterial("models/hl_resurgence/hl2b/headcrab_fast/allinonebacup2") end)
		self.Corpse:SetBodygroup(1,0)
	end
	if randcrab == 2 then
		self.Corpse:SetBodygroup(1,0)
		local spawncrab = ents.Create("npc_vj_hlr2b_headcrab_fast")
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
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/