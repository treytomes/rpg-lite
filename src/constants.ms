globals.DisplayType = {
    "QA": 0, // pre-defined
    "UI": 1,
    "TEXT": 3,
    // "TILE_OVER": 4,
    "SPRITE": 4, // pre-defined
    "TILE_DECO": 5,
    "TILE_BASE": 6,
    "SOLID": 7, // pre-defined
}

globals.Key = {
    "UP": 19,
    "DOWN": 20,
    "LEFT": 17,
    "RIGHT": 18,
    "EXIT": 27,
}

globals.TILE_SIZE = 16
globals.RENDER_SCALE = 4
globals.SPRITESHEET_WIDTH = 128
globals.SPRITESHEET_HEIGHT = 240
globals.ANIMATION_SPEED = 0.300 // seconds

globals.PIXEL_WIDTH = 960
globals.PIXEL_HEIGHT = 640

globals.TILEDISPLAY_WIDTH = PIXEL_WIDTH / TILE_SIZE / RENDER_SCALE
globals.TILEDISPLAY_HEIGHT = PIXEL_HEIGHT / TILE_SIZE / RENDER_SCALE

globals.TILEDISPLAY_CENTER_X = floor(TILEDISPLAY_WIDTH / 2) * TILE_SIZE * RENDER_SCALE
globals.TILEDISPLAY_CENTER_Y = floor(TILEDISPLAY_HEIGHT / 2) * TILE_SIZE * RENDER_SCALE
