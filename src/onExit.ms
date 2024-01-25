onExit = function
    self.stop
end function

for k in Settings.Input.Exit
    events.eventLoop.onKeyDown[k] = @onExit
end for
