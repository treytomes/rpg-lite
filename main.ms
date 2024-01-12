import "qa"
import "stringUtil"

// Display 0: qa
// Display 1: ui
// Display 2: sprites
// Display 3: tiles

DisplayType = {
    "QA": 0, // pre-defined
    "UI": 1,
    "SPRITE": 4, // pre-defined
    "TILE": 6,
    "SOLID": 7,
}

Key = {
    "UP": 19,
    "DOWN": 20,
    "LEFT": 17,
    "RIGHT": 18,
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

player0Image = file.loadImage("assets/DawnLike/Characters/Player0.png")
player1Image = file.loadImage("assets/DawnLike/Characters/Player1.png")

playerImages = [
    player0Image.getImage(0, SPRITESHEET_HEIGHT - SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT),
    player1Image.getImage(0, SPRITESHEET_HEIGHT - SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT),
]
playerAnimationFrame = 0
playerSpeed = 4

playerSprite = new Sprite
playerSprite.image = playerImages[playerAnimationFrame]
playerSprite.scale = SPRITE_SCALE
playerSprite.x = 480
playerSprite.y = 320
disp.sprites.push playerSprite

lastAnimationTime = time
// angle = 0
while true
    // spr.rotation = angle
    // angle += 1

    // if key.available then
    //     k = key.get
    //     print "k: {0} {1}".fill([k, code(k)])
    //     k = code(k)
    //     if k == Key.UP then
    //         spr.y += 1
    //     else if k == Key.DOWN then
    //         spr.y -= 1
    //     else if k == Key.LEFT then
    //         spr.x -= 1
    //     else if k == Key.RIGHT then
    //         spr.x += 1
    //     end if
    // end if

    playerSprite.x += key.axis("Horizontal") * playerSpeed
	playerSprite.y += key.axis("Vertical") * playerSpeed

    if time - lastAnimationTime >= ANIMATION_SPEED then
        lastAnimationTime = time
        playerAnimationFrame = (playerAnimationFrame + 1) % playerImages.len
        playerSprite.image = playerImages[playerAnimationFrame]
    end if

    yield
end while

key.clear
