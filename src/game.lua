local play = require "lib.play"

local game = play.Scene("game")

local iConductor = require "src.entities.conductor"
local conductor

function game:load()
end

function game:enter(previous, ...)
    print("start")
    -- conductor = iConductor():load(love.audio.newSource("dev/madtek.ogg", "stream"), 147, 0.995)
    conductor = iConductor():load(love.audio.newSource("dev/carnation.ogg", "stream"), 118, 2.5585)
end

function game:update(dt)
    conductor:update()
end

function game:draw()
end

function game:exit()
end

return game