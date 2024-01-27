PlaylistEntry = {}

PlaylistEntry.init = function(path, loop = false)
    self.path = path
    self.loop = loop
    self.sound = file.loadSound(path)
    self.sound.loop = false
    self.duration = self.sound.duration
    return self
end function

PlaylistEntry.make = function(path, loop = false)
    return (new PlaylistEntry).init(path, loop)
end function

PlaylistEntry.play = function
    self.sound.play Settings.Sound["Music Volume"]
end function

PlaylistEntry.stop = function
    self.sound.stop
end function

return PlaylistEntry
