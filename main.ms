LEVEL_NAME = "Town_v3"

tlevel = RPGLiteTiledLevel.load("assets/maps/{0}.tmj".fill([ LEVEL_NAME ]), "assets/tilesets")
qa.assert(not tlevel.error, "Error loading tiled level: {0}".fill([ tlevel.error ]))

backgroundMusicName = tlevel.properties["Background Music"]

introPath = MUSIC_ROOT_PATH + backgroundMusicName + MUSIC_INTRO_CHUNK_NAME + MUSIC_EXT
loopPath = MUSIC_ROOT_PATH + backgroundMusicName + MUSIC_EXT

playlist = Playlist.make
playlist.push introPath
playlist.push loopPath, true

lastAnimationTime = time
isDone = false
lastFrameTime = time

baseId = tlevel.getByName("base").id
decoId = tlevel.getByName("decoration").id - baseId
collisionLayer = tlevel.getByName("collision")
// collisionId = collisionLayer.id - baseId

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

// TODO: Research EventSprite@"/sys/demo/events".
npc0 = Entity.make(tlevel, "NPC0")
npc0.script = require("scripts/{0}/{1}".fill([ LEVEL_NAME, "NPC0" ]))

npc1 = Entity.make(tlevel, "NPC1")
npc1.script = require("scripts/{0}/{1}".fill([ LEVEL_NAME, "NPC1" ]))

player = Entity.make(tlevel, "Player")

tlevel.scrollTo player.sprite.x, player.sprite.y
// NOTE: The SpriteDisplay is scrollable too!
display(DisplayType.SPRITE).scrollX = player.sprite.x - TILEDISPLAY_CENTER_X
display(DisplayType.SPRITE).scrollY = player.sprite.y - TILEDISPLAY_CENTER_Y

tlevel.entities.push player
tlevel.entities.push npc0
tlevel.entities.push npc1


//
// Bind all the event handlers.
//

ensureImport("onExit")
ensureImport("onTalk")
ensureImport("onUpdate")

events.eventLoop.run

playlist.stop
run "cleanup"
