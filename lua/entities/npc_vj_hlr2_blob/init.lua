AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/headcrabclassic.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_BLOB"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false
ENT.GodMode = true

ENT.Blob_State = 0 -- 0 = Idle, 1 = Go to location, 2 = Chase, 3 = Cease activity
ENT.Blob_MaxMetaBalls = 30

ENT.Blob_MB_MinDist = 120
ENT.Blob_MB_MaxDist = 240
ENT.Blob_MB_IdleSpeedFactor = 0.5
ENT.Blob_MB_Speed = 187
ENT.Blob_MB_SinAmplitude = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- self:AddEffects(EF_NODRAW)
	self:SetPos(self:GetPos()+ Vector(0, 0, 20))
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	self.CentroidPos = self:GetPos()
	self.LastThink = 0
	self.MinElementDist = 0
	self.Blob_MetaBall = {}

	for i = 1,self.Blob_MaxMetaBalls do
		local ball = ents.Create("sent_vj_hlr2_metaball")
		ball:SetPos(self:GetPos() +VectorRand() *math.Rand(self.Blob_MB_MinDist *0.2,self.Blob_MB_MaxDist *0.2))
		ball:SetOwner(self)
		ball:Spawn()
		ball.SinePhase = math.abs(math.sin((#self.Blob_MetaBall or 0) /10))
		ball:SetOwner(self)
		self.Blob_MetaBall[i] = ball
		self:DeleteOnRemove(ball)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.LastThink = CurTime()

	self:ComputeCentroid()
	self:RecomputeIdealElementDist()
	self:DoBlobBatchedAI()
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ComputeCentroid()
	local tempCentroid = Vector(0,0,0)
	local tbl = self.Blob_MetaBall
	local count = table.Count(tbl)
	for i = 1,count do
		tempCentroid = tempCentroid +tbl[i]:GetPos()
	end

	self.CentroidPos = tempCentroid /count
	self.CentroidPos = self:GetPos() +Vector(0,0,40)
	VJ_CreateTestObject(self.CentroidPos,Angle(0,0,0), Color(255,0,0), 5)
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoBlobBatchedAI(iStart,iEnd)
	local flInterval = CurTime() -self.LastThink
	local tbl = self.Blob_MetaBall
	local count = table.Count(tbl)
	iStart = iStart or 1
	iEnd = iEnd or count

	local function NormalizeInPlace(vec)
		local len = vec:Length()
		if len != 0 then
			vec.x = vec.x /len
			vec.y = vec.y /len
		else
			vec.x = 0
			vec.y = 0
		end
		return len
	end

	// Local fields for sin-wave movement variance
	local flMySine
	local flAmplitude = self.Blob_MB_SinAmplitude
	local flMyAmplitude
	local vecRight = self:GetRight()
	local vecForward = self:GetForward()

	// Local fields for attract/repel
	local minDistSqr = math.sqrt(self.MinElementDist)
	local flBlobSpeed = self.Blob_MB_Speed
	local flSpeed

	// Local fields for speed limiting
	local flMinSpeed = self.Blob_MB_Speed * 0.5
	local flMaxSpeed = self.Blob_MB_Speed * 1.5
	local bEnforceSpeedLimit
	local bEnforceRelativePositions
	local bDoMovementVariation
	local bDoOrientation = 1
	local flIdleSpeedFactor = self.Blob_MB_IdleSpeedFactor

	// Group cohesion
	local flBlobRadiusSqr = math.sqrt(160 +48)

	// Build a right-hand vector along which we'll add some sine wave data to give each
	// element a unique insect-like undulation along an axis perpendicular to their path,
	// which makes the entire group look far less orderly
	if IsValid(self:GetEnemy()) then
		// If I have an enemy, the right-hand vector is perpendicular to a straight line 
		// from the group's centroid to the enemy's origin.
		vecForward = self:GetEnemy():GetPos() -self.CentroidPos
		vecForward:Normalize()
		vecRight.x = vecForward.y
		vecRight.y = -vecForward.x
	else
		// If there is no enemy, wobble along the axis from the centroid to me.
		vecForward = self:GetPos() -self.CentroidPos
		vecForward:Normalize()
		vecRight.x = vecForward.y
		vecRight.y = -vecForward.x
	end

	//--
	// MAIN LOOP - Run all of the elements in the set iStart to iEnd
	//--
	for i = iStart, iEnd do
		local metaball = tbl[i]
		//--
		// Initial movement
		//--
		// Start out with bEnforceSpeedLimit set to false. This is because an element
		// can't overspeed if it's moving undisturbed towards its target entity or 
		// target location. An element can only under or overspeed when it is repelled 
		// by multiple other elements in the group. See "Relative Positions" below.
		//
		// Initialize some 'defaults' that may be changed for each iteration of this loop
		bEnforceSpeedLimit = false
		bEnforceRelativePositions = true
		bDoMovementVariation = true
		flSpeed = flBlobSpeed

		metaball.MoveType = self.Blob_State
		
		if metaball.MoveType == 3 then
			metaball:SetVel(Vector(0,0,0))
			local vecOrigin = metaball:GetPos()
			local tr = util.TraceLine({
				start = vecOrigin,
				endpos = vecOrigin - Vector(0, 0, 16),
				mask = MASK_SHOT,
				filter = self,
				collisiongroup = COLLISION_GROUP_NONE,
			})
			if tr.Fraction < 1 then
				local angles = tr.Normal:Angle()
				local flSwap = angles.x
				angles.x = -angles.y
				angles.y = flSwap
				metaball:SetAngles(angles)
			end
		elseif metaball.MoveType == 1 then
			local vecDiff = metaball:GetPos() -metaball.LastPosition
			if vecDiff:Length2DSqr() <= math.sqrt(80) then
				// Don't shove this guy around any more, let him get to his goal position.
				flSpeed = flSpeed *0.5
				bEnforceRelativePositions = false
				bDoMovementVariation = false
			end
			metaball:MoveTowardsTargetLocation(flSpeed)
		elseif metaball.MoveType == 2 then
			if (!self:IsMoving() && !IsValid(self:GetEnemy())) then
				if metaball:GetPos():DistToSqr(self:GetPos()) <= flBlobRadiusSqr then
					flSpeed = (flSpeed *flIdleSpeedFactor) *metaball.Scale
				end
			end
			metaball:MoveTowardsTargetEntity(flSpeed)
		end

		//---
		// Relative positions
		//--
		// Check this element against ALL other elements. If the two elements are closer
		// than the allowed minimum distance, repel this element away. (The other element
		// will repel when its AI runs). A single element can be repelled by many other 
		// elements. This is why bEnforceSpeedLimit is set to true if any of the repelling
		// code runs for this element. Multiple attempts to repel an element in the same
		// direction will cause overspeed. Conflicting attempts to repel an element in opposite
		// directions will cause underspeed.
		local vecDir = Vector(0, 0, 0)
		local vecThisElementOrigin = metaball:GetPos()
		if bEnforceRelativePositions then
			for j = 0,count do
				// This is the innermost loop! We should optimize here, if anywhere.

				// If this element is on the wall, then don't be repelled by anyone. Repelling
				// elements that are trying to climb a wall usually make them look like they 
				// fall off the wall a few times while climbing.
				if metaball.OnWall then
					continue
				end
				otherBall = tbl[j]
				if IsValid(otherBall) && metaball != otherBall then -- We are not the metaball in question...
					local vecThatElementOrigin = otherBall:GetPos()
					local distSqr = vecThisElementOrigin:DistToSqr(vecThatElementOrigin)
					if distSqr < minDistSqr then
						// Too close to the other element. Move away.
						local flRepelSpeed
						local vecRepelDir = (vecThisElementOrigin -vecThatElementOrigin)

						vecRepelDir = NormalizeInPlace(vecRepelDir)
						flRepelSpeed = (flSpeed * (1 -(distSqr /minDistSqr))) *otherBall.SinePhase
						metaball:AddVel(vecRepelDir *flRepelSpeed)

						// Since we altered this element's velocity after it was initially set, there's a chance
						// that the sums of multiple vectors will cause the element to over or underspeed, so 
						// mark it for speed limit enforcement
						bEnforceSpeedLimit = true
					end
				end
			end
		end

		//--
		// Movement variation
		//--
		if bDoMovementVariation then
			flMySine = math.sin(CurTime() *metaball.SineFrequency)
			flMyAmplitude = flAmplitude *metaball.SineAmplitude
			metaball:AddVel(vecRight * (flMySine * flMyAmplitude))
		end

		//--
		// Speed limits
		//---
		if bEnforceSpeedLimit == true then
			metaball:EnforceSpeedLimits(flMinSpeed,flMaxSpeed)
		end

		//--
		// Wall crawling
		//--
		metaball:ModifyVelocityForSurface(flInterval,flSpeed)

		// For identifying stuck elements.
		metaball.PrevOrigin = metaball:GetPos() 
		metaball.DistFromCentroidSqr = metaball.PrevOrigin:DistToSqr(self.CentroidPos)

		if bDoOrientation then
			local angles = metaball:GetAbsVelocity():Angle()
			metaball:SetAngles(angles)
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RecomputeIdealElementDist()
	local M_PI = math.pi
	self.MinElementDist =  M_PI *math.sqrt((M_PI *25600) /table.Count(self.Blob_MetaBall))
end