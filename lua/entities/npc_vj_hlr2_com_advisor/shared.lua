ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= ""
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	net.Receive("VJ_HLR_AdvisorScreenFX",function()
		local ply = net.ReadEntity()
		local dist = net.ReadFloat()
		
		ply.VJ_HLR_AdvisorScreenDist = dist -- Do something with this at some point
		ply.VJ_HLR_AdvisorScreenT = CurTime() +5
		local snd = CreateSound(ply,"vj_hlr/hl2_npc/advisor/advisorheadvx0" .. math.random(1,6) .. ".wav")
		snd:SetSoundLevel(0)
		snd:Play()
		snd:ChangeVolume(65)
	end)

	hook.Add("HUDPaint","VJ_HLR_AdvisorScreen",function()
		if LocalPlayer().VJ_HLR_AdvisorScreenT && LocalPlayer().VJ_HLR_AdvisorScreenT > CurTime() then
			surface.SetTexture(surface.GetTextureID("vj_hl/hl2/overlay/advisorblast"))
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			DrawMotionBlur(0.1,1,0.01)
		end
	end)
end