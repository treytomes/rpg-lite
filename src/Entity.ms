Entity = {
    "script": null,
}

Entity.init = function(spritesetName, index, name)
    self.name = name
    self.animation = spriteControllers.newAnimation([
        Sprites[spritesetName][0].get(index),
        Sprites[spritesetName][1].get(index),
    ])
    self.animation.speed = 0.5
    self.animationFrame = 0
    self.speed = 2
    self.sprite = new spriteControllers.Animated
    self.sprite.scale = RENDER_SCALE
    self.sprite.play self.animation
    self.targetPostion = math.Point.zero
    display(DisplayType.SPRITE).sprites.push self.sprite
end function

// Generate a new entity from an object in the Tiled level.
Entity.make = function(level, name)
    entityLayer = level.getByName("entities")
    entity = entityLayer.getByName(name)

    spritesheetName = entity["Sprite Sheet"]
    index = entity["Sprite Index"]

    e = new Entity
    e.init spritesheetName, index, name

    e.moveTo math.transformTiledObject(entity)

    return e
end function

// `relativeTo` is an entity reference.
Entity.moveTo = function(pnt)
    self.sprite.x = pnt.x
    self.sprite.y = pnt.y
    self.targetPosition = pnt
end function

Entity.moveBy = function(level, delta)
    if self.isMoving then
        return false
    end if
    targetPosition = math.Point.make(self.sprite).add(delta)

    targetTileX = targetPosition.x + TILEDISPLAY_CENTER_X
    targetTileX = targetTileX / TILE_SIZE_PIXELS - 0.5

    targetTileY = targetPosition.y + TILEDISPLAY_CENTER_Y
    targetTileY = targetTileY / TILE_SIZE_PIXELS - 0.5
    targetTileY = TILE_LEVEL_SIZE - targetTileY - 1

    if level.isBlocked(targetTileX, targetTileY) then
        return false
    end if
    self.targetPosition = targetPosition
    return true
end function

Entity.isMoving = function()
    return not math.Point.make(self.sprite).equals(self.targetPosition)
end function

Entity.tileX = function()
    x = self.sprite.x + TILEDISPLAY_CENTER_X
    x = x / TILE_SIZE_PIXELS - 0.5
    return x
end function

Entity.tileY = function()
    y = self.sprite.y + TILEDISPLAY_CENTER_Y
    y = y / TILE_SIZE_PIXELS - 0.5
    y = TILE_LEVEL_SIZE - y - 1
    return y
end function

Entity.targetTileX = function()
    x = self.targetPosition.x + TILEDISPLAY_CENTER_X
    x = x / TILE_SIZE_PIXELS - 0.5
    return x
end function

Entity.targetTileY = function
    y = self.targetPosition.y + TILEDISPLAY_CENTER_Y
    y = y / TILE_SIZE_PIXELS - 0.5
    y = TILE_LEVEL_SIZE - y - 1
    return y
end function

// deltaTime is in seconds.
Entity.update = function(deltaTime)
    spritePoint = math.Point.make(self.sprite)
    vector = self.targetPosition.subtract(spritePoint)
    distance = vector.length
    if distance < 1 then
        self.moveTo self.targetPosition
    else if distance >= 1 then
        normalizedVector = vector.normalize.multiply(self.speed)
        self.sprite.x += normalizedVector.x
        self.sprite.y += normalizedVector.y
    end if
end function

return Entity
