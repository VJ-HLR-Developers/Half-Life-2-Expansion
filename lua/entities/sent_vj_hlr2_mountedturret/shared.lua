ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Mounted Turret"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

if SERVER then
	AddCSLuaFile()

	ENT.EmplacementModel = "models/props_combine/bunker_gun01.mdl"
	ENT.BarricadeModel = "models/props_combine/combine_barricade_short01a.mdl"
	ENT.EmplacementPosition = {up=8, right=0, forward=-3.4}
	ENT.IdleAnimation = "idle_inactive"
	ENT.ActiveAnimation = "idle"
	ENT.ActivateAnimation = "activate"
	ENT.DeactivateAnimation = "retract"

	function ENT:Initialize()
		self:SetModel(self.BarricadeModel)
		-- self:SetCollisionBounds(Vector(20,20,65),Vector(-20,-20,0))
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_BBOX)

		self.Emplacement = ents.Create("prop_vj_animatable")
		self.Emplacement:SetModel(self.EmplacementModel)
		self.Emplacement:SetPos(self:GetPos() +self:GetUp() *self.EmplacementPosition.up +self:GetForward() *self.EmplacementPosition.forward +self:GetRight() *self.EmplacementPosition.right)
		self.Emplacement:SetAngles(self:GetAngles())
		self.Emplacement:Spawn()
		self.Emplacement:SetParent(self)
		self.Emplacement:SetMoveType(MOVETYPE_NONE)
		-- self.Emplacement:SetSolid(SOLID_BBOX)
		self.Emplacement:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self:DeleteOnRemove(self.Emplacement)
		self.Emplacement:ResetSequence(self.IdleAnimation)

		local eyeglow = ents.Create("env_sprite")
		eyeglow:SetKeyValue("model","sprites/light_glow01.vmt")
		eyeglow:SetKeyValue("scale","1")
		eyeglow:SetKeyValue("rendermode","9")
		eyeglow:SetKeyValue("rendercolor","225 225 225 0")
		eyeglow:SetKeyValue("spawnflags","1") -- If animated
		eyeglow:SetParent(self.Emplacement)
		eyeglow:Fire("SetParentAttachment","light",0)
		eyeglow:Spawn()
		eyeglow:Activate()
		self.Emplacement:DeleteOnRemove(eyeglow)

		self.Operator = NULL
		self.PullingOperator = NULL -- Entity that the turret called to handle it
		self.Overheat = 0
		self.OverheatRechargeT = 0
		self.LastShotT = 0
		self.CanFire = false
		self.IsActivated = false
		self.IsActivating = false
		self.CanPlayIdle = false
	end
	
	function ENT:SetEmplacementStatus()
		local operator = self.Operator
		if IsValid(operator) then
			if !self.IsActivated && !self.IsActivating then
				self.Emplacement:ResetSequence(self.ActivateAnimation)
				self:EmitSound("weapons/shotgun/shotgun_cock.wav",70,100)
				self.IsActivating = true
				timer.Simple(1.3,function()
					if IsValid(self) then
						self.IsActivated = true
						self.IsActivating = false
						self.CanPlayIdle = true
						self:EmitSound("buttons/combine_button1.wav",70,100)
					end
				end)
			elseif self.IsActivated then
				self.CanFire = true
				if self.CanPlayIdle then
					self.Emplacement:ResetSequence(self.ActiveAnimation)
					self.CanPlayIdle = false
				end
			end
		else
			if self.IsActivated && !self.IsActivating then
				self.CanFire = false
				self.Emplacement:ResetSequence(self.DeactivateAnimation)
				self:EmitSound("weapons/shotgun/shotgun_cock.wav",70,92)
				self.IsActivating = true
				timer.Simple(1.3,function()
					if IsValid(self) then
						self.IsActivated = false
						self.IsActivating = false
						self.CanPlayIdle = true
						self:EmitSound("buttons/combine_button2.wav",70,100)
					end
				end)
			elseif !self.IsActivated then
				if self.CanPlayIdle then
					self.Emplacement:ResetSequence(self.IdleAnimation)
					self.CanPlayIdle = false
				end
			end
		end
	end

	function ENT:ManGun(ent)
		self.Operator = ent
		local operator = self.Operator
		operator:StopMoving()
		operator:StopMoving()
		operator.OldIdle = operator.AnimTbl_IdleStand
		operator.OldAttack = operator.AnimTbl_WeaponAttack
		operator.OldMeleeAttack = operator.HasMeleeAttack
		operator.OldGrenadeAttack = operator.HasGrenadeAttack
		if IsValid(operator:GetActiveWeapon()) then
			operator.OldWeapon = operator:GetActiveWeapon():GetClass()
			operator:GetActiveWeapon():Remove()
		end
		operator.MovementType = VJ_MOVETYPE_STATIONARY
		operator.CanTurnWhileStationary = false
		-- operator.AnimTbl_IdleStand = {ACT_IDLE_MANNEDGUN}
		-- operator.AnimTbl_WeaponAttack = {ACT_IDLE_MANNEDGUN}
		operator.AnimationTranslations[ACT_IDLE] = ACT_IDLE_MANNEDGUN
		operator.DisableWandering = true
		operator.DisableChasingEnemy = true
		operator.NoWeapon_UseScaredBehavior = false
		operator.HasMeleeAttack = false
		operator.HasGrenadeAttack = false
		-- operator:StartEngineTask(ai.GetTaskID("TASK_PLAY_SEQUENCE"), ACT_IDLE_MANNEDGUN)
		self.VJ_GoingToManGun = false
		self.VJ_ManningGun = true
		self.PullingOperator = NULL
	end

	function ENT:UnMan()
		local operator = self.Operator
		operator.VJ_NextManGunT = CurTime() +10
		operator.AnimTbl_WeaponAttack = operator.OldAttack
		operator.HasMeleeAttack = operator.OldMeleeAttack
		operator.HasGrenadeAttack = operator.OldGrenadeAttack
		if operator.OldWeapon != nil then
			operator:Give(operator.OldWeapon)
		end
		operator.MovementType = VJ_MOVETYPE_GROUND
		operator.CanTurnWhileStationary = true
		-- operator.AnimTbl_IdleStand = operator.OldIdle
		operator.AnimationTranslations[ACT_IDLE] = nil
		operator.DisableWandering = false
		operator.DisableChasingEnemy = false
		operator.NoWeapon_UseScaredBehavior = true
		operator:SetPos(operator:GetPos() +operator:GetForward() *-16 +self:GetUp() *6)
		self.Emplacement:SetPoseParameter("aim_pitch",0)
		self.Emplacement:SetPoseParameter("aim_yaw",0)
		operator.VJ_GoingToManGun = false
		operator.VJ_ManningGun = false
		self.Operator = NULL
	end

	function ENT:Think()
		if !IsValid(self.Emplacement) then self:Remove() return end
		self:SetEmplacementStatus()
		if CurTime() > self.LastShotT then
			self.Overheat = 0
		end
		if CurTime() > self.OverheatRechargeT then
			if self.Emplacement.Loop then self.Emplacement:StopParticles(); self.Emplacement.Loop:Stop() end
		end
		self.TargetPos = self:GetPos() +self:GetForward() *-50
		self.HandlePos = self:GetPos() +self:GetForward() *-40 +self:GetUp() *-31
		local operator = self.Operator
		if !IsValid(operator) then
			self:DoPoseParameterLooking(true)
			if !IsValid(self.PullingOperator) then
				for _,v in ipairs(ents.FindInSphere(self:GetPos(),500)) do
					if v:IsNPC() && v:Visible(self) && v.IsVJBaseSNPC then
						if VJ.AnimExists(v,ACT_IDLE_MANNEDGUN) && (!v.VJ_GoingToManGun && !v.VJ_ManningGun) then
							if v.VJ_NextManGunT && v.VJ_NextManGunT > CurTime() then return end
							self.PullingOperator = v
							v.VJ_GoingToManGun = true
							break
						end
					end
				end
			else
				local task = "TASK_WALK_PATH"
				if IsValid(self.PullingOperator:GetEnemy()) then
					task = "TASK_RUN_PATH"
				end
				self.PullingOperator:SetLastPosition(self.TargetPos)
				self.PullingOperator:VJ_TASK_GOTO_LASTPOS(task)
				if self.PullingOperator:GetPos():Distance(self.TargetPos) <= 50 then
					self.PullingOperator:SetPos(self.TargetPos)
					self:ManGun(self.PullingOperator)
				end
			end
		else
			operator:SetPos(self.HandlePos)
			operator:SetAngles(self:GetAngles())
			if IsValid(operator:GetEnemy()) then
				local ene = operator:GetEnemy()
				if (self.Emplacement:GetForward():Dot((ene:GetPos() - self.Emplacement:GetPos()):GetNormalized()) > math.cos(math.rad(operator.SightAngle))) && (ene:GetPos():Distance(self:GetPos()) < operator.Weapon_FiringDistanceFar) then
					if self:Visible(ene) then
						self:FireEmplacement()
					end
				else
					if ene:GetPos():Distance(operator:GetPos()) <= 500 then
						self:UnMan()
					end
				end
			end
			self:DoPoseParameterLooking()
		end
		self:NextThink(CurTime()+(0.069696968793869+FrameTime()))
		return true
	end
	
	function ENT:FireEmplacement()
		if !self.CanFire then return end
		if self.OverheatRechargeT > CurTime() then
			return
		end
		local att = self.Emplacement:GetAttachment(1)
		local bullet = {}
		bullet.Num = 1
		bullet.Src = att.Pos
		bullet.Dir = att.Ang:Forward()
		bullet.Callback = function(attacker, tr, dmginfo)
			local laserhit = EffectData()
			laserhit:SetOrigin(tr.HitPos)
			laserhit:SetNormal(tr.HitNormal)
			laserhit:SetScale(25)
			util.Effect("AR2Impact",laserhit)
		end
		bullet.Spread = Vector(0.045,0.045,0)
		bullet.Tracer = 1
		bullet.TracerName = "AirboatGunTracer"
		bullet.Force = 3
		bullet.Damage = self.Operator:VJ_GetDifficultyValue(7)
		bullet.AmmoType = "SMG1"
		self.Emplacement:FireBullets(bullet)
		self.LastShotT = CurTime() +6
		self.Overheat = self.Overheat +1
		if self.Overheat >= 125 then
			self.OverheatRechargeT = CurTime() +6
			self.Overheat = 0
			for i = 1,5 do
				timer.Simple(i,function()
					if IsValid(self) then
						sound.Play("ambient/alarms/warningbell1.wav",self.Emplacement:GetPos(),72,100 *GetConVarNumber("host_timescale"))
					end
				end)
			end
			ParticleEffectAttach("Advisor_Pod_Steam_Continuous",PATTACH_POINT_FOLLOW,self.Emplacement,1)
			self.Emplacement.Loop = CreateSound(self.Emplacement,"ambient/gas/steam2.wav")
			self.Emplacement.Loop:SetSoundLevel(72)
			self.Emplacement.Loop:Play()
		end
		ParticleEffectAttach("vj_muzzle_ar2_main",PATTACH_POINT_FOLLOW,self.Emplacement,1)
		-- ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self.Emplacement,1)
		self.Emplacement:ResetSequence("fire")
		sound.Play("^weapons/ar1/ar1_dist2.wav",self.Emplacement:GetPos(),90,100 +(self.Overheat /4) *GetConVarNumber("host_timescale"))
	end

	function ENT:OnRemove()
		if self.Emplacement.Loop then self.Emplacement.Loop:Stop() end
		self:StopParticles()
		self.Emplacement:StopParticles()
		if IsValid(self.Operator) then
			self:UnMan()
		end
	end

	function ENT:DoPoseParameterLooking(resetPoses)
		if !IsValid(self.Operator) then return end
		local operator = self.Operator
		resetPoses = resetPoses or false
		local ent = NULL
		if operator.VJ_IsBeingControlled == true then ent = operator.VJ_TheController else ent = operator:GetEnemy() end
		local p_enemy = 0 -- Pitch
		local y_enemy = 0 -- Yaw
		local r_enemy = 0 -- Roll
		local ang_dif = math.AngleDifference
		local ang_app = math.ApproachAngle
		if IsValid(ent) && resetPoses == false then
			local self_pos = self.Emplacement:GetPos() + self.Emplacement:OBBCenter()
			local enemy_pos = false //Vector(0, 0, 0)
			if operator.VJ_IsBeingControlled == true then enemy_pos = operator.VJ_TheController:GetEyeTrace().HitPos else enemy_pos = ent:GetPos() + ent:OBBCenter() end
			if enemy_pos == false then return end
			local self_ang = self.Emplacement:GetAngles()
			local enemy_ang = (enemy_pos - self_pos):Angle()
			p_enemy = ang_dif(enemy_ang.p,self_ang.p)
			if self.PoseParameterLooking_InvertPitch == true then p_enemy = -p_enemy end
			y_enemy = ang_dif(enemy_ang.y,self_ang.y)
			if self.PoseParameterLooking_InvertYaw == true then y_enemy = -y_enemy end
			r_enemy = ang_dif(enemy_ang.z,self_ang.z)
			if self.PoseParameterLooking_InvertRoll == true then r_enemy = -r_enemy end
			-- p_enemy = p_enemy +12
			local newAng = ((ent:GetPos() +ent:OBBCenter()) -self.Emplacement:GetPos()):Angle()
			p_enemy = ang_dif(newAng.p,self:GetAngles().p) +10
			y_enemy = ang_dif(newAng.y,self:GetAngles().y)
			if y_enemy < 0 then
				y_enemy = y_enemy -2
			else
				y_enemy = y_enemy +2
			end
			-- p_enemy = p_enemy -(y_enemy /3)
			-- print(y_enemy,p_enemy)
			-- y_enemy = y_enemy +2
			-- if !(self:GetForward():Dot((ent:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(30))) then
				-- y_enemy = y_enemy -5
			-- end
		end
		self.Emplacement:SetPoseParameter("aim_pitch",ang_app(self.Emplacement:GetPoseParameter("aim_pitch"),p_enemy,10))
		operator:SetPoseParameter("aim_pitch",ang_app(operator:GetPoseParameter("aim_pitch"),p_enemy,10))
		self.Emplacement:SetPoseParameter("aim_yaw",ang_app(self.Emplacement:GetPoseParameter("aim_yaw"),y_enemy,10))
		operator:SetPoseParameter("aim_yaw",ang_app(operator:GetPoseParameter("aim_yaw"),y_enemy,10))
	end
end