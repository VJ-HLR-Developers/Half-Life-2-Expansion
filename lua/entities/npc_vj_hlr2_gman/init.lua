AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/gman.mdl"}
ENT.StartHealth = 999999
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.Behavior = VJ_BEHAVIOR_PASSIVE
ENT.Passive_RunOnTouch = false
ENT.DamageResponse = false
ENT.EnemyDetection = false

ENT.GodMode = true
ENT.BloodColor = VJ.BLOOD_COLOR_RED

ENT.HasMeleeAttack = false

ENT.YieldToAlliedPlayers = false

ENT.HasOnPlayerSight = true
ENT.DisableFootStepSoundTimer = true

-- ENT.SoundTbl_IdleDialogue = {"vo/gman_misc/gman_riseshine.wav"}
-- ENT.SoundTbl_FollowPlayer = {"vo/gman_misc/gman_02.wav", "vo/gman_misc/gman_03.wav"}
-- ENT.SoundTbl_UnFollowPlayer = {"vo/gman_misc/gman_04.wav"}

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
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
		self.Dialogue1 = VJ.CreateSound(self, "vo/gman_misc/gman_riseshine.wav", 75)
		self:PlayAnim({"vjges_G_tiefidget", "vjges_G_lefthand_palmout", "vjges_G_lefthand_punct"}, false, false, false)
		timer.Simple(dur1, function()
			if IsValid(self) && IsValid(ent) then
				self.Dialogue2 = VJ.CreateSound(self, "vo/gman_misc/gman_02.wav", 75)
				self:PlayAnim({"vjges_G_tiefidget", "vjges_G_lefthand_palmout", "vjges_G_lefthand_punct"}, false, false, false)
				timer.Simple(dur2, function()
					if IsValid(self) && IsValid(ent) then
						self.Dialogue3 = VJ.CreateSound(self, "vo/gman_misc/gman_03.wav", 75)
						self:PlayAnim({"vjges_G_tiefidget", "vjges_G_lefthand_palmout", "vjges_G_lefthand_punct"}, false, false, false)
						timer.Simple(dur3, function()
							if IsValid(self) && IsValid(ent) then
								self.Dialogue4 = VJ.CreateSound(self, "vo/gman_misc/gman_04.wav", 75)
								self:PlayAnim({"vjges_G_tiefidget", "vjges_G_lefthand_palmout", "vjges_G_lefthand_punct"}, false, false, false)
								timer.Simple(dur4, function()
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
		self.NextDialogueTreeT = CurTime() +(dur1 +dur2 +dur3 +dur4) +math.Rand(5, 15)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMaintainRelationships(ent, calculatedDisp, entDist)
	if ent.VJ_HLR_Freeman then
		self:FreemanSpeech(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSight(ent)
	self:FreemanSpeech(ent)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local freeman = self.Freeman
	if IsValid(freeman) then
		if freeman:GetPos():Distance(self:GetPos()) <= 300 then
			self:SetTurnTarget(freeman)
			self:SetState(VJ_STATE_ONLY_ANIMATION)
		else
			self:SetState()
			self:SetTarget(freeman)
			self:SCHEDULE_GOTO_TARGET("TASK_WALK_PATH", function(y) y.TurnData = {Type = VJ.FACE_ENEMY} end)
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
		for _, v in ipairs(ents.GetAll()) do
			if (v:IsNPC() && v != self or (v:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS)) && !v:IsFlagSet(FL_NOTARGET) then
				-- print(v:Visible(self), v:VisibleVec(tpPos))
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
		self.NextTeleportT = CurTime() +math.Rand(15, 30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindTeleport(pos)
	local dist = math.random(1024, 2048)
	local ang = Angle(0, math.random(0, 360), 0)
	pos = pos or self:GetPos() +ang:Forward() *dist
	local spawnPos = self:FindSpawnPos(pos)
	return spawnPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindSpawnPos(pos)
    pos = pos or self:GetPos()

	local function GetOpenPos(pos)
		local startPos = pos +Vector(0, 0, 24)
		local tr = util.TraceEntity({
			start = startPos,
			endpos = startPos,
			filter = self,
			mask = MASK_NPCSOLID
		}, self)
		return not tr.Hit && startPos
	end
    local nearestMesh = navmesh.GetNearestNavArea(pos, false, 1024, false, true)
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
            local nearestMeshes = navmesh.Find(center or pos, 1024, 64, 64)
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
	VJ.STOPSOUND(self.Dialogue1)
	VJ.STOPSOUND(self.Dialogue2)
	VJ.STOPSOUND(self.Dialogue3)
	VJ.STOPSOUND(self.Dialogue4)
end