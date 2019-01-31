module CustomNPC

using ..Ahorn, Maple

CustomExudiasNPC(x::Integer, y::Integer) = Maple.Entity("everest/npc", x=x, y=y)

placements = Dict{String, Ahorn.EntityPlacement}(
    "Custom Exudias NPC" => Ahorn.EntityPlacement(
        CustomExudiasNPC,
        "point",
        Dict{String, Any}(
            "sprite" => "",
            "spriteRate" => 1,
            "dialogId" => "",
            "onlyOnce" => true,
            "endLevel" => false,
            "flipX" => false,
            "flipY" => false,
            "approachWhenTalking" => false,
            "approachDistance" => 16,
            "indicatorOffsetX" => 0,
            "indicatorOffsetY" => 0
        )
    )
)

function selection(entity::Maple.Entity)
    if entity.name == "everest/npc"
        x, y = Ahorn.entityTranslation(entity)

        res = Ahorn.Rectangle[Ahorn.Rectangle(x - 8, y -16, 16, 16)]

        return true, res
    end
end

borderMultiplier = (0.9, 0.9, 0.9, 1)

function render(ctx::Ahorn.Cairo.CairoContext, entity::Maple.Entity, room::Maple.Room)
    if entity.name == "everest/npc"
        Ahorn.drawSprite(ctx, "characters/oldlady/idle00.png", 0, -16)
        return true
    end
end

end