flux = require "lib.flux"
beam = require "lib.beam"

local play = require "lib.play"

function love.load()
    local game = require "src.scenes.game"

    play.start(game)
end

function love.update(dt)
    flux.update(dt)
    play.update(dt)
end

function love.draw()
    play.draw()
end

function love.keypressed(key, scancode, isRepeat)
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