// Convert Tiled pixel coordinated into MiniMicro coordinates.
// Return a Point object.
transformTiledObject = function(obj)
    pnt = Point.make(obj).multiply(RENDER_SCALE)

    // Invert the y according to the pixel height of the map.
    pnt.y = TILE_LEVEL_SIZE * TILE_SIZE_PIXELS - pnt.y

    // Offset by the physical render position of the player (the screen center).
    return pnt.add(Point.make(TILEDISPLAY_CENTER_X, TILEDISPLAY_CENTER_Y).negate).
        add(Point.make(TILE_SIZE_PIXELS, TILE_SIZE_PIXELS).multiply(0.5))
end function

Point = require("math/Point")
Rectangle = require("math/Rectangle")
