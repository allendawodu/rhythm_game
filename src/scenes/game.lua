beam = require "lib.beam"
flux = require "lib.flux"

local play = require "lib.play"

local game = play.Scene("game")

local song
local track
local conductor
local judgement
local police

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
        -- FIXME
        timings = {1, 17, 33, 49, 65, 81, 97, 113, 137, 145, 161, 163, 165, 167, 169, 171, 173, 175, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 197, 205, 209, 213, 217, 221, 229, 241, 245, 249, 253, 257, 261, 263, 265, 269, 273, 277, 281, 285, 289, 293, 305, 309, 313, 317, 385, 389, 397, 405, 413, 421, 429, 437, 445, 449, 450, 451, 452, 457, 458, 459, 460, 465, 466, 467, 468, 473, 474, 475, 476, 478, 471, 473, 475, 477, 479, 481, 489, 497, 517, 529, 533, 537, 541, 549, 553, 555, 557, 559, 561, 565, 569, 573, 641, 661, 677, 689, 721, 737, 753, 769}
    }
}

function game:load()
end

function game:enter(previous, ...)
    song = "yggdrasil"

    track = require("src.entities.track")():load(songData[song].timings)
    judgement = require("src.entities.judgement")():load(songData[song].timings)
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