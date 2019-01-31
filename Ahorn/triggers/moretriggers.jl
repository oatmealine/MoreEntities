module MoreEntities

using ..Ahorn, Maple

placements = Dict{String, Ahorn.EntityPlacement}(
    "Change Inventory Trigger" => Ahorn.EntityPlacement(
        (x, y) -> Maple.Trigger("everest/changeInventoryTrigger", x=x, y=y, width=16, height=16),
        "rectangle",
        Dict{String, Any}(
            "inventory" => ""
        )
    )
)

end
