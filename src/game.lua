local play = require "lib.play"
local beam = require "lib.beam"

local game = play.Scene("game")

local mediator
local iConductor = require "src.entities.conductor"
local conductor
local iHit = require "src.entities.hit"
local hit

function game:load()
end

function game:enter(previous, ...)
    mediator = beam()
    -- conductor = iConductor():load(mediator, love.audio.newSource("dev/carnation.ogg", "stream"), 118, 2.5585)
    -- hit = iHit():load(mediator, {1, 2, 3, 4, 8, 10, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24})
    conductor = iConductor():load(mediator, love.audio.newSource("dev/milk.ogg", "stream"), 150, 1.6)
    hit = iHit():load(mediator, {1, 5, 9, 33, 37, 41, 65, 69, 73, 97, 101, 105, 129, 133, 137, 141, 145, 149, 153, 157, 158, 159, 160})
end

function game:update(dt)
    conductor:update()
end

function game:draw()
end

function game:exit()
end

return game