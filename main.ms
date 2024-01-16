env.importPaths = [
	"/sys/lib",
	"./lib/minimicro-tiled",
]

import "qa"
import "spriteControllers"
import "stringUtil"

import "lib/tiled/tiled"
Tiled = locals["lib/tiled/tiled"]

// The DawnLike tiles were designed to have a base tile layer along with a decoration tile layer that sits
// on top of the base but potentially below the sprites.  Maybe layers 5 and 6?

DisplayType = {
    "QA": 0, // pre-defined
    "UI": 1,
    "TEXT": 3,
    // "TILE_OVER": 4,
    "SPRITE": 4, // pre-defined
    "TILE_BASE": 5,
    "SOLID": 7, // pre-defined
}

Key = {
    "UP": 19,
    "DOWN": 20,
    "LEFT": 17,
    "RIGHT": 18,
    "EXIT": 27,
}

SPRITE_WIDTH = 16
SPRITE_HEIGHT = 16
RENDER_SCALE = 4
SPRITESHEET_WIDTH = 128
SPRITESHEET_HEIGHT = 240
ANIMATION_SPEED = 0.300 // seconds

text.clear
gfx.clear

display(DisplayType.UI).mode = displayMode.off
// display(DisplayType.TEXT).mode = displayMode.off

// display(DisplayType.TILE_OVER).mode = displayMode.off
// d = new TileDisplay
// d.install DisplayType.TILE_OVER

// display(DisplayType.TILE_BASE).mode = displayMode.off
d = new TileDisplay
d.install DisplayType.TILE_BASE

// display(6).mode = displayMode.off


display(DisplayType.SOLID).mode = displayMode.solidColor
display(DisplayType.SOLID).color = color.blue

display(DisplayType.SPRITE).mode = displayMode.sprite
disp = display(DisplayType.SPRITE)
disp.clear

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
    tilesPerRow = SPRITESHEET_WIDTH / SPRITE_WIDTH
    x = index % tilesPerRow
    y = floor(index / tilesPerRow)

    sheetX = x * SPRITE_WIDTH
    sheetY = SPRITESHEET_HEIGHT - SPRITE_HEIGHT * (y + 1)
    return self.image.getImage(sheetX, sheetY, SPRITE_WIDTH, SPRITE_HEIGHT)
end function

Player = {}
Player.init = function()
end function

Player.make = function()
    p = new Player
    p.init
    return p
end function

// tlevel = Tiled.load("lib/minimicro-tiled/res/tilemaps/dungeon1.json", "lib/minimicro-tiled/res/tilemaps")
tlevel = Tiled.load("assets/maps/Logo.tmj", "assets/tilesets")
// tlevel = Tiled.load("assets/maps/Town.tmj", "assets/tilesets")
qa.assert(not tlevel.error, "Error loading tiled level: {0}".fill([tlevel.error]))

player0Sprites = SpriteSheet.make("assets/DawnLike/Characters/Player0.png")
player1Sprites = SpriteSheet.make("assets/DawnLike/Characters/Player1.png")

playerImages = spriteControllers.newAnimation([
    player0Sprites.get(26),
    player1Sprites.get(26),
])
playerImages.speed = 0.5
playerAnimationFrame = 0
playerSpeed = 4

playerSprite = new spriteControllers.Animated

playerSprite.scale = RENDER_SCALE

playerSprite.play playerImages

PIXEL_WIDTH = 960
PIXEL_HEIGHT = 640
playerSprite.x = PIXEL_WIDTH / 2 - SPRITE_WIDTH / 2
playerSprite.y = PIXEL_HEIGHT / 2 - SPRITE_HEIGHT / 2
disp.sprites.push playerSprite

lastAnimationTime = time
isDone = false
lastFrameTime = time

//                       Tiled Layer, Display layer         , Tileset img index
// Town
// tlevel.addRenderLayer 0          , DisplayType.TILE_OVER , 0
// tlevel.addRenderLayer 1          , DisplayType.TILE_BASE, 0

// Logo
tlevel.addRenderLayer 0          , DisplayType.TILE_BASE , 0

tlevel.setZoom RENDER_SCALE
tlevel.render

while not isDone
    deltaTime = time - lastFrameTime
    lastFrameTime = time

    if key.available then
        k = key.get
        // print "k: {0} {1}".fill([k, code(k)])
        k = code(k)
        if k == Key.EXIT then isDone = true
    end if

    deltaX = key.axis("Horizontal") * playerSpeed
    deltaY = key.axis("Vertical") * playerSpeed

    // playerSprite.x += deltaX
	// playerSprite.y += deltaY

    // display(DisplayType.TILE_OVER).scrollX += deltaX
    // display(DisplayType.TILE_OVER).scrollY += deltaY

    display(DisplayType.TILE_BASE).scrollX += deltaX
    display(DisplayType.TILE_BASE).scrollY += deltaY

    // print "deltaTime: {0}".fill([deltaTime])
    spriteControllers.updateSprites deltaTime

    yield
end while

key.clear

text.clear
gfx.clear
display(DisplayType.TILE_BASE).clear
display(DisplayType.SPRITE).clear
display(DisplayType.SOLID).color = color.black

print "Goodbye!"
