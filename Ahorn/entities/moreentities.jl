module MoreEntities

using ..Ahorn, Maple

glassblockcodename = "glassBlock"
glassblockbgcodename = "BGGlassBlock"

GlassBlock(x::Integer, y::Integer, width::Integer=16, height::Integer=16, sinks::Bool=false) = Maple.Entity(glassblockcodename, x=x, y=y, width=width, height=height, sinks=sinks)
GlassBlockBG(x::Integer, y::Integer, width::Integer=16, height::Integer=16, sinks::Bool=false) = Maple.Entity(glassblockbgcodename, x=x, y=y, width=width, height=height, sinks=sinks)

RefillUpdated(x::Integer, y::Integer, twoDash::Bool, oneUse::Bool) = Maple.Entity("refill", x=x, y=y, twoDash=twoDash, oneUse=oneUse)
KeyUpdated(x::Integer, y::Integer) = Maple.Entity("key", x=x, y=y)

BigWaterfall(x::Integer, y::Integer, width::Integer=16, height::Integer=32, layer::String="FG") = Entity("bigWaterfall", x=x, y=y, width=width, height=height, layer=layer)

placements = Dict{String, Ahorn.EntityPlacement}(
    "Intro Car" => Ahorn.EntityPlacement(
        Maple.IntroCar
    ),
    "Starjump Block" => Ahorn.EntityPlacement(
        Maple.StarJumpBlock,
	    "rectangle",
	    Dict{String, Any}(
		    "sinks" => true
	    )
    ),
    "Trapdoor" => Ahorn.EntityPlacement(
        Maple.TrapDoor
    ),
    "Heart Gate" => Ahorn.EntityPlacement(
	    (x, y) -> Maple.HeartDoor(x, y, 16, 96, 4),
	    "rectangle",
	    Dict{String, Any}(
		    "requires" => 4
	    )
    ),
    "Sound Source" => Ahorn.EntityPlacement(
        Maple.SoundSource
    ),
    "Memorial (Everest)" => Ahorn.EntityPlacement(
        (x, y) -> Maple.EverestMemorial(x, y, false, "MEMORIAL", "scenery/memorial/memorial")
    ),
    "Core Text (Everest)" => Ahorn.EntityPlacement(
        Maple.EverestCoreMessage
    ),
    "Core Text" => Ahorn.EntityPlacement(
        Maple.CoreMessage
    ),
    "Glass Block" => Ahorn.EntityPlacement(
        (x, y) -> GlassBlock(x, y, 16, 16, false),
        "rectangle",
        Dict{String,Any}(
            "width" => 16,
            "height" => 16
        )
    ),
    "Glass Block (BG)" => Ahorn.EntityPlacement(
        (x, y) -> GlassBlockBG(x, y, 16, 16, false),
        "rectangle",
        Dict{String,Any}(
            "width" => 16,
            "height" => 16
        )
    ),
    "Dream Mirror" => Ahorn.EntityPlacement(
        Maple.DreamMirror
    ),
    "Lightbeam" => Ahorn.EntityPlacement(
        # note to self: lightbeams are RECTANGLES you fuckin dumb eediot
        (x, y) -> Maple.Lightbeam(x, y, 16, 8, 0),
	    "rectangle"
    ),
    "Floating Debris" => Ahorn.EntityPlacement(
        Maple.FloatingDebris,
	    "point"
    ),
    "Foreground Debris" => Ahorn.EntityPlacement(
        Maple.ForegroundDebris,
	    "point"
    ),
    "Waterfall (Big)" => Ahorn.EntityPlacement(
        BigWaterfall,
        "rectangle"
    ),
    "Refill (1.2.5.0)" => Ahorn.EntityPlacement(
	    (x, y) -> RefillUpdated(x, y, false, false)
    ),
    "Key (1.2.6.0)" => Ahorn.EntityPlacement(
        KeyUpdated
    )
)

function nodeLimits(entity::Maple.Entity)
    if entity.name == "key"
        return true, 0, -1
    end
end

function editingOptions(entity::Maple.Entity)
    if entity.name == "bigWaterfall"
        return true, Dict{String, Any}(
            "layer" => String["FG", "BG"]
        )
    end
end

function minimumSize(entity::Maple.Entity)
    if entity.name == "starJumpBlock" ||
        entity.name == glassblockcodename || 
        entity.name == glassblockbgcodename || 
        entity.name == "bigWaterfall"
        return true, 8, 8
    end
    if entity.name == "heartGemDoor"
        return true, 16, 1
    end
    if entity.name == "lightbeam"
        return true, 6, 6
    end
