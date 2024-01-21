RPGLiteTiledLevel = new TiledLevel
RPGLiteTiledLevel.COLLISION_LAYER_NAME = "collision"
RPGLiteTiledLevel.entities = []

RPGLiteTiledLevel.collisionLayer = function()
    return self.getByName(self.COLLISION_LAYER_NAME)
end function

RPGLiteTiledLevel.isBlocked = function(x, y)
    collisionLayer = self.collisionLayer
    tileIndex = collisionLayer.getTileIndex(x, y)
    isBlocked = collisionLayer.data[tileIndex] != 0
    if isBlocked then return true

    for entity in self.entities
        if entity.targetTileX == x and entity.targetTileY == y then return true
    end for
    return false
end function

tlevel = RPGLiteTiledLevel.load("assets/maps/Town_v3.tmj", "assets/tilesets")
qa.assert(not tlevel.error, "Error loading tiled level: {0}".fill([tlevel.error]))

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

player = Entity.make(tlevel, "Player")

tlevel.scrollTo player.sprite.x, player.sprite.y
// NOTE: The SpriteDisplay is scrollable too!
display(DisplayType.SPRITE).scrollX = player.sprite.x - TILEDISPLAY_CENTER_X
display(DisplayType.SPRITE).scrollY = player.sprite.y - TILEDISPLAY_CENTER_Y

// TODO: Research EventSprite@"/sys/demo/events".
npc0 = Entity.make(tlevel, "NPC0")
npc1 = Entity.make(tlevel, "NPC1")

tlevel.entities.push player
tlevel.entities.push npc0
tlevel.entities.push npc1

while not isDone
// print "Is moving: " + player.isMoving
// print "Position: " + math.Point.make(player.sprite).str
// print "Target: " + player.targetPosition.str

    deltaTime = time - lastFrameTime
    lastFrameTime = time

    if key.available then
        k = key.get
        // print "k: {0} {1}".fill([k, code(k)])
        k = code(k)
        if k == Key.EXIT then isDone = true
    end if

    if not player.isMoving then
        // print "I'm not moving!"
        deltaX = key.axis("Horizontal") * player.speed
        deltaY = key.axis("Vertical") * player.speed

        if deltaY < 0 then // moving down
            player.moveBy tlevel, math.Point.unitY.negate.multiply(TILE_SIZE_PIXELS)
        else if deltaY > 0 then // moving up
            player.moveBy tlevel, math.Point.unitY.multiply(TILE_SIZE_PIXELS)
        else if deltaX < 0 then // moving left
            player.moveBy tlevel, math.Point.unitX.negate.multiply(TILE_SIZE_PIXELS)
        else if deltaX > 0 then // moving right
            player.moveBy tlevel, math.Point.unitX.multiply(TILE_SIZE_PIXELS)
        end if
    end if

    // Move the npc a little spastically.
    // npcData.x += rnd
    // npcData.y += rnd

    // print "deltaTime: {0}".fill([deltaTime])
    spriteControllers.updateSprites deltaTime
    shouldCameraMove = player.isMoving
    player.update deltaTime
    npc0.update deltaTime
    npc1.update deltaTime

    // if shouldCameraMove and not player.isMoving then
    //     isBlocked = tlevel.isBlocked(player.targetTileX, player.targetTileY)
    //     print "Position: {0}, blocked: {1}".fill([ math.Point.make(x, y).str, isBlocked ]) 
    // end if

    // Only if player movement occurred.
    if shouldCameraMove then
        // Scroll the displays to remain centered on the player.
        tlevel.scrollTo(player.sprite.x, player.sprite.y)
        display(DisplayType.SPRITE).scrollX = player.sprite.x - TILEDISPLAY_CENTER_X
        display(DisplayType.SPRITE).scrollY = player.sprite.y - TILEDISPLAY_CENTER_Y
    end if

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

run "cleanup"
