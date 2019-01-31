module MoreEntities

using ..Ahorn, Maple

glassblockcodename = "glassBlock"
glassblockbgcodename = "BGGlassBlock"

GlassBlock(x::Integer, y::Integer, width::Integer=16, height::Integer=16, sinks::Bool=false) = Maple.Entity(glassblockcodename, x=x, y=y, width=width, height=height, sinks=sinks)
GlassBlockBG(x::Integer, y::Integer, width::Integer=16, height::Integer=16, sinks::Bool=false) = Maple.Entity(glassblockbgcodename, x=x, y=y, width=width, height=height, sinks=sinks)

RefillUpdated(x::Integer, y::Integer, twoDash::Bool, oneUse::Bool) = Maple.Entity("refill", x=x, y=y, twoDash=twoDash, oneUse=oneUse)
KeyUpdated(x::Integer, y::Integer) = Maple.Entity("key", x=x, y=y)


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
        (x, y) -> Maple.Lightbeam(x, y, 0),
	    "point"
    ),
    "Big Waterfall (FG)" => Ahorn.EntityPlacement(
        (x, y) -> Maple.BigWaterfall(x, y, 64, "FG"),
	    "point"
    ),
    "Big Waterfall (BG)" => Ahorn.EntityPlacement(
        (x, y) -> Maple.BigWaterfall(x, y, 64, "BG"),
	    "point",
        Dict{String,Any}(
            "height" => 64
        )
    ),
    "Floating Debris" => Ahorn.EntityPlacement(
        Maple.FloatingDebris,
	    "point"
    ),
    "Floating Debris (Foreground)" => Ahorn.EntityPlacement(
        Maple.ForegroundDebris,
	    "point"
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

function selection(entity::Maple.Entity)
    if entity.name == "lightbeam"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 6, y - 6, 12, 12)
    end
    if entity.name == "bigWaterfall"
        x, y = Ahorn.entityTranslation(entity)
        return true, Ahorn.Rectangle(x - 6, y - 6, 12, 12)
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

    if entity.name == "starJumpBlock"
        x, y = Ahorn.entityTranslation(entity)
	    width = Int(get(entity.data, "width", 8))
	    height = Int(get(entity.data, "height", 8))
        return true, Ahorn.Rectangle(x, y, width, height)
    end

    if entity.name == glassblockcodename || entity.name == glassblockbgcodename
        x, y = Ahorn.entityTranslation(entity)
	    width = Int(get(entity.data, "width", 16))
	    height = Int(get(entity.data, "height", 16))
        return true, Ahorn.Rectangle(x, y, width, height)
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
end

function minimumSize(entity::Maple.Entity)
    if entity.name == "starJumpBlock" || entity.name == glassblockcodename || entity.name == glassblockbgcodename
        return true, 8, 8
    end
    if entity.name == "heartGemDoor"
        return true, 16, 1
    end
end

function resizable(entity::Maple.Entity)
    if entity.name == "starJumpBlock" || entity.name == "heartGemDoor" || entity.name == glassblockcodename || entity.name == glassblockbgcodename
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
        Ahorn.drawSprite(ctx, "objects/refill/idle00.png", 0, 0)

        return true
    end
    if entity.name == "bigWaterfall"
        Ahorn.drawSprite(ctx, "objects/refill/idle00.png", 0, 0)

        return true
    end

    return false
end

end
