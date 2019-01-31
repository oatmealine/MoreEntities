module DialogCutsceneTrigger

using ..Ahorn, Maple

placements = Dict{String, Ahorn.EntityPlacement}(
    "Dialog Cutscene Trigger" => Ahorn.EntityPlacement(
        (x, y) -> Maple.Trigger("dialog/dialogtrigger", x=x, y=y, width=16, height=16),
        "rectangle",
        Dict{String, Any}(
        "dialogId" => "",
		"onlyOnce" => true
        )
    )
)

end