module CompleteAreaTrigger

using ..Ahorn, Maple

placements = Dict{String, Ahorn.EntityPlacement}(
    "Complete Area" => Ahorn.EntityPlacement(
        (x, y) -> Maple.Trigger("everest/getMeOutTrigger", x=x, y=y, width=16, height=16),
        "rectangle"
    )
)

end