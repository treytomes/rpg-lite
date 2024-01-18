// All of the miscellaneous setup things.
// We just need them to run and stay out of the way.

//
// Import all the things!
//

import "listUtil"
import "qa"
import "spriteControllers"
import "stringUtil"

// Note how system-defined symbols can be extended.
env.addImportPath = function(path)
    // `self` == `env`
    if not self.importPaths.contains(path) then
        self.importPaths.push path
    end if
end function

env.addImportPath "./lib/minimicro-tiled"
env.addImportPath "./src"

import "lib/tiled/tiled"
globals.Tiled = locals["lib/tiled/tiled"]

import "coreUtil"
import "constants"
import "math"
globals.SpriteSheet = require("SpriteSheet")

globals.Sprites = require("Sprites")
globals.Entity = require("Entity")

//
// Setup our displays.
//

text.clear
gfx.clear

display(DisplayType.UI).mode = displayMode.off

(new TileDisplay).install DisplayType.TILE_DECO
(new TileDisplay).install DisplayType.TILE_BASE

display(DisplayType.SOLID).mode = displayMode.solidColor
display(DisplayType.SOLID).color = color.blue

display(DisplayType.SPRITE).mode = displayMode.sprite
disp = display(DisplayType.SPRITE)
disp.clear

run "main"