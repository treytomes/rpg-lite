Playlist = {}

Playlist.init = function
    self.entries = []
    self.currentIndex = 0
    self.nextMusicTime = 0
    self.iteration = 0
    return self
end function

Playlist.make = function
    return (new Playlist).init
end function

Playlist.push = function(path, loop = false)
    self.entries.push PlaylistEntry.make(path, loop)
end function

Playlist.currentEntry = function
    return self.entries[self.currentIndex]
end function

Playlist.isPlaying = function
    return self.currentIndex < self.entries.len or time <= self.nextMusicTime
end function

Playlist.isTimeForNextSong = function
    return time > self.nextMusicTime
end function

Playlist.remainingTimeForCurrentSong = function
    return self.nextMusicTime - time
end function

Playlist.update = function
    if not self.isTimeForNextSong or not self.isPlaying then return

    self.iteration += 1

    self.currentEntry.play
    self.nextMusicTime = time + self.currentEntry.duration
    if not self.currentEntry.loop then self.currentIndex += 1
end function

Playlist.stop = function
    self.currentEntry.stop
end function

return Playlist
