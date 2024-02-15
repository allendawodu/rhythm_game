local play = require "lib.play"

local mainMenu = play.Scene("mainMenu")

local dir
local backgroundArt
local bgm

function mainMenu:load()
end

function mainMenu:enter(previous, ...)
    dir = "assets/stomp/"

    backgroundArt = love.graphics.newImage(lume.randomchoice({dir .. "day.png", dir .. "night.png"}))

    bgm = love.audio.newSource(lume.randomchoice({dir .. "bgm_1.ogg", dir .. "bgm_2.ogg"}), "stream")
    bgm:setLooping(true)
    bgm:play()
end

function mainMenu:update(dt)
end

function mainMenu:draw()
    love.graphics.draw(backgroundArt, 0, -100, 0, 3/5, 3/5)
end

function mainMenu:keyPressed(key, scancode, isRepeat)
    if key == "return" then
        play.switch("songSelect")
    end
end

function mainMenu:exit()
    bgm:stop()
    beam.clear()
end

return mainMenu