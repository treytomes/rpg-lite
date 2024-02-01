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

// text: The string to measure.
// font: The font reference from the bmfFonts library.
measureString = function(txt, font)
    w = 0
    h = 0
    for ch in txt
        w += font.chars[ch].width
        if font.chars[ch].height > h then h = font.chars[ch].height
    end for
    return { "w": w, "h": h }
end function

clamp = function(value, exclusiveMin, exclusiveMax)
    if value < exclusiveMin then return exclusiveMin
    if value > exclusiveMax then return exclusiveMax
    return value
end function

Point = require("math/Point")
Rectangle = require("math/Rectangle")
