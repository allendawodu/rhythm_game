flux = require "lib.flux"
beam = require "lib.beam"
once = require "lib.once"
lume = require "lib.lume"
settings = require "src.entities.settings"

local play = require "lib.play"

function love.load()
    settings.load()

    songData = require "src.entities.song_data"

    local game = require "src.scenes.game"
    -- local calibration = require "src.scenes.calibration"
    local songSelect = require "src.scenes.song_select"
    local mainMenu = require "src.scenes.main_menu"

    play.start(mainMenu, songSelect, game, calibration)
    -- play.start(songSelect)
end

function love.update(dt)
    flux.update(dt)
    play.update(dt)
end

function love.draw()
    play.draw()
end

function love.keypressed(key, scancode, isRepeat)
    if key == "f5" then
        settings.reset()
        print("Settings have been reset.")
        love.event.quit("restart")
    end

    play.keyPressed(key, scancode, isRepeat)
end

function love.mousepressed(x, y, button, isTouch, presses)
    play.mousePressed(x, y, button, isTouch, presses)
end

--------------------------------------------------

if arg[2] == "debug" then
    require("lldebugger").start()
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end