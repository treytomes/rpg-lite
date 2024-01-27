// All of the miscellaneous setup things.
// We just need them to run and stay out of the way.

//
// Import all the things!
//

import "importUtil"
ensureImport "bmfFonts"
ensureImport "events"
ensureImport "gui"
ensureImport "listUtil"
ensureImport "mapUtil"
ensureImport "mathUtil"
ensureImport "qa"
ensureImport "spriteControllers"
ensureImport "stringUtil"

// Note how system-defined symbols can be extended.
env.addImportPath = function(path)
    // `self` == `env`
    if not self.importPaths.contains(path) then
        self.importPaths.push path
    end if
end function

env.addImportPath "./lib/minimicro-tiled"
env.addImportPath "./src"

import "lib/tiled/TiledLevel"
globals.TiledLevel = locals["lib/tiled/TiledLevel"]

import "coreUtil"
import "constants"
import "math"
globals.SpriteSheet = require("SpriteSheet")

globals.Sprites = require("Sprites")
globals.Entity = require("Entity")
globals.RPGLiteTiledLevel = require("RPGLiteTiledLevel")

globals.PlaylistEntry = require("PlaylistEntry")
globals.Playlist = require("Playlist")

//
// Setup our displays.
//

setupGUIDisplays = function
	gui.backgroundDisp = display(DisplayType.SOLID)

	display(DisplayType.UI).mode = displayMode.sprite
	gui.spriteDisp = display(DisplayType.UI)
	gui.spriteDisp.clear
	events.spriteDisplay = gui.spriteDisp
	
	display(DisplayType.TEXT).mode = displayMode.text
	gui.text = display(DisplayType.TEXT)
	gui.text.color = color.blue

	display(DisplayType.UI_PIXEL).mode = displayMode.pixel
	gui.menuDisp = display(DisplayType.UI_PIXEL)
	gui.menuDisp.clear color.clear, 960+16, 640+16
	gui.menuDisp.scrollX = 8
    gui.menuDisp.scrollY = 7

    gui.scratchDisp = new PixelDisplay
    gui.scratchDisp.clear color.red
end function

text.clear
gfx.clear

display(DisplayType.UI).mode = displayMode.off

(new TileDisplay).install DisplayType.TILE_DECO
(new TileDisplay).install DisplayType.TILE_BASE

display(DisplayType.SOLID).mode = displayMode.solidColor
display(DisplayType.SOLID).color = "#7EBDC5FF"

display(DisplayType.SPRITE).mode = displayMode.sprite
disp = display(DisplayType.SPRITE)
disp.clear

setupGUIDisplays

Sounds = {
    "click": (new Sound).init(0.005, noteFreq(60), [1, 0.3, 0], Sound.sineWave),
}

text.color = color.red

ConversationUI = require("ConversationUI")

run "main"
