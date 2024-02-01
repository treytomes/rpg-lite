Camera = {}

Camera.minX = 0
Camera.maxX = TILE_LEVEL_SIZE_PIXELS - gfx.width
Camera.minY = 0
Camera.maxY = TILE_LEVEL_SIZE_PIXELS - gfx.height

Camera.init = function(trackingEntity)
    self.trackingEntity = trackingEntity
    return self
end function

Camera.make = function(trackingEntity)
    return (new Camera).init(trackingEntity)
end function

Camera.trackingX = function
    return self.trackingEntity.sprite.x
end function

Camera.trackingY = function
    return self.trackingEntity.sprite.y
end function

Camera.update = function
    if self.minX < self.trackingX and self.trackingX < self.maxX then
        tlevel.scrollTo(self.trackingX, tlevel.scrollY)
        display(DisplayType.SPRITE).scrollX = self.trackingX - TILEDISPLAY_CENTER_X
    end if

    if self.minY < self.trackingY and self.trackingY < self.maxY then
        tlevel.scrollTo(tlevel.scrollX, self.trackingY)
        display(DisplayType.SPRITE).scrollY = self.trackingY - TILEDISPLAY_CENTER_Y
    end if
end function

Camera.reset = function
    scrollX = math.clamp(self.trackingX, 0, self.maxX)
    scrollY = math.clamp(self.trackingY, 0, self.maxY)
    tlevel.scrollTo(scrollX, scrollY)
    display(DisplayType.SPRITE).scrollX = scrollX - TILEDISPLAY_CENTER_X
    display(DisplayType.SPRITE).scrollY = scrollY - TILEDISPLAY_CENTER_Y
end function

return Camera