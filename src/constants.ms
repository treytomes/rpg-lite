globals.DisplayType = {
    "QA": 0, // pre-defined
    "UI": 1,
    "UI_PIXEL": 2,
    "TEXT": 3,
    // "TILE_OVER": 4,
    "SPRITE": 4, // pre-defined
    "TILE_DECO": 5,
    "TILE_BASE": 6,
    "SOLID": 7, // pre-defined
}

// globals.Key = {
//     "UP": 19,
//     "DOWN": 20,
//     "LEFT": 17,
//     "RIGHT": 18,
//     "EXIT": 27,
// }

globals.Settings = {
    "Sound": {
        "Music Volume": 0.5,
    },
    "Input": {
        "Exit": [ "escape" ],
        "Talk": [ "enter", "return", "space" ],
    },
}

globals.PIXEL_DISPLAY_WIDTH = 960
globals.PIXEL_DISPLAY_HEIGHT = 640

globals.TILE_SIZE = 16
globals.RENDER_SCALE = 4
globals.TILE_SIZE_PIXELS = TILE_SIZE * RENDER_SCALE
globals.TILE_LEVEL_SIZE = 32
globals.TILE_LEVEL_SIZE_PIXELS = TILE_LEVEL_SIZE * TILE_SIZE_PIXELS

globals.ANIMATION_SPEED = 0.300 // seconds

globals.TILEDISPLAY_WIDTH = PIXEL_DISPLAY_WIDTH / TILE_SIZE / RENDER_SCALE
globals.TILEDISPLAY_HEIGHT = PIXEL_DISPLAY_HEIGHT / TILE_SIZE / RENDER_SCALE

globals.TILEDISPLAY_CENTER_X = floor(TILEDISPLAY_WIDTH / 2) * TILE_SIZE * RENDER_SCALE
globals.TILEDISPLAY_CENTER_Y = floor(TILEDISPLAY_HEIGHT / 2) * TILE_SIZE * RENDER_SCALE

//
// GUI Constants
//

globals.TEXT_RENDER_SPEED = 0.05
globals.WINDOW_WIDTH = PIXEL_DISPLAY_WIDTH - 5 * 2
globals.WINDOW_HEIGHT = PIXEL_DISPLAY_HEIGHT / 4

//
// Music Constants
//

globals.MUSIC_ROOT_PATH = "assets/music/Cute Studio/"
globals.MUSIC_EXT = ".ogg"
globals.MUSIC_INTRO_CHUNK_NAME = "_intro"
