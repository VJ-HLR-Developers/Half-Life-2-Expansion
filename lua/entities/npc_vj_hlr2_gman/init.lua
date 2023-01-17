AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/gman.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 999999
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Doesn't attack anything
ENT.Passive_RunOnTouch = false -- Should it run away && make a alert sound when something collides with it?
ENT.Passive_RunOnDamage = false -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.DisableMakingSelfEnemyToNPCs = true -- Disables the "AddEntityRelationship" that runs in think

ENT.GodMode = true -- Immune to everything
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)

ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.MoveOutOfFriendlyPlayersWay = false -- Should the SNPC move out of the way when a friendly player comes close to it?

ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events

-- ENT.SoundTbl_IdleDialogue = {"vo/gman_misc/gman_riseshine.wav"}
-- ENT.SoundTbl_FollowPlayer = {"vo/gman_misc/gman_02.wav","vo/gman_misc/gman_03.wav"}
-- ENT.SoundTbl_UnFollowPlayer = {"vo/gman_misc/gman_04.wav"}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:AddFlags(FL_NOTARGET)
	self.AnimTbl_Run = {ACT_WALK}
	
	self.NextDialogueTreeT = CurTime()
	self.NextTeleportT = CurTime() +5
end
---------------------------------------------------------------------------------------------------------------------------------------------
local dur1 = SoundDuration("vo/gman_misc/gman_riseshine.wav")
local dur2 = SoundDuration("vo/gman_misc/gman_02.wav")
local dur3 = SoundDuration("vo/gman_misc/gman_03.wav")
local dur4 = SoundDuration("vo/gman_misc/gman_04.wav")
--------
function ENT:FreemanSpeech(ent)
	if CurTime() > self.NextDialogueTreeT then
		self.Freeman = ent
		self.Dialogue1 = VJ_CreateSound(self,"vo/gman_misc/gman_riseshine.wav",75)
		self:VJ_ACT_PLAYACTIVITY({"vjges_G_tiefidget","vjges_G_lefthand_palmout","vjges_G_lefthand_punct"},false,false,false)
		timer.Simple(dur1,function()
			if IsValid(self) && IsValid(ent) then
				self.Dialogue2 = VJ_CreateSound(self,"vo/gman_misc/gman_02.wav",75)
				self:VJ_ACT_PLAYACTIVITY({"vjges_G_tiefidget","vjges_G_lefthand_palmout","vjges_G_lefthand_punct"},false,false,false)
				timer.Simple(dur2,function()
					if IsValid(self) && IsValid(ent) then
						self.Dialogue3 = VJ_CreateSound(self,"vo/gman_misc/gman_03.wav",75)
						self:VJ_ACT_PLAYACTIVITY({"vjges_G_tiefidget","vjges_G_lefthand_palmout","vjges_G_lefthand_punct"},false,false,false)
						timer.Simple(dur3,function()
							if IsValid(self) && IsValid(ent) then
								self.Dialogue4 = VJ_CreateSound(self,"vo/gman_misc/gman_04.wav",75)
								self:VJ_ACT_PLAYACTIVITY({"vjges_G_tiefidget","vjges_G_lefthand_palmout","vjges_G_lefthand_punct"},false,false,false)
								timer.Simple(dur4,function()
									if IsValid(self) && IsValid(ent) then
										self.Freeman = NULL
									end
								end)
							end
						end)
					end
				end)
			end
		end)
		self.NextDialogueTreeT = CurTime() +(dur1 +dur2 +dur3 +dur4) +math.Rand(5,15)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntityRelationshipCheck(ent,entFri,entDist)
	if ent.VJ_HLR_Freeman then
		self:FreemanSpeech(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPlayerSight(ent)
	self:FreemanSpeech(ent)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local freeman = self.Freeman
	if IsValid(freeman) then
		if freeman:GetPos():Distance(self:GetPos()) <= 300 then
			self:FaceCertainEntity(freeman)
			self:SetState(VJ_STATE_ONLY_ANIMATION)
		else
			self:SetState()
			self:SetTarget(freeman)
			self:VJ_TASK_GOTO_TARGET("TASK_WALK_PATH", function(y) y.ConstantlyFaceEnemy = true end)
		end
	else
		if self:GetState() == VJ_STATE_ONLY_ANIMATION then
			self:SetState()
		end
	end
	if CurTime() > self.NextTeleportT && IsValid(self.Freeman) then
		if game.GetGlobalState("gordon_precriminal") == 1 then return end
		local tpPos = self:FindTeleport()
		local canTP = true
		for _,v in ipairs(ents.GetAll()) do
			if (v:IsNPC() && v != self or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) && !v:IsFlagSet(FL_NOTARGET) then
				-- print(v:Visible(self),v:VisibleVec(tpPos))
				if v:Visible(self) or v:VisibleVec(tpPos) then
					canTP = false
					break
				end
			end
		end
		if !canTP then return end
		self:ClearGoal()
		self:ClearSchedule()
		self:SetPos(tpPos)
		self.NextTeleportT = CurTime() +math.Rand(15,30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindTeleport(pos)
	local dist = math.random(1024,2048)
	local ang = Angle(0,math.random(0,360),0)
	pos = pos or self:GetPos() +ang:Forward() *dist
	local spawnPos = self:FindSpawnPos(pos)
	return spawnPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindSpawnPos(pos)
    pos = pos or self:GetPos()

	local function GetOpenPos(pos)
		local startPos = pos +Vector(0,0,24)
		local tr = util.TraceEntity({
			start = startPos,
			endpos = startPos,
			filter = self,
			mask = MASK_NPCSOLID
		},self)
		return not tr.Hit && startPos
	end
    local nearestMesh = navmesh.GetNearestNavArea(pos,false,1024,false,true)
    local nearest = IsValid(nearestMesh) && nearestMesh:GetClosestPointOnArea(pos)
    local nearestPos = nearest && GetOpenPos(nearest)

    if nearestPos then
        return nearestPos
    else
        local center = IsValid(nearestMesh) && nearestMesh:GetCenter()
        local centerPos = center && GetOpenPos(center)
        if centerPos then
            return centerPos
        else
            local nearestMeshes = navmesh.Find(center or pos,1024,64,64)
            for k, v in pairs(nearestMeshes) do
                if nearestMeshes != nearestMesh then
                    local otherNearest = v:GetClosestPointOnArea(pos)
                    local otherNearestPos = GetOpenPos(otherNearest)
                    if otherNearestPos then
                        return otherNearestPos
                    else
                        local otherCenter = v:GetCenter()
                        local otherCenterPos = GetOpenPos(otherCenter)
                        if otherCenterPos then
                            return otherCenter
                        end
                    end
                end
            end
        end
    end
    return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.Dialogue1)
	VJ_STOPSOUND(self.Dialogue2)
	VJ_STOPSOUND(self.Dialogue3)
	VJ_STOPSOUND(self.Dialogue4)
end