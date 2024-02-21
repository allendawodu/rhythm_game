local play = require "lib.play"

local calibration = play.Scene("calibration")

local track
local conductor
local judgement

function calibration:load()
end

function calibration:enter(previous, ...)
    track = require("src.entities.track")():load(songData.z_metronome)
    judgement = require("src.entities.judgement")():load(songData.z_metronome)
    conductor = require("src.entities.conductor")():load(songData.z_metronome)

    love.keyboard.setKeyRepeat(true)
end

function calibration:update(dt)
    conductor:update()
    track:update()
end

function calibration:draw()
    track:draw()
    judgement:draw()
end

function calibration:keyPressed(key, scancode, isRepeat)
    if key == "[" then
        judgement.body.y = judgement.body.y - 1
    end

    if key == "]" then
        judgement.body.y = judgement.body.y + 1
    end

    if key == "r" then
        judgement.body.y = 700

        settings.data.userOffset = 0.0
        settings.save()

        play.switch("calibration")
    end

    if key == "space" then
        judgement.body.y = 700
    end

    if key == "return" then
        local positionalOffset = judgement.body.y - 700
        local temporalOffset = positionalOffset / 44

        settings.data.userOffset = settings.data.userOffset + temporalOffset
        settings.save()

        print("User Offset: " .. settings.data.userOffset)

        play.switch("songSelect")
    end

    if key == "escape" then
        play.switch("songSelect")
    end
end

function calibration:exit()
    love.keyboard.setKeyRepeat(false)
    conductor:stop()
    beam.clear()
end

return calibration