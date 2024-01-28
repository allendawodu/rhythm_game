beam = require "lib.beam"
flux = require "lib.flux"

local play = require "lib.play"
local police

local game = play.Scene("game")

local song
local track
local conductor
local judgement

local songData = {
    milk = {
        name = "MilK",
        artist = "モリモリあつし",
        file = "dev/milk.ogg",
        bpm = 150,
        offset = 1.6,
        timings = {1, 5, 9, 33, 37, 41, 65, 69, 73, 97, 101, 105, 129, 133, 137, 141, 145, 149, 153, 157, 158, 159, 160}
    },
    carnation = {
        name = "Carnation",
        artist = "Himmel",
        file = "dev/carnation.ogg",
        bpm = 118,
        offset = 2.5585,
        timings = {1, 2, 3, 4, 8, 10, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
    },
    yggdrasil = {
        name = "Yggdrasil",
        artist = "MYTK",
        file = "dev/yggdrasil.ogg",
        bpm = 180,
        offset = 0.908,
        timings = {}
    }
}

function game:load()
end

function game:enter(previous, ...)
    song = "milk"

    track = require("src.entities.track")():load(songData[song].timings)
    judgement = require("src.entities.judgement")():load()
    conductor = require("src.entities.conductor")():load(
        love.audio.newSource(songData[song].file, "stream"),
        songData[song].bpm,
        songData[song].offset
    )
end

function game:update(dt)
    flux.update(dt)
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
end

return game