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

    // TODO: Clear the playlist on entry to a new map, but only if the backgroundMusicName has changed.
    introPath = MUSIC_ROOT_PATH + backgroundMusicName + MUSIC_INTRO_CHUNK_NAME + MUSIC_EXT
    if file.exists(introPath) then playlist.push introPath
    loopPath = MUSIC_ROOT_PATH + backgroundMusicName + MUSIC_EXT
    if file.exists(loopPath) then playlist.push loopPath, true

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

        // TODO: Removing an entity should also remove it's sprite.
        tlevel.entities = []

        // TODO: Research EventSprite@"/sys/demo/events".

        for obj in tlevel.getByName("entities").objects
            if obj.type == "Player" then continue

            newEntity = Entity.make(tlevel, obj.name)
            if newEntity.type == "NPC" then
                newEntity.script = require("scripts/{0}/{1}".fill([ currentLevelName, newEntity.name ]))
            else if newEntity.type == "Chest" then
                newEntity.script = require("scripts/Chest")
            else if newEntity.type == "Door" then
                newEntity.script = require("scripts/Door")
            end if
            newEntity.script.entity = newEntity

            newEntity.script.say = function (text)
                ConversationUI.beginConversation self.entity.name, text
            end function
            newEntity.script.playAnimation = function (animationName)
                self.entity.sprite.play self.entity.animations[animationName]
            end function
            newEntity.script.allowPassage = function (value)
                self.entity.blocksMovement = not value
            end function

            tlevel.entities.push newEntity
            if newEntity.script.hasIndex("onInit") then newEntity.script.onInit
        end for

        if globals.player == null then
            globals.player = Entity.make(tlevel, "Player")
        else
            display(DisplayType.SPRITE).sprites.push player.sprite
        end if
        tlevel.entities.push player
    else
        display(DisplayType.SPRITE).clear

        // TODO: Pushing an entity should also push its sprite.
        tlevel.entities = []

        if globals.player == null then
            globals.player = Entity.make(tlevel, "Player")
        else
            display(DisplayType.SPRITE).sprites.push player.sprite
        end if
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
