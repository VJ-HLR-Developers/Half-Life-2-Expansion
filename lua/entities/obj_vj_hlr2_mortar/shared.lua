ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Mortar Synth"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Projectiles"

if (CLIENT) then
	VJ.AddKillIcon("obj_vj_hlr2_mortar", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end