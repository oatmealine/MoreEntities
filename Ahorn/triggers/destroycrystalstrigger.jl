module DestroyCrystalsTrigger

using ..Ahorn, Maple

placements = Dict{String, Ahorn.EntityPlacement}(
    "Destroy Crystals (In trigger)" => Ahorn.EntityPlacement(
        (x, y) -> Maple.Trigger("everest/goAwayCrystalsTrigger", x=x, y=y, width=16, height=16),
        "rectangle",
        Dict{String, Any}(
        "destroyEveryCrystal" => "InTrigger"
        )
    ),
    "Destroy Crystals (Every crystal)" => Ahorn.EntityPlacement(
        (x, y) -> Maple.Trigger("everest/goAwayCrystalsTrigger", x=x, y=y, width=16, height=16),
        "rectangle",
        Dict{String, Any}(
        "destroyEveryCrystal" => "EveryCrystal"
        )
    )
)

end