Entity = {}
Entity.init = function(spritesetName, index)
    self.animation = spriteControllers.newAnimation([
        Sprites[spritesetName][0].get(index),
        Sprites[spritesetName][1].get(index),
    ])
    self.animation.speed = 0.5
    self.animationFrame = 0
    self.speed = 4
    self.sprite = new spriteControllers.Animated
    self.sprite.scale = RENDER_SCALE
    self.sprite.play self.animation
    self.position = math.Point.make(0, 0)
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
end function

Entity.moveBy = function(delta) //, relativeTo)
    self.moveTo math.Point.make(self.sprite).add(delta)
end function

return Entity
