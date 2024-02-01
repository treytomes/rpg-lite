tlevel = null
currentLevelName = ""
playlist = Playlist.make
lastAnimationTime = time
isDone = false
lastFrameTime = time
lastAnimationTime = 0
player = null
// Load in all our deco tilesets so we can animate them.
tiles_deco = [
    file.loadImage("assets/images/tile_deco0.png"),
    file.loadImage("assets/images/tile_deco1.png"),
]
tiles_deco_active = 0

loadLevel = function(levelName)
    globals.currentLevelName = levelName

    globals.tlevel = RPGLiteTiledLevel.load("assets/maps/{0}.tmj".fill([ currentLevelName ]), "assets/tilesets")
    qa.assert(not tlevel.error, "Error loading tiled level: {0}".fill([ tlevel.error ]))

    globals.backgroundMusicName = tlevel.properties["Background Music"]

    introPath = MUSIC_ROOT_PATH + backgroundMusicName + MUSIC_INTRO_CHUNK_NAME + MUSIC_EXT
    loopPath = MUSIC_ROOT_PATH + backgroundMusicName + MUSIC_EXT

    // TODO: Clear the playlist on entry to a new map, but only if the backgroundMusicName has changed.
    playlist.push introPath
    playlist.push loopPath, true

    globals.baseId = tlevel.getByName("base").id
    globals.decoId = tlevel.getByName("decoration").id - baseId
    globals.collisionLayer = tlevel.getByName("collision")
    // globals.collisionId = collisionLayer.id - baseId

    // We're only rendering the base and deco tiles.
    tlevel.addRenderLayer 0, DisplayType.TILE_BASE
    tlevel.addRenderLayer decoId, DisplayType.TILE_DECO

    tlevel.setZoom RENDER_SCALE
    tlevel.render

    // TODO: Clear out the entities, but keep the player.
    // TODO: Reload entities from the map definition.
    if levelName == "Town_v3" then
        display(DisplayType.SPRITE).clear

        // TODO: Research EventSprite@"/sys/demo/events".
        globals.npc0 = Entity.make(tlevel, "NPC0")
        npc0.script = require("scripts/{0}/{1}".fill([ currentLevelName, "NPC0" ]))

        globals.npc1 = Entity.make(tlevel, "NPC1")
        npc1.script = require("scripts/{0}/{1}".fill([ currentLevelName, "NPC1" ]))

        if globals.player == null then
            globals.player = Entity.make(tlevel, "Player")
        else
            display(DisplayType.SPRITE).sprites.push player.sprite
        end if

        // TODO: Removing an entity should also remove it's sprite.
        tlevel.entities = []
        tlevel.entities.push npc0
        tlevel.entities.push npc1
        tlevel.entities.push player
    else
        display(DisplayType.SPRITE).clear

        if globals.player == null then
            globals.player = Entity.make(tlevel, "Player")
        else
            display(DisplayType.SPRITE).sprites.push player.sprite
        end if

        // TODO: Pushing an entity should also push its sprite.
        tlevel.entities = []
        tlevel.entities.push player
    end if

    globals.camera = Camera.make(player)
    camera.reset
end function

FadeController.fadeOut 0
loadLevel "Town_v3"
FadeController.fadeIn

//
// Bind all the event handlers.
//

ensureImport "onExit"
ensureImport "onTalk"
ensureImport "onUpdate"

events.eventLoop.run

playlist.stop
run "cleanup"
