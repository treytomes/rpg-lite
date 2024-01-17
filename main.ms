import "listUtil"
import "qa"
import "spriteControllers"
import "stringUtil"

// Note how system-defined symbols can be extended.
env.addImportPath = function(path)
    // `self` == `env`
    if not self.importPaths.contains(path) then
        self.importPaths.push path
    end if
end function

env.addImportPath "./lib/minimicro-tiled"
env.addImportPath "./src"

import "lib/tiled/tiled"
Tiled = locals["lib/tiled/tiled"]

// The DawnLike tiles were designed to have a base tile layer along with a decoration tile layer that sits
// on top of the base but potentially below the sprites.  Maybe layers 5 and 6?

// I'm not seeing any tiles designed to be drawn over the sprites, which is just as well as I'm not sure where I'd put them.
// I'm not really wanting to ditch the default TextDisplay.

import "coreUtil"
import "constants"
import "math"
SpriteSheet = require("SpriteSheet")

text.clear
gfx.clear

display(DisplayType.UI).mode = displayMode.off
// display(DisplayType.TEXT).mode = displayMode.off

// display(DisplayType.TILE_OVER).mode = displayMode.off
// d = new TileDisplay  
// d.install DisplayType.TILE_OVER

d = new TileDisplay
d.install DisplayType.TILE_DECO

d = new TileDisplay
d.install DisplayType.TILE_BASE

display(DisplayType.SOLID).mode = displayMode.solidColor
display(DisplayType.SOLID).color = color.blue

display(DisplayType.SPRITE).mode = displayMode.sprite
disp = display(DisplayType.SPRITE)
disp.clear

Player = {}
Player.init = function()
end function

Player.make = function()
    p = new Player
    p.init
    return p
end function

// tlevel = Tiled.load("lib/minimicro-tiled/res/tilemaps/dungeon1.json", "lib/minimicro-tiled/res/tilemaps")
// tlevel = Tiled.load("assets/maps/Logo.tmj", "assets/tilesets")
tlevel = Tiled.load("assets/maps/Town_v2.tmj", "assets/tilesets")
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

// A pile of complicated math to ensure the player is rendered on the center tile.

playerSprite.x = TILEDISPLAY_CENTER_X
playerSprite.y = TILEDISPLAY_CENTER_Y

disp.sprites.push playerSprite

lastAnimationTime = time
isDone = false
lastFrameTime = time

//                       Tiled Layer, Display layer         , Tileset img index
// Town
// tlevel.addRenderLayer 0          , DisplayType.TILE_OVER , 0
// tlevel.addRenderLayer 1          , DisplayType.TILE_BASE, 0

// Logo
// tlevel.addRenderLayer 0          , DisplayType.TILE_BASE , 0

// Town_v2
tlevel.addRenderLayer 0          , DisplayType.TILE_BASE
tlevel.addRenderLayer 1          , DisplayType.TILE_DECO

// Load in all our deco tilesets so we can animate them.
tiles_deco = [
    file.loadImage("assets/images/tile_deco0.png"),
    file.loadImage("assets/images/tile_deco1.png"),
]
tiles_deco_active = 0

tlevel.setZoom RENDER_SCALE
tlevel.render

lastAnimationTime = 0

// Pull the player data from the tilemap.
playerData = tlevel.getByName("entities").getByName("Player")

math.transformTiledObject(playerData)

tlevel.scrollTo(playerData.x, playerData.y)

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

    // TODO: Found a scrollBy method!
    tlevel.scrollBy(deltaX, deltaY)
    // print "Scroll: ({scrollX}, {scrollY})".fill(display(DisplayType.TILE_BASE))

    // print "deltaTime: {0}".fill([deltaTime])
    spriteControllers.updateSprites deltaTime

    // TODO: Explain this animation loop.
    if time - lastAnimationTime >= ANIMATION_SPEED then
        // Time to animate the map.

        // This will flip-flop between the 2 deco tilesets.
        tiles_deco_active = (tiles_deco_active + 1) % tiles_deco.len
        tlevel.layers[1].display.tileSet = tiles_deco[tiles_deco_active]
    
        // Reset the animation timer.
        lastAnimationTime = time
    end if

    yield
end while

key.clear

text.clear
gfx.clear
display(DisplayType.TILE_DECO).clear
display(DisplayType.TILE_BASE).clear
display(DisplayType.SPRITE).clear
display(DisplayType.SOLID).color = color.black

print "Goodbye!"
