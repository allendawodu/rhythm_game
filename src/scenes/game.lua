local play = require "lib.play"

local game = play.Scene("game")

local song
local track
local conductor
local judgement

function game:load()
end

function game:enter(previous, ...)
    love.graphics.setBackgroundColor(0.67, 1.0, 0.6)

    song = "carnation"
    local currentSongData = songData[song]

    track = require("src.entities.track")():load(currentSongData)
    judgement = require("src.entities.judgement")():load(currentSongData)
    conductor = require("src.entities.conductor")():load(currentSongData)
    score = require("src.entities.score")():load(currentSongData)
end

function game:update(dt)
    conductor:update()
    track:update()
end

function game:draw()
    track:draw()
    judgement:draw()
end

function game:keyPressed(key, scancode, isRepeat)
    judgement:keyPressed(key)
end

function game:exit()
    beam.clear()
end

return game