isOpen = false

CLOSED = "FRAME0"
OPEN = "FRAME1"

onInit = function
    outer.playAnimation CLOSED
end function

// This will be executed when the player talks to this NPC.
onTalk = function(player)
    outer.isOpen = not isOpen
    if outer.isOpen then
        outer.playAnimation OPEN
    else
        outer.playAnimation CLOSED
    end if
end function
