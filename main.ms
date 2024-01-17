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

Sprites = {
    "player": [
        SpriteSheet.make("assets/DawnLike/Characters/Player0.png"),
        SpriteSheet.make("assets/DawnLike/Characters/Player1.png"),
    ],
}

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
    display(DisplayType.SPRITE).sprites.push self.sprite
end function

Entity.make = function(spritesetName, index)
    e = new Entity
    e.init spritesetName, index
    return e
end function

Entity.moveTo = function(x, y)
    self.sprite.x = x
    self.sprite.y = y
end function

// tlevel = Tiled.load("lib/minimicro-tiled/res/tilemaps/dungeon1.json", "lib/minimicro-tiled/res/tilemaps")
// tlevel = Tiled.load("assets/maps/Logo.tmj", "assets/tilesets")
tlevel = Tiled.load("assets/maps/Town_v3.tmj", "assets/tilesets")
qa.assert(not tlevel.error, "Error loading tiled level: {0}".fill([tlevel.error]))

lastAnimationTime = time
isDone = false
lastFrameTime = time

baseId = tlevel.getByName("base").id
decoId = tlevel.getByName("decoration").id - baseId
collisionId = tlevel.getByName("collision").id - baseId

// We're only rendering the base and deco tiles.
tlevel.addRenderLayer 0, DisplayType.TILE_BASE
tlevel.addRenderLayer decoId, DisplayType.TILE_DECO

// Load in all our deco tilesets so we can animate them.
tiles_deco = [
    file.loadImage("assets/images/tile_deco0.png"),
    file.loadImage("assets/images/tile_deco1.png"),
]
tiles_deco_active = 0

tlevel.setZoom RENDER_SCALE
tlevel.render

lastAnimationTime = 0

player = Entity.make("player", 26 + 15)
player.moveTo(TILEDISPLAY_CENTER_X, TILEDISPLAY_CENTER_Y) // The player will always be centered.
// Pull the player data from the tilemap.
playerData = tlevel.getByName("entities").getByName("Player")
playerData = math.transformTiledObject(playerData)
tlevel.scrollTo(playerData.x, playerData.y)


npc = Entity.make("player", 26)
// Pull the player data from the tilemap.
npcData = tlevel.getByName("entities").getByName("NPC0")
npcData = math.transformTiledObject(npcData)
npc.moveTo(npcData.x + TILEDISPLAY_CENTER_X - tlevel.x, npcData.y + TILEDISPLAY_CENTER_Y - tlevel.y)

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

    // Update everything relative to the player.
    tlevel.scrollBy(deltaX, deltaY)
    npc.moveTo(npcData.x + TILEDISPLAY_CENTER_X - tlevel.x, npcData.y + TILEDISPLAY_CENTER_Y - tlevel.y)
    // print "Scroll: ({scrollX}, {scrollY})".fill(display(DisplayType.TILE_BASE))

    // Move the npc a little spastically.
    // npcData.x += rnd
    // npcData.y += rnd

    // print "deltaTime: {0}".fill([deltaTime])
    spriteControllers.updateSprites deltaTime

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
