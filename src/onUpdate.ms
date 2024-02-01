events.eventLoop.onUpdate = function
    // text.color = "#FFFFFF"
    // text.row = 11
    // text.column = 1
    // print math.Point.make(player.sprite).str
    // text.row = 10
    // text.column = 1
    // print math.Point.make(player.tileX, player.tileY).str
    playlist.update

    globals.deltaTime = time - lastFrameTime
    globals.lastFrameTime = time

    if not player.isMoving and not ConversationUI.isConversationRunning then
        // print "I'm not moving!"
        deltaX = key.axis("Horizontal") * player.speed
        deltaY = key.axis("Vertical") * player.speed

        if deltaY < 0 then // moving down
            if player.tileY == TILE_LEVEL_SIZE - 1 then
                if currentLevelName == "Field" then
                    FadeController.fadeOut

                    newPosition = math.Point.make(player.sprite.x, TILE_LEVEL_SIZE_PIXELS - TILEDISPLAY_CENTER_Y - TILE_SIZE_PIXELS / 2)
                    
                    loadLevel("Town_v3")

                    player.moveTo newPosition
                    camera.reset

                    FadeController.fadeIn
                end if
            else
                player.moveBy tlevel, math.Point.unitY.negate.multiply(TILE_SIZE_PIXELS)
            end if
        else if deltaY > 0 then // moving up
            if player.tileY == 0 then
                // Load the next map.
                if currentLevelName == "Town_v3" then
                    FadeController.fadeOut

                    newPosition = math.Point.make(player.sprite.x, 0 - TILEDISPLAY_CENTER_Y + TILE_SIZE_PIXELS / 2)
                    
                    loadLevel("Field")

                    player.moveTo newPosition
                    camera.reset

                    FadeController.fadeIn
                end if
            else
                player.moveBy tlevel, math.Point.unitY.multiply(TILE_SIZE_PIXELS)
            end if
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

    for entity in tlevel.entities
        entity.update deltaTime
    end for

    // Only if player movement occurred.
    if shouldCameraMove then
        camera.update
    end if

    if time - lastAnimationTime >= ANIMATION_SPEED then
        // Time to animate the map.

        // This will flip-flop between the 2 deco tilesets.
        globals.tiles_deco_active = (tiles_deco_active + 1) % tiles_deco.len
        tlevel.layers[1].display.tileSet = tiles_deco[tiles_deco_active]
    
        // Reset the animation timer.
        globals.lastAnimationTime = time
    end if

    if ConversationUI.isConversationRunning then
        ConversationUI.draw
    end if
end function
