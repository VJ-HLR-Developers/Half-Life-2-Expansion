AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {
	"models/vj_hlr/hl2_mod/combine_soldier_shw_a.mdl",
	"models/vj_hlr/hl2_mod/combine_soldier_shw_b.mdl",
	"models/vj_hlr/hl2_mod/combine_soldier_shw_c.mdl"
}

ENT.WeaponInventory_AntiArmor = true
ENT.WeaponInventory_AntiArmorList = {"weapon_vj_hlr2_mod_irpg"}

ENT.SoundTbl_FootStep = {
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_01.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_02.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_03.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_04.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_05.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_06.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_07.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_08.wav",
	"vj_hlr/hl2mod_npc/footsteps/combine_concrete_step_09.wav",
}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl2mod_npc/combine/overwatch_01.wav",
	"vj_hlr/hl2mod_npc/combine/overwatch_02.wav",
	"vj_hlr/hl2mod_npc/combine/overwatch_03.wav",
	"vj_hlr/hl2mod_npc/combine/overwatch_04.wav",
	"vj_hlr/hl2mod_npc/combine/overwatch_05.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vj_hlr/hl2mod_npc/combine/lostenemy_01.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_02.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_03.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_04.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_05.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_06.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_07.wav",
	"vj_hlr/hl2mod_npc/combine/lostenemy_08.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_01.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_02.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_03.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_04.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_05.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_06.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_07.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_08.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_09.wav",
	"vj_hlr/hl2mod_npc/combine/lostvisual_10.wav",
}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_01.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_02.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_03.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_04.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_05.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_06.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_07.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_08.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_09.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_cover_10.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_010.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_012.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_020.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_040.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_070.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_100.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_120.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_130.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_140.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_150.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_160.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_170.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_180.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_190.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl2mod_npc/combine/announceattack_01.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_02.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_03.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_04.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_05.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_06.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_07.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_08.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_09.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_10.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_11.wav",
	"vj_hlr/hl2mod_npc/combine/calloutentity_hostiles_01.wav",
}
ENT.SoundTbl_Alert_Antlions = {
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_01.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_02.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_03.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_04.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_05.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_06.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_07.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_08.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_09.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_antlion_10.wav",
}
ENT.SoundTbl_Alert_Headcrabs = {
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_01.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_02.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_03.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_04.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_05.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_06.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_07.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_08.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_09.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_headcrabs_10.wav",
	"vj_hlr/hl2mod_npc/combine/calloutentity_manyparasitics_01.wav"
}
ENT.SoundTbl_Alert_Zombies = {
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_01.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_02.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_03.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_04.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_05.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_06.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_07.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_08.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_09.wav",
	"vj_hlr/hl2mod_npc/combine/announceenemy_zombie_10.wav",
	"vj_hlr/hl2mod_npc/combine/calloutentity_necrotic_01.wav"
}
ENT.SoundTbl_WeaponReload = {
	"vj_hlr/hl2mod_npc/combine/coverme_01.wav",
	"vj_hlr/hl2mod_npc/combine/coverme_02.wav",
	"vj_hlr/hl2mod_npc/combine/coverme_03.wav",
	"vj_hlr/hl2mod_npc/combine/coverme_04.wav",
	"vj_hlr/hl2mod_npc/combine/coverme_05.wav",
	"vj_hlr/hl2mod_npc/combine/coverme_06.wav",
	"vj_hlr/hl2mod_npc/combine/coverme_07.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vj_hlr/hl2mod_npc/combine/nearpanic_01.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_02.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_03.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_04.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_05.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_06.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_07.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_08.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_09.wav",
	"vj_hlr/hl2mod_npc/combine/nearpanic_10.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_01.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_02.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_03.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_04.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_05.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_06.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_07.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_08.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_09.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_10.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_11.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_12.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_13.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_14.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_15.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_16.wav",
	"vj_hlr/hl2mod_npc/combine/advancing_on_target_17.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_030.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_050.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_060.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_080.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_090.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_110.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_111.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_01.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_02.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_03.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_04.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_05.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_06.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_07.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_08.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_09.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_10.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_11.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_12.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_13.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_14.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_15.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_16.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_17.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_18.wav",
	"vj_hlr/hl2mod_npc/combine/establishinglof_19.wav",
	"vj_hlr/hl2mod_npc/combine/orderresponse_positive_01.wav",
	"vj_hlr/hl2mod_npc/combine/orderresponse_positive_02.wav",
	"vj_hlr/hl2mod_npc/combine/orderresponse_positive_03.wav",
	"vj_hlr/hl2mod_npc/combine/orderresponse_positive_04.wav",
	"vj_hlr/hl2mod_npc/combine/orderresponse_positive_05.wav",
}
ENT.SoundTbl_Suppressing = {
	"vj_hlr/hl2mod_npc/combine/firing_01.wav",
	"vj_hlr/hl2mod_npc/combine/firing_02.wav",
	"vj_hlr/hl2mod_npc/combine/firing_03.wav",
	"vj_hlr/hl2mod_npc/combine/firing_04.wav",
	"vj_hlr/hl2mod_npc/combine/firing_05.wav",
	"vj_hlr/hl2mod_npc/combine/firing_06.wav",
	"vj_hlr/hl2mod_npc/combine/firing_07.wav",
	"vj_hlr/hl2mod_npc/combine/firing_08.wav",
	"vj_hlr/hl2mod_npc/combine/firing_09.wav",
	"vj_hlr/hl2mod_npc/combine/firing_10.wav",
	"vj_hlr/hl2mod_npc/combine/firing_110.wav",
	"vj_hlr/hl2mod_npc/combine/firing_111.wav",
	"vj_hlr/hl2mod_npc/combine/firing_112.wav",
	"vj_hlr/hl2mod_npc/combine/firing_120.wav",
	"vj_hlr/hl2mod_npc/combine/firing_121.wav",
	"vj_hlr/hl2mod_npc/combine/firing_122.wav",
	"vj_hlr/hl2mod_npc/combine/firing_130.wav",
	"vj_hlr/hl2mod_npc/combine/firing_131.wav",
	"vj_hlr/hl2mod_npc/combine/firing_132.wav",
	"vj_hlr/hl2mod_npc/combine/firing_140.wav",
	"vj_hlr/hl2mod_npc/combine/firing_141.wav",
	"vj_hlr/hl2mod_npc/combine/firing_142.wav",
	"vj_hlr/hl2mod_npc/combine/firing_150.wav",
	"vj_hlr/hl2mod_npc/combine/firing_151.wav",
	"vj_hlr/hl2mod_npc/combine/firing_152.wav",
	"vj_hlr/hl2mod_npc/combine/firing_160.wav",
	"vj_hlr/hl2mod_npc/combine/firing_161.wav",
	"vj_hlr/hl2mod_npc/combine/firing_162.wav",
	"vj_hlr/hl2mod_npc/combine/firing_170.wav",
	"vj_hlr/hl2mod_npc/combine/firing_171.wav",
	"vj_hlr/hl2mod_npc/combine/firing_172.wav",
	"vj_hlr/hl2mod_npc/combine/firing_180.wav",
	"vj_hlr/hl2mod_npc/combine/firing_181.wav",
	"vj_hlr/hl2mod_npc/combine/firing_182.wav",
	"vj_hlr/hl2mod_npc/combine/firing_190.wav",
	"vj_hlr/hl2mod_npc/combine/firing_191.wav",
	"vj_hlr/hl2mod_npc/combine/firing_192.wav",
	"vj_hlr/hl2mod_npc/combine/firing_200.wav",
	"vj_hlr/hl2mod_npc/combine/firing_201.wav",
	"vj_hlr/hl2mod_npc/combine/firing_202.wav",
	"vj_hlr/hl2mod_npc/combine/firing_210.wav",
	"vj_hlr/hl2mod_npc/combine/firing_211.wav",
	"vj_hlr/hl2mod_npc/combine/firing_212.wav",
	"vj_hlr/hl2mod_npc/combine/firing_220.wav",
	"vj_hlr/hl2mod_npc/combine/firing_221.wav",
	"vj_hlr/hl2mod_npc/combine/firing_222.wav",
	"vj_hlr/hl2mod_npc/combine/firing_230.wav",
	"vj_hlr/hl2mod_npc/combine/firing_231.wav",
	"vj_hlr/hl2mod_npc/combine/firing_232.wav",
}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_01.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_02.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_03.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_04.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_05.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_06.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_07.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_08.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_09.wav",
	"vj_hlr/hl2mod_npc/combine/announceattack_grenade_10.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_01.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_02.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_03.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_04.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_05.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_06.wav",
	"vj_hlr/hl2mod_npc/combine/flushing_07.wav",
	"vj_hlr/hl2mod_npc/combine/getback_01.wav",
	"vj_hlr/hl2mod_npc/combine/getback_02.wav",
	"vj_hlr/hl2mod_npc/combine/getback_03.wav",
	"vj_hlr/hl2mod_npc/combine/getback_04.wav",
	"vj_hlr/hl2mod_npc/combine/getback_05.wav",
}
ENT.SoundTbl_Investigate = {
	"vj_hlr/hl2mod_npc/combine/hear_suspicious_01.wav",
	"vj_hlr/hl2mod_npc/combine/hear_suspicious_02.wav",
	"vj_hlr/hl2mod_npc/combine/hear_suspicious_03.wav",
	"vj_hlr/hl2mod_npc/combine/hear_suspicious_04.wav",
	"vj_hlr/hl2mod_npc/combine/hear_suspicious_05.wav",
	"vj_hlr/hl2mod_npc/combine/hear_suspicious_06.wav",
}
ENT.SoundTbl_OnGrenadeSight = {
	"vj_hlr/hl2mod_npc/combine/danger_grenade_01.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_02.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_03.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_04.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_05.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_06.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_07.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_08.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_09.wav",
	"vj_hlr/hl2mod_npc/combine/danger_grenade_10.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vj_hlr/hl2mod_npc/combine/announcekill_01.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_02.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_03.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_04.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_05.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_06.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_07.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_08.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_09.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_10.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_11.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_12.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_13.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_14.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_15.wav",
}
ENT.SoundTbl_OnKilledEnemy_Antlions = {
	"vj_hlr/hl2mod_npc/combine/announcekill_antlion_01.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_antlion_02.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_antlion_03.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_antlion_04.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_antlion_05.wav",
}
ENT.SoundTbl_OnKilledEnemy_Headcrabs = {
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_01.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_02.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_03.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_04.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_05.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_06.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_07.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_08.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_headcrab_09.wav",
}
ENT.SoundTbl_OnKilledEnemy_Zombies = {
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_01.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_02.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_03.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_04.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_05.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_06.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_zombie_07.wav",
}
ENT.SoundTbl_OnKilledEnemy_Player = {
	"vj_hlr/hl2mod_npc/combine/announcekill_player_01.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_02.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_03.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_04.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_05.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_06.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_07.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_08.wav",
	"vj_hlr/hl2mod_npc/combine/announcekill_player_09.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl2mod_npc/combine/injured_01.wav",
	"vj_hlr/hl2mod_npc/combine/injured_02.wav",
	"vj_hlr/hl2mod_npc/combine/injured_03.wav",
	"vj_hlr/hl2mod_npc/combine/injured_04.wav",
	"vj_hlr/hl2mod_npc/combine/injured_05.wav",
	"vj_hlr/hl2mod_npc/combine/injured_06.wav",
	"vj_hlr/hl2mod_npc/combine/injured_07.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl2mod_npc/combine/die_01.wav",
	"vj_hlr/hl2mod_npc/combine/die_02.wav",
	"vj_hlr/hl2mod_npc/combine/die_03.wav",
	"vj_hlr/hl2mod_npc/combine/die_04.wav",
	"vj_hlr/hl2mod_npc/combine/die_05.wav",
	"vj_hlr/hl2mod_npc/combine/die_06.wav",
	"vj_hlr/hl2mod_npc/combine/die_07.wav",
	"vj_hlr/hl2mod_npc/combine/die_08.wav",
	"vj_hlr/hl2mod_npc/combine/die_09.wav",
	"vj_hlr/hl2mod_npc/combine/die_10.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"vj_hlr/hl2mod_npc/combine/idle_02.wav",
	"vj_hlr/hl2mod_npc/combine/idle_04.wav",
	"vj_hlr/hl2mod_npc/combine/idle_05.wav",
	"vj_hlr/hl2mod_npc/combine/idle_06.wav",
	"vj_hlr/hl2mod_npc/combine/idle_07.wav",
	"vj_hlr/hl2mod_npc/combine/idle_08.wav",
	"vj_hlr/hl2mod_npc/combine/idle_09.wav",
	"vj_hlr/hl2mod_npc/combine/idle_12.wav",
	"vj_hlr/hl2mod_npc/combine/idle_13.wav",
	"vj_hlr/hl2mod_npc/combine/idle_14.wav",
	"vj_hlr/hl2mod_npc/combine/idle_15.wav",
	"vj_hlr/hl2mod_npc/combine/idle_19.wav",
	"vj_hlr/hl2mod_npc/combine/idle_20.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vj_hlr/hl2mod_npc/combine/combat_idle_190.wav",
	"vj_hlr/hl2mod_npc/combine/combat_idle_200.wav",
	"vj_hlr/hl2mod_npc/combine/idle_01.wav",
	"vj_hlr/hl2mod_npc/combine/idle_03.wav",
	"vj_hlr/hl2mod_npc/combine/idle_10.wav",
	"vj_hlr/hl2mod_npc/combine/idle_11.wav",
	"vj_hlr/hl2mod_npc/combine/idle_16.wav",
	"vj_hlr/hl2mod_npc/combine/idle_17.wav",
	"vj_hlr/hl2mod_npc/combine/idle_18.wav",
}

