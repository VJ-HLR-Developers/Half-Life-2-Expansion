ENT.Base 			= "npc_vj_human_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Combine Assassin"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
    local mat = Material("sprites/light_glow02_add")
    local size = 12
    local col = Color(255,0,0)
    function ENT:CustomOnDraw()
        local glowOrigin = self:GetAttachment(self:LookupAttachment("eyes")).Pos

        render.SetMaterial(mat)
        render.DrawSprite(glowOrigin, size, size, col)
        render.DrawSprite(glowOrigin, size, size, col)
    end
end