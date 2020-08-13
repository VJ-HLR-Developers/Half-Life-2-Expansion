AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/gordon_freeman.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true -- Can the SNPC regenerate its health?
ENT.HealthRegenerationAmount = 2 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ_Set(0.1,0.1) -- How much time until the health increases
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- The model for the grenade entity
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK_THROW} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 0.87 -- Time until the grenade is released
ENT.GrenadeAttackAttachment = "anim_attachment_RH" -- The attachment that the grenade will spawn at

ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?

ENT.WeaponInventory_AntiArmor = true -- If true, the NPC will spawn with one of the given weapons (Will only be given the weapon if it already has another!)
ENT.WeaponInventory_AntiArmorList = {"weapon_vj_hlr2_rpg"} -- It will randomly be given one of these weapons
ENT.WeaponInventory_Melee = true -- If true, the NPC will spawn with one of the given weapons (Will only be given the weapon if it already has another!)
ENT.WeaponInventory_MeleeList = {"weapon_vj_crowbar"} -- It will randomly be given one of these weapons

ENT.SoundTbl_FootStep = {"NPC_Citizen.FootstepLeft","NPC_Citizen.FootstepRight"}
ENT.SoundTbl_Breath = {"player/breathe1.wav"}
ENT.SoundTbl_Pain = {"player/pl_pain5.wav","player/pl_pain6.wav","player/pl_pain7.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.BreathSoundLevel = 40
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	local tbl = {
		"weapon_vj_ar2",
		"weapon_vj_crossbow",
		"weapon_vj_9mmpistol",
		"weapon_vj_spas12",
		"weapon_vj_357",
		"weapon_vj_smg1",
	}
	self.WeaponInventory.Total = {}
	if self.DisableWeapons == false then
		timer.Simple(0.1,function()
			if IsValid(self) then
				local wep = self:GetActiveWeapon()
				if IsValid(wep) then
					for ind,v in ipairs(tbl) do
						local wep = self:Give(v)
						table.insert(self.WeaponInventory.Total,wep)
					end
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWaitForEnemyToComeOut()
	if math.random(1,5) == 1 then
		self:DoChangeWeapon(VJ_PICK(self.WeaponInventory.Total),true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponReload()
	-- if math.random(1,2) == 1 then
		-- self:DoChangeWeapon(VJ_PICK(self.WeaponInventory.Total),true)
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 then
		if argent:IsNPC() && argent.HLR_Type == "Headcrab" or argent:GetClass() == "npc_headcrab" or argent:GetClass() == "npc_headcrab_black" or argent:GetClass() == "npc_headcrab_fast" then
			self:DoChangeWeapon("weapon_vj_crowbar",true)
			return
		else
			self:DoChangeWeapon(VJ_PICK(self.WeaponInventory.Total),true)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(GrenadeEntity)
	-- Custom grenade model and sounds
	GrenadeEntity.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
	GrenadeEntity.IdleSoundPitch1 = 100
	local redglow = ents.Create("env_sprite")
	redglow:SetKeyValue("model", "vj_base/sprites/vj_glow1.vmt")
	redglow:SetKeyValue("scale", "0.07")
	redglow:SetKeyValue("rendermode", "5")
	redglow:SetKeyValue("rendercolor", "150 0 0")
	redglow:SetKeyValue("spawnflags", "1") -- If animated
	redglow:SetParent(GrenadeEntity)
	redglow:Fire("SetParentAttachment", "fuse", 0)
	redglow:Spawn()
	redglow:Activate()
	GrenadeEntity:DeleteOnRemove(redglow)
	util.SpriteTrail(GrenadeEntity, 1, Color(200,0,0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	-- Absorb bullet damage
	if dmginfo:IsBulletDamage() then
		if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self, "vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav", 70) end
		if math.random(1,3) == 1 then
			dmginfo:ScaleDamage(0.50)
			local spark = ents.Create("env_spark")
			spark:SetKeyValue("Magnitude","1")
			spark:SetKeyValue("Spark Trail Length","1")
			spark:SetPos(dmginfo:GetDamagePosition())
			spark:SetAngles(self:GetAngles())
			spark:SetParent(self)
			spark:Spawn()
			spark:Activate()
			spark:Fire("StartSpark", "", 0)
			spark:Fire("StopSpark", "", 0.001)
			self:DeleteOnRemove(spark)
		else
			dmginfo:ScaleDamage(0.60)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	for _,v in pairs(self.WeaponInventory.Total) do
		if IsValid(v) && v != self:GetActiveWeapon() then
			local e = ents.Create(v:GetClass())
			e:SetPos(self:GetPos() +self:OBBCenter())
			e:SetAngles(self:GetAngles())
			e:Spawn()
			local phys = e:GetPhysicsObject()
			if ((IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball") or (!IsValid(dmginfo:GetInflictor()))) && IsValid(phys) then
				phys:SetMass(60)
				phys:ApplyForceCenter(dmginfo:GetDamageForce())
			end
		end
	end
	local e = ents.Create(self.WeaponInventory.AntiArmor:GetClass())
	e:SetPos(self:GetPos() +self:OBBCenter())
	e:SetAngles(self:GetAngles())
	e:Spawn()
	local phys = e:GetPhysicsObject()
	if ((IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball") or (!IsValid(dmginfo:GetInflictor()))) && IsValid(phys) then
		phys:SetMass(60)
		phys:ApplyForceCenter(dmginfo:GetDamageForce())
	end
	local e = ents.Create(self.WeaponInventory.Melee:GetClass())
	e:SetPos(self:GetPos() +self:OBBCenter())
	e:SetAngles(self:GetAngles())
	e:Spawn()
	local phys = e:GetPhysicsObject()
	if ((IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball") or (!IsValid(dmginfo:GetInflictor()))) && IsValid(phys) then
		phys:SetMass(60)
		phys:ApplyForceCenter(dmginfo:GetDamageForce())
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/