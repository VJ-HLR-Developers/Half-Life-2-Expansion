ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= ""
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	local mat = Material("vj_hl/renderfx/render_advisor")
	function ENT:Initialize()
		local index = self:EntIndex()
		hook.Add("RenderScreenspaceEffects", "VJ_HLR_Advisor_FX"..index, function()
			if IsValid(self) then
				if self:GetNW2Bool("PsionicEffect") then
					for _, prop in pairs(ents.FindByClass("prop_*")) do
						if prop:GetNW2Bool("BeingControlledByAdvisor") then
							cam.Start3D(EyePos(),EyeAngles())
								render.SetBlend(1)
								render.MaterialOverride(mat)
								prop:DrawModel()
								render.MaterialOverride(0)
								render.SetBlend(1)
							cam.End3D()
						end
					end
				end
			else
				hook.Remove("RenderScreenspaceEffects","VJ_HLR_Advisor_FX" .. index)
			end
		end)
	end

	net.Receive("VJ_HLR_AdvisorScreenFX",function()
		local ply = net.ReadEntity()
		local dist = net.ReadFloat()
		
		ply.VJ_HLR_AdvisorScreenDist = dist -- Do something with this at some point
		ply.VJ_HLR_AdvisorScreenT = CurTime() +5
		local snd = CreateSound(ply,"vj_hlr/src/npc/advisor/advisorheadvx0" .. math.random(1,6) .. ".wav")
		snd:SetSoundLevel(0)
		snd:Play()
		snd:ChangeVolume(65)
	end)

	hook.Add("HUDPaint","VJ_HLR_AdvisorScreen",function()
		if LocalPlayer().VJ_HLR_AdvisorScreenT && LocalPlayer().VJ_HLR_AdvisorScreenT > CurTime() then
			surface.SetTexture(surface.GetTextureID("vj_hl/hl2/overlay/advisorblast"))
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			DrawMotionBlur(0.02,1,0.01)
			LocalPlayer():SetViewPunchAngles(Angle(math.random(-20,20),math.random(-20,20),math.random(-20,20)))
		end
	end)
end