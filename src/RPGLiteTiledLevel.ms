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

return RPGLiteTiledLevel