-- Custom
ENT.Combine_HasManHack = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	self.Combine_ChatterT = CurTime() + math.Rand(1, 30)
	self.Combine_HasManHack = math.random(1,3) == 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Combine_ChatterT < CurTime() then
		if math.random(1,2) == 1 then
			self.Combine_ChatterSd = VJ_CreateSound(self, SoundTbl_Combine_Chatter, 50, 90)
		end
		self.Combine_ChatterT = CurTime() + math.Rand(20, 40)
	end

	if self.Combine_HasManHack && IsValid(self:GetEnemy()) && self.LatestEnemyDistance <= 1000 && self.LatestEnemyDistance > 300 then
		self.Combine_HasManHack = false
		self:VJ_ACT_PLAYACTIVITY("grenDrop", true, false, true)
		timer.Simple(0.1, function()
			if IsValid(self) then
				self.Combine_ManHackProp = ents.Create("prop_vj_animatable")
				self.Combine_ManHackProp:SetModel("models/manhack.mdl")
				self.Combine_ManHackProp:SetLocalPos(self:GetPos())
				self.Combine_ManHackProp:SetAngles(self:GetAngles())
				self.Combine_ManHackProp:SetParent(self)
				self.Combine_ManHackProp:Spawn()
				self.Combine_ManHackProp:Fire("SetParentAttachment", "anim_attachment_LH", 0)
			end
		end)
		timer.Simple(0.85, function()
			if IsValid(self) then
				self.Combine_ManHackProp:Remove()
				local ent = ents.Create("npc_manhack")
				ent:SetPos(self.Combine_ManHackProp:GetPos() +self:GetForward() *15)
				ent:SetAngles(self.Combine_ManHackProp:GetAngles())
				ent.VJ_NPC_Class = self.VJ_NPC_Class
				table.insert(self.VJ_AddCertainEntityAsFriendly, ent)
				ent:Spawn()
				ent:GetPhysicsObject():AddVelocity(Vector(0,0,325))
				ent:Fire("SetMaxLookDistance",10000)
				ent:SetKeyValue("spawnflags","65536")
				ent:SetEnemy(self:GetEnemy())
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if string.find(argent:GetClass(),"antlion") then
		self:PlaySoundSystem("Alert",self.SoundTbl_Alert_Antlions)
		self.NextAlertSoundT = CurTime() +math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
	elseif string.find(argent:GetClass(),"headcrab") then
		self:PlaySoundSystem("Alert",self.SoundTbl_Alert_Headcrabs)
		self.NextAlertSoundT = CurTime() +math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
	elseif string.find(argent:GetClass(),"zombie") then
		self:PlaySoundSystem("Alert",self.SoundTbl_Alert_Zombies)
		self.NextAlertSoundT = CurTime() +math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent, attacker, inflictor)
	if !IsValid(argent) then return end
	if string.find(argent:GetClass(),"antlion") then
		self:PlaySoundSystem("OnKilledEnemy",self.SoundTbl_OnKilledEnemy_Antlions)
	elseif string.find(argent:GetClass(),"headcrab") then
		self:PlaySoundSystem("OnKilledEnemy",self.SoundTbl_OnKilledEnemy_Headcrabs)
	elseif string.find(argent:GetClass(),"zombie") then
		self:PlaySoundSystem("OnKilledEnemy",self.SoundTbl_OnKilledEnemy_Zombies)
	elseif argent:IsPlayer() then
		self:PlaySoundSystem("OnKilledEnemy",self.SoundTbl_OnKilledEnemy_Player)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/