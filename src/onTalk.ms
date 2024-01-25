onTalk = function
    if ConversationUI.isConversationRunning then
        ConversationUI.manageConversation
        return
    end if

    // Otherwise try talking to the nearest entity.

    talkingToEntity = tlevel.closestEntity(player)
    if talkingToEntity == null then return

    distance = talkingToEntity.targetPosition.distance(player.targetPosition)
    isEntityTooFar = distance > TILE_SIZE_PIXELS
    if isEntityTooFar then return

    isEntityInteractive = talkingToEntity.script != null
    if not isEntityInteractive then return
    
    isEntityConversational = talkingToEntity.script.indexes.indexOf("onTalk") != null
    if not isEntityConversational then return

    talkingToEntity.script.onTalk player
end function

for k in Settings.Input.Talk
    events.eventLoop.onKeyDown[k] = @onTalk
end for
