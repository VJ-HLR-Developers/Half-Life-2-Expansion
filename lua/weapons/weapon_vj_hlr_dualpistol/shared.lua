if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 								= "weapon_vj_base"
SWEP.PrintName							= "Dual Pistols"
SWEP.Author 							= "Cpt. Hazama"
SWEP.Contact							= ""
SWEP.Purpose							= ""
SWEP.Instructions						= ""

SWEP.WorldModel							= "models/weapons/w_pistol.mdl"
SWEP.HoldType 							= "pistol"
SWEP.Spawnable							= false
SWEP.AdminSpawnable						= false

SWEP.NPC_NextPrimaryFire 				= 0.1
SWEP.NPC_TimeUntilFire 					= 0
SWEP.NPC_TimeUntilFireExtraTimers 		= {}

SWEP.WorldModel_Invisible 				= true

SWEP.Primary.Sound						= {"vj_hlr/hl2_weapon/mp5k/smg1_fire2.wav"}
SWEP.Primary.DistantSound				= {"Weapon_Pistol.NPC_Single"}
SWEP.Primary.Damage						= 8
SWEP.Primary.ClipSize					= 999
SWEP.Primary.TracerType					= "AR2Tracer"

SWEP.PrimaryEffects_MuzzleFlash 		= false
SWEP.PrimaryEffects_SpawnShells 		= false

SWEP.Primary.Force						= 5
SWEP.Primary.Ammo						= "Pistol"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self:GetOwner(),self.CurrentMuzzle == "left" && 1 or 2)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnFireAnimationEvent(pos,ang,event,options)
	if event == 5001 then return true end
end