SpriteSheet = {}
SpriteSheet.init = function(imagePath)
    self.imagePath = imagePath
    self.image = file.loadImage(self.imagePath)
end function

SpriteSheet.make = function(imagePath)
    ss = new SpriteSheet
    ss.init imagePath
    return ss
end function

SpriteSheet.get = function(index)
    tilesPerRow = SPRITESHEET_WIDTH / TILE_SIZE
    x = index % tilesPerRow
    y = floor(index / tilesPerRow)

    sheetX = x * TILE_SIZE
    sheetY = SPRITESHEET_HEIGHT - TILE_SIZE * (y + 1)
    return self.image.getImage(sheetX, sheetY, TILE_SIZE, TILE_SIZE)
end function

return SpriteSheet
