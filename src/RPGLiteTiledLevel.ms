RPGLiteTiledLevel = new TiledLevel
RPGLiteTiledLevel.COLLISION_LAYER_NAME = "collision"
RPGLiteTiledLevel.entities = []

RPGLiteTiledLevel.collisionLayer = function()
    return self.getByName(self.COLLISION_LAYER_NAME)
end function

RPGLiteTiledLevel.isBlocked = function(x, y)
    collisionLayer = self.collisionLayer
    tileIndex = collisionLayer.getTileIndex(x, y)
    isBlocked = collisionLayer.data[tileIndex] != 0
    if isBlocked then return true

    for entity in self.entities
        if entity.targetTileX == x and entity.targetTileY == y then return true
    end for
    return false
end function

RPGLiteTiledLevel.closestEntity = function(entity)
    targetDistance = TILE_LEVEL_SIZE_PIXELS * 2
    targetEntity = null
    entityPosition = entity.targetPosition

    for otherEntity in self.entities
        if refEquals(otherEntity, entity) then continue
        
        otherPosition = otherEntity.targetPosition
        otherDistance = otherPosition.distance(entityPosition)
        if otherDistance < targetDistance then
            targetDistance = otherDistance
            targetEntity = otherEntity
        end if
    end for

    return targetEntity
end function

return RPGLiteTiledLevel