end

function resizable(entity::Maple.Entity)
    if entity.name == "starJumpBlock" || 
        entity.name == "heartGemDoor" || 
        entity.name == glassblockcodename || 
        entity.name == glassblockbgcodename || 
        entity.name == "bigWaterfall" ||
        entity.name == "lightbeam"
        return true, true, true
    end
end

function renderSelectedAbs(ctx::Ahorn.Cairo.CairoContext, entity::Maple.Entity)
    if entity.name == "key"
        x, y = Ahorn.entityTranslation(entity)
        nodes = get(entity.data, "nodes", ())
        
        if !isempty(nodes)
            nx, ny = Int.(nodes[1])
            Ahorn.drawSprite(ctx, "collectables/key/idle00.png", nx, ny)
            Ahorn.drawArrow(ctx, x, y, nx, ny, Ahorn.colors.selection_selected_fc, headLength=6)
        end
    end
end

function selection(entity::Maple.Entity)
    if entity.name == "floatingDebris"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 6, y - 6, 12, 12)
    end

    if entity.name == "foregroundDebris"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 24, y - 1, 24, 24)
    end

    if entity.name == "refill"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 6, y - 6, 12, 12)
    end

    if entity.name == "key"
        x, y = Ahorn.entityTranslation(entity)
        nodes = get(entity.data, "nodes", ())

        if isempty(nodes)
            return true, Ahorn.Rectangle(x - 8, y - 8, 16, 16)
        else
            nx, ny = Int.(nodes[1])
            return true, [Ahorn.Rectangle(x - 8, y - 8, 16, 16), Ahorn.Rectangle(nx - 8, ny - 8, 16, 16)]
        end
    end

    if entity.name == "introCar"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 22, y - 18, 47, 18)
    end

    if entity.name == "trapdoor"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x, y + 4, 24, 8)
    end

    if entity.name == "soundsource"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x, y, 8, 8)
    end

    if entity.name == "everest/coreMessage" || entity.name == "coreMessage"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x, y, 8, 8)
    end

    if entity.name == "heartGemDoor"
        x, y = Ahorn.entityTranslation(entity)
	    width = Int(get(entity.data, "width", 8))
	    height = Int(get(entity.data, "height", 8))
        return true, Ahorn.Rectangle(x, y-216, width, 432)
    end

    if entity.name == "everest/memorial"
	    x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 20, y - 60, 40, 60)
    end

    if entity.name == "dreammirror"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 32, y - 32, 64, 32)
    end

    if entity.name == "lightbeam"
        x, y = Ahorn.entityTranslation(entity)
        width = Int(get(entity.data, "width", 8))
        height = Int(get(entity.data, "height", 8))
        return true, Ahorn.Rectangle(x-width/2, y, width, height)
    end

    # generic rectangle selection
    if entity.name == glassblockcodename || 
        entity.name == glassblockbgcodename ||
        entity.name == "starJumpBlock" ||
        entity.name == "bigWaterfall"
        x, y = Ahorn.entityTranslation(entity)
        width = Int(get(entity.data, "width", 8))
        height = Int(get(entity.data, "height", 8))
        return true, Ahorn.Rectangle(x, y, width, height)
    end
end

bigWaterfallColor = (135, 206, 250, 1) ./ (255, 255, 255, 1.0) .* (0.4, 0.6, 0.7, 0.7)

function radToDegree(rad::Number)
    return rad * (180/π)
end

