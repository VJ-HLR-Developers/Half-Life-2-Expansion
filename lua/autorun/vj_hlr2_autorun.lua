/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Half-Life Resurgence: Half Life 2"
local AddonName = "Half-Life Resurgence: Half Life 2"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_hlr2_autorun.lua"
-------------------------------------------------------

local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	/*
		Credits:

		- Sabrean = Custom Zombie Models
	*/

	VJ.AddCeilingNPC = function(nName,nClass,vCat)
		local NPC = {Name = nName, Class = nClass, Category = vCat, OnCeiling = true}
		list.Set( "NPC", NPC.Class, NPC ) //NPC //VJBASE_SPAWNABLE_NPC
		list.Set( "VJBASE_SPAWNABLE_NPC", NPC.Class, NPC )
	end
	
	-- Source Engine -------------------------------------------------------
	local vCat = "HL Resurgence: Source"
		
		-- Misc.
		VJ.AddNPC("Mounted Turret","sent_vj_hlr2_mountedturret",vCat)
		-- VJ.AddNPC("Suppression Device","sent_vj_hlr2_mortarturret",vCat)

		-- Antlions
		-- VJ.AddNPC("Antlion (Beta)","npc_vj_hlr2b_antlion",vCat)

		VJ.AddNPC("Antlion Worker (EP2 Beta)","npc_vj_hlr2b_antlion_worker",vCat)

		VJ.AddNPC("Antlion","npc_vj_hlr2_antlion",vCat)
		VJ.AddNPC("Antlion Worker","npc_vj_hlr2_antlion_worker",vCat)
		VJ.AddNPC("Antlion Guard","npc_vj_hlr2_antlion_guard",vCat)
		VJ.AddNPC("Antlion Guardian","npc_vj_hlr2_antlion_guardian",vCat)

		-- Combine
		VJ.AddNPC_HUMAN("Overwatch Soldier (Beta)","npc_vj_hlr2b_com_soldier",{"weapon_vj_hlr2b_oicw"},vCat)
		-- VJ.AddNPC_HUMAN("Overwatch Elite (Beta)","npc_vj_hlr2b_com_elite",{"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2","weapon_vj_ar2"},vCat)
		-- VJ.AddNPC_HUMAN("Civil Protection (Beta)","npc_vj_hlr2b_com_civilp",{"weapon_vj_9mmpistol","weapon_vj_smg1"},vCat)
		VJ.AddNPC("Overwatch Guard","npc_vj_hlr2b_com_guard",vCat)
		VJ.AddNPC("Overwatch Stalker (Beta)","npc_vj_hlr2b_com_stalker",vCat)
		-- VJ.AddNPC("Overwatch Alien Assassin","npc_vj_hlr2b_com_alienassassin",vCat)
		-- VJ.AddNPC("Overwatch Combot","npc_vj_hlr2b_com_combot",vCat)
		-- VJ.AddNPC("Overwatch Shield Scanner (Beta)","npc_vj_hlr2b_com_scanner_shield",vCat)
		-- VJ.AddNPC("Overwatch Wasteland Scanner","npc_vj_hlr2b_com_scanner_waste",vCat)
		VJ.AddNPC("Overwatch Assassin","npc_vj_hlr2b_com_assassin",vCat)
		VJ.AddNPC("Overwatch Stalker","npc_vj_hlr2_com_stalker",vCat)
		-- VJ.AddNPC("Overwatch Manhack","npc_vj_hlr2_com_manhack",vCat)
		VJ.AddNPC("Overwatch City Scanner","npc_vj_hlr2_com_scanner_city",vCat)
		VJ.AddNPC("Overwatch Shield Scanner","npc_vj_hlr2_com_scanner_shield",vCat)
		VJ.AddNPC("Overwatch Hunter Synth","npc_vj_hlr2_com_hunter",vCat)
		VJ.AddNPC("Overwatch APC","npc_vj_hlr2_com_apc",vCat)
		VJ.AddNPC("Overwatch Strider Synth","npc_vj_hlr2_com_strider",vCat)
		VJ.AddNPC("Overwatch Advisor","npc_vj_hlr2_com_advisor",vCat)
		VJ.AddNPC("Overwatch Mortar Synth","npc_vj_hlr2_com_mortar",vCat)
		VJ.AddNPC("Overwatch Crab Synth","npc_vj_hlr2_com_crab",vCat)
		VJ.AddCeilingNPC("Overwatch Ceiling Turret","npc_vj_hlr2_com_ceilingturret",vCat)
		VJ.AddNPC("Overwatch Ion Cannon Turret","npc_vj_hlr2_com_ionturret",vCat)
		VJ.AddNPC("Overwatch Hunter Chopper","npc_vj_hlr2_com_chopper",vCat)
		VJ.AddNPC("Overwatch Heavy Chopper","npc_vj_hlr2_com_chopper_heavy",vCat)
		VJ.AddNPC("Overwatch Gunship Synth","npc_vj_hlr2_com_gunship",vCat)
		-- VJ.AddNPC("Overwatch Dropship Synth","npc_vj_hlr2_com_dropship",vCat)
		
		-- Unknown
		VJ.AddNPC("G-Man","npc_vj_hlr2_gman",vCat)

		-- Resistance
		-- VJ.AddNPC("Vortigaunt","npc_vj_hlr2_vort",vCat)
		VJ.AddNPC_HUMAN("Gordon Freeman","npc_vj_hlr2_freeman",{"weapon_vj_smg1","weapon_vj_ar2","weapon_vj_spas12"},vCat)
		VJ.AddNPC("Lamarr","npc_vj_hlr2_lamarr",vCat)

		-- Xen Creatures
			-- Headcrab
			VJ.AddNPC("Zombie","npc_vj_hlr2_zombie",vCat)
			VJ.AddNPC("Zombie Assassin","npc_vj_hlr2b_zombie_assassin",vCat)
			VJ.AddNPC("Fast Zombie","npc_vj_hlr2_zombie_fast",vCat)
			VJ.AddNPC("Poison Zombie","npc_vj_hlr2_zombie_poison",vCat)
			VJ.AddNPC("Zombine","npc_vj_hlr2_zombine",vCat)
			VJ.AddNPC("Headcrab","npc_vj_hlr2_headcrab",vCat)
			VJ.AddNPC("Fast Headcrab","npc_vj_hlr2_headcrab_fast",vCat)
			VJ.AddNPC("Poison Headcrab","npc_vj_hlr2_headcrab_poison",vCat)

			VJ.AddNPC("Zombie (Slump)","npc_vj_hlr2_zombie_slump",vCat)
			VJ.AddNPC("Fast Zombie (Slump)","npc_vj_hlr2_zombie_fast_slump",vCat)
			VJ.AddNPC("Poison Zombie (Slump)","npc_vj_hlr2_zombie_poison_slump",vCat)
			VJ.AddNPC("Zombine (Slump)","npc_vj_hlr2_zombine_slump",vCat)

			VJ.AddNPC("Zombie (Beta)","npc_vj_hlr2b_zombie",vCat)
			-- VJ.AddNPC("Zombie (2002)","npc_vj_hlr2b_zombie_fat",vCat)
			VJ.AddNPC("Fast Zombie (Beta)","npc_vj_hlr2b_zombie_fast",vCat)
			VJ.AddNPC("Poison Zombie (Beta)","npc_vj_hlr2b_zombie_poison",vCat)
			VJ.AddNPC("Headcrab (Beta)","npc_vj_hlr2b_headcrab",vCat)
			VJ.AddNPC("Fast Headcrab (Beta)","npc_vj_hlr2b_headcrab_fast",vCat)
			VJ.AddNPC("Poison Headcrab (Beta)","npc_vj_hlr2b_headcrab_poison",vCat)
		
			-- Wild Life
			-- VJ.AddNPC("Blob","npc_vj_hlr2_blob",vCat) -- Probably won't keep
			VJ.AddNPC("Leech","npc_vj_hlr2_leech",vCat)
			VJ.AddNPC("Hydra","npc_vj_hlr2b_hydra",vCat)
			VJ.AddNPC("Bullsquid","npc_vj_hlr2b_bullsquid",vCat)
			VJ.AddNPC("Houndeye","npc_vj_hlr2b_houndeye",vCat)
			VJ.AddNPC("Ichthyosaur","npc_vj_hlr2_ichthyosaur",vCat)
			-- VJ.AddCeilingNPC("Barnacle","npc_vj_hlr2_barnacle",vCat)
			-- VJ.AddNPC("Sand Barnacle","npc_vj_hlr2b_barnacle_sand",vCat)
	
	-- ConVars --
	VJ.AddParticle("particles/advisor.pcf",{})
	VJ.AddParticle("particles/aurora.pcf",{})
	VJ.AddParticle("particles/advisor.pcf",{})
	VJ.AddParticle("particles/advisor_fx.pcf",{})
	VJ.AddParticle("particles/vj_hlr_flechette.pcf",{})
	VJ.AddParticle("particles/vj_hlr_flechette_projectile.pcf",{"hunter_flechette_trail","hunter_projectile_explosion_1"})
	VJ.AddParticle("particles/vj_hlr_hunter_shield.pcf",{"vj_hlr_huntershield_impact1"})
	VJ.AddParticle("particles/warpshield.pcf",{})
	
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if CLIENT then
		chat.AddText(Color(0, 200, 200), PublicAddonName,
		Color(0, 255, 0), " was unable to install, you are missing ",
		Color(255, 100, 0), "VJ Base!")
	end
	
	timer.Simple(1, function()
		if not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				// Get rid of old error messages from addons running on older code...
				if VJF && type(VJF) == "Panel" then
					VJF:Close()
				end
				VJF = true
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 160)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("Error: VJ Base is missing!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(250, 30)
				labelTitle:SetText("VJ BASE IS MISSING!")
				labelTitle:SetTextColor(Color(255,128,128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(170, 50)
				label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 70)
				label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(195, 100)
				link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
				link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 120)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif (SERVER) then
				VJF = true
				timer.Remove("VJBASEMissing")
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is missing! Download it from the Steam Workshop! Link: https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end)
			end
		end
	end)
end