Entity = {}
Entity.init = function(spritesetName, index)
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
    e.init spritesheetName, index

    e.moveTo math.transformTiledObject(entity)

    return e
end function

// `relativeTo` is an entity reference.
Entity.moveTo = function(pnt)
    self.sprite.x = pnt.x
    self.sprite.y = pnt.y
    self.targetPosition = pnt
end function

Entity.moveBy = function(delta) //, relativeTo)
    // self.moveTo math.Point.make(self.sprite).add(delta)
    self.targetPosition = math.Point.make(self.sprite).add(delta)
end function

Entity.isMoving = function()
    return not math.Point.make(self.sprite).equals(self.targetPosition)
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
