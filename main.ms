import "qa"
import "spriteControllers"
import "stringUtil"

DisplayType = {
    "QA": 0, // pre-defined
    "UI": 1,
    "SPRITE": 4, // pre-defined
    "TILE": 6,
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
SPRITE_SCALE = 4
SPRITESHEET_WIDTH = 128
SPRITESHEET_HEIGHT = 240
ANIMATION_SPEED = 0.300 // seconds

text.clear
gfx.clear

display(DisplayType.SOLID).color = color.blue

display(DisplayType.SPRITE).mode = displayMode.sprite
disp = display(4)
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

SpriteSheet.get = function(x, y)
    // tilesPerRow = SPRITESHEET_WIDTH / SPRITE_WIDTH
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

player0Sprites = SpriteSheet.make("assets/DawnLike/Characters/Player0.png")
player1Sprites = SpriteSheet.make("assets/DawnLike/Characters/Player1.png")

playerImages = spriteControllers.newAnimation([
    player0Sprites.get(0, 0),
    player1Sprites.get(0, 0),
])
playerImages.speed = 0.5
playerAnimationFrame = 0
playerSpeed = 4

playerSprite = new spriteControllers.Animated

playerSprite.scale = SPRITE_SCALE

playerSprite.play playerImages

playerSprite.x = 480
playerSprite.y = 320
disp.sprites.push playerSprite

lastAnimationTime = time
isDone = false
lastFrameTime = time
while not isDone
    deltaTime = time - lastFrameTime
    lastFrameTime = time

    if key.available then
        k = key.get
        // print "k: {0} {1}".fill([k, code(k)])
        k = code(k)
        if k == Key.EXIT then isDone = true
    end if

    playerSprite.x += key.axis("Horizontal") * playerSpeed
	playerSprite.y += key.axis("Vertical") * playerSpeed

    // print "deltaTime: {0}".fill([deltaTime])
    spriteControllers.updateSprites deltaTime

    yield
end while

key.clear

text.clear
gfx.clear
display(DisplayType.SPRITE).clear
display(DisplayType.SOLID).color = color.black

print "Goodbye!"
