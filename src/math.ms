// Scales an object with (x, y) properties.
scale = function(pnt, value)
    pnt.x *= value
    pnt.y *= value
    return pnt
end function

// Translate an object with (x, y) properties by another object with (x, y) properties.
translate = function(pnt, value)
    pnt.x += value.x
    pnt.y += value.y
    return pnt
end function

// Convert Tiled pixel coordinated into MiniMicro coordinates.
// The input `obj` will be mutated.
transformTiledObject = function(obj)
    obj = scale(obj, RENDER_SCALE)

    // Invert the y according to the pixel height of the map.
    obj.y = tlevel.height * TILE_SIZE * RENDER_SCALE - obj.y

    // Offset by the physical render position of the player.
    // Is this right?  Test again when we have more than one sprite.
    obj = translate(obj, {"x": -playerSprite.x, "y": -playerSprite.y})

    TILE_OFFSET_HALF = TILE_SIZE * RENDER_SCALE / 2
    obj = translate(obj, {"x": TILE_OFFSET_HALF, "y": TILE_OFFSET_HALF})
end function