function render(ctx::Ahorn.Cairo.CairoContext, entity::Maple.Entity, room::Maple.Room)
    if entity.name == "key"
        Ahorn.drawSprite(ctx, "collectables/key/idle00.png", 0, 0)
        return true
    end

    if entity.name == "refill"
        twoDash = Bool(get(entity.data, "twoDash", false))
        if twodash
            Ahorn.drawSprite(ctx, "objects/refillTwo/idle00.png", 0, 0)
        else
            Ahorn.drawSprite(ctx, "objects/refill/idle00.png", 0, 0)
        end

        return true
    end

    if entity.name == "floatingDebris"
        x, y = Ahorn.entityTranslation(entity)
        Ahorn.drawSprite(ctx, "debris/b.png", 0, 0)
        return true
    end

    if entity.name == "foregroundDebris"
        x, y = Ahorn.entityTranslation(entity)
        Ahorn.drawSprite(ctx, "scenery/fgdebris/rock_a00.png", 0, 0)
        return true
    end

    if entity.name == "introCar"
	    x, y = Ahorn.entityTranslation(entity)
	    Ahorn.drawSprite(ctx, "scenery/car/wheels.png", 0, -9)
        Ahorn.drawSprite(ctx, "scenery/car/body.png", 0, -9)

        return true
    end

    if entity.name == "trapdoor"
	    x, y = Ahorn.entityTranslation(entity)
        Ahorn.drawSprite(ctx, "objects/door/trap01.png", 12, 16)

        return true
    end

    if entity.name == "soundsource"
	    x, y = Ahorn.entityTranslation(entity)
        Ahorn.drawSprite(ctx, "objects/ahornrender/sound.png", 4, 4)

        return true
    end

    if entity.name == "everest/coreMessage" || entity.name == "coreMessage"
        x, y = Ahorn.entityTranslation(entity)
        Ahorn.drawSprite(ctx, "objects/ahornrender/textsample.png", 0, 0)
        return true
    end

    if entity.name == "everest/memorial"
	    sprite = get(entity.data, "sprite", "scenery/memorial/memorial")
        Ahorn.drawSprite(ctx, sprite, 0, -32)

        return true
    end

    if entity.name == "starJumpBlock"
        x = Int(get(entity.data, "x", 0))
        y = Int(get(entity.data, "y", 0))

        width = Int(get(entity.data, "width", 32))
        height = Int(get(entity.data, "height", 32))

	    Ahorn.drawRectangle(ctx, 0, 0, width, height, (0, 0, 0, 0) ./ 255, (255, 255, 255, 255) ./ 255)

        return true
    end

    if entity.name == glassblockcodename || entity.name == glassblockbgcodename
        x = Int(get(entity.data, "x", 0))
        y = Int(get(entity.data, "y", 0))

        width = Int(get(entity.data, "width", 32))
        height = Int(get(entity.data, "height", 32))

	    Ahorn.drawRectangle(ctx, 0, 0, width, height, (0, 0, 0, 150) ./ 255, (255, 255, 255, 255) ./ 255)

        return true
    end

    if entity.name == "heartGemDoor"
        x, y = Ahorn.entityTranslation(entity)
	    width = Int(get(entity.data, "width", 8))
	    height = Int(get(entity.data, "height", 8))
	    rwidth, rheight = room.size

	    Ahorn.drawRectangle(ctx, 0, 32, width, rheight, (76, 168, 214, 102) ./ 255, (108, 214, 235, 255) ./ 255)
	    Ahorn.drawRectangle(ctx, 0, -32-rheight, width, rheight, (76, 168, 214, 102) ./ 255, (108, 214, 235, 255) ./ 255)
        Ahorn.drawRectangle(ctx, 0, -32, width, 64, (76, 168, 214, 102) ./ 255, (108, 214, 235, 0) ./ 255)
        
        return true
    end

    if entity.name == "dreammirror"
	    x, y = Ahorn.entityTranslation(entity)
	    Ahorn.drawSprite(ctx, "objects/mirror/glassbreak00.png", 0, -14)
        Ahorn.drawSprite(ctx, "objects/mirror/frame.png", 0, -16)

        return true
    end

    if entity.name == "lightbeam"
        x, y = Ahorn.entityTranslation(entity)
	    width = Int(get(entity.data, "width", 8))
	    height = Int(get(entity.data, "height", 8))
        ang = Int(get(entity.data, "rotation", 0))

        # no idea how to make this work, please help

        # nx = cos(ang) * 32
        # ny = sin(radToDegree(ang)) * 32

        Ahorn.drawRectangle(ctx, 0-width/2, 0, width, height, (255, 255, 255, 150) ./ 255, (255, 255, 255, 255) ./ 255)
        # Ahorn.drawArrow(ctx, 0, 0, nx, ny, (1.0, 1.0, 1.0, 1.0), headLength=6)
        return true
    end

    if entity.name == "bigWaterfall"
        x = Int(get(entity.data, "x", 0))
        y = Int(get(entity.data, "y", 0))
        width = Int(get(entity.data, "width", 0))
        height = Int(get(entity.data, "height", 0))

        Ahorn.drawRectangle(ctx, 0, 0, width, height, bigWaterfallColor, (0.0, 0.0, 0.0, 0.0))
        return true
    end

    return false
end

end
