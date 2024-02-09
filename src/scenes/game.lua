local play = require "lib.play"

local game = play.Scene("game")

local song
local track
local conductor
local judgement
local songData

function game:load()
    songData = {
        milk = {
            name = "MilK",
            artist = "モリモリあつし",
            file = "dev/milk.ogg",
            bpm = 150,
            offset = 1.6,
            -- timings = 
            timings = {
                [1] = {1, 5, 9, 33, 37, 41, 65, 69, 73, 97, 101, 105, 129, 133, 137, 141, 145, 149, 153, 157, 158, 159, 160},
                [2] = {1, 3, 7, 9}
            }
        },
        carnation = {
            name = "Carnation",
            artist = "Himmel",
            file = "dev/carnation.ogg",
            bpm = 118,
            offset = 2.5585 - 0.5085,
            timings = {
                [1] = {2, 3, 4, 5, 9, 11, 13, 15, 16, 17, 19, 21, 23, 25, 27, 29, 31, 33, 700},
                [2] = {}
            }
        },
        yggdrasil = {
            name = "Yggdrasil",
            artist = "MYTK",
            file = "dev/yggdrasil.ogg",
            bpm = 180,
            offset = 0.908,
            -- FIXME
            -- timings = 
            timings = {
                [1] = {2, 17, 33, 49, 65, 81, 97, 113, 137, 145, 161, 163, 165, 167, 169, 171, 173, 175, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 197, 205, 209, 213, 217, 221, 229, 241, 245, 249, 253, 257, 261, 263, 265, 269, 273, 277, 281, 285, 289, 293, 305, 309, 313, 317, 385, 389, 397, 405, 413, 421, 429, 437, 445, 449, 450, 451, 452, 457, 458, 459, 460, 465, 466, 467, 468, 473, 474, 475, 476, 478, 471, 473, 475, 477, 479, 481, 489, 497, 517, 529, 533, 537, 541, 549, 553, 555, 557, 559, 561, 565, 569, 573, 641, 661, 677, 689, 721, 737, 753, 769},
                [2] = {17}
            }
        }
    }
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