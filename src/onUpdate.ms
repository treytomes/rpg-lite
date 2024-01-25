events.eventLoop.onUpdate = function
    globals.deltaTime = time - lastFrameTime
    globals.lastFrameTime = time

    if not player.isMoving and not ConversationUI.isConversationRunning then
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

    for entity in tlevel.entities
        entity.update deltaTime
    end for

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
        globals.tiles_deco_active = (tiles_deco_active + 1) % tiles_deco.len
        tlevel.layers[1].display.tileSet = tiles_deco[tiles_deco_active]
    
        // Reset the animation timer.
        globals.lastAnimationTime = time
    end if

    if ConversationUI.isConversationRunning then
        ConversationUI.draw
    end if
end function
