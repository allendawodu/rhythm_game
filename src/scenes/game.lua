local play = require "lib.play"

local game = play.Scene("game")

local song
local track
local conductor
local judgement
local bird

function game:load()
end

function game:enter(previous, ...)
    love.graphics.setBackgroundColor(0.67, 1.0, 0.6)

    song = ({...})[1]
    local currentSongData = songData[song]

    track = require("src.entities.track")():load(currentSongData)
    judgement = require("src.entities.judgement")():load(currentSongData)
    bird = require("src.entities.visual_elements.bird")():load()
    conductor = require("src.entities.conductor")():load(currentSongData)
    score = require("src.entities.score")():load(currentSongData)

end

function game:update(dt)
    conductor:update()
    track:update()
    bird:update()
end

function game:draw()
    track:draw()
    judgement:draw()
    bird:draw()
end

function game:keyPressed(key, scancode, isRepeat)
    judgement:keyPressed(key)
    bird:keyPressed(key)

    if key == "escape" then
        conductor.song:stop()
        play.switch("songSelect", song)
    end
end

function game:exit()
    beam.clear()
end

return game