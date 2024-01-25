onTalk = function(player)
    // TODO: Refer to `self.name` instead of "NPC0".
    beginConversation "NPC0", "Hey there {name}!".fill(player)
end function
