SpriteSheet = {}
SpriteSheet.init = function(imagePath)
    self.imagePath = imagePath
    self.image = file.loadImage(self.imagePath)
    self.tilesPerRow = self.image.width / TILE_SIZE
end function

SpriteSheet.make = function(imagePath)
    ss = new SpriteSheet
    ss.init imagePath
    return ss
end function

SpriteSheet.get = function(index)
    x = index % self.tilesPerRow
    y = floor(index / self.tilesPerRow)

    sheetX = x * TILE_SIZE
    sheetY = self.image.height - TILE_SIZE * (y + 1)
    return self.image.getImage(sheetX, sheetY, TILE_SIZE, TILE_SIZE)
end function

return SpriteSheet
