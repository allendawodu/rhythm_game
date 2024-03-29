local play = require "lib.play"

local songSelect = play.Scene("songSelect")

local currentSong
local source
local sortedSongs
local nowPlayingText
local mp3Player

function songSelect:load()
end

function songSelect:enter(previous, ...)
    love.graphics.setBackgroundColor(0.67, 1.0, 0.6)
    mp3Player = love.graphics.newImage("assets/mp3.png")

    local dokdo = love.graphics.newFont("assets/dokdo.ttf", 44)
    nowPlayingText = love.graphics.newText(dokdo, "Now playing...")

    sortedSongs = self:sortSongs()

    currentSong = ({...})[1] or sortedSongs[1]
    self:playSong()
end

function songSelect:update(dt)
end

function songSelect:draw()
    love.graphics.draw(mp3Player)
    love.graphics.draw(nowPlayingText, math.floor((love.graphics.getWidth() - nowPlayingText:getWidth()) / 2), 100)
end

function songSelect:keyPressed(key, scancode, isRepeat)
    if key == "right" or key == "left" then
        for index, k in ipairs(sortedSongs) do
            if k == currentSong then
                if key == "right" then
                    currentSong = sortedSongs[index % #sortedSongs + 1]
                else -- key == "left"
                    currentSong = sortedSongs[(index - 2) % #sortedSongs + 1]
                end

                self:playSong()
                break
            end
        end
    elseif key == "return" then
        source:stop()
        if currentSong == "z_metronome" then
            play.switch("calibration")
        else
            play.switch("game", currentSong)
        end
    elseif key == "1" then
        source:stop()
        play.switch("optionsMenu")
    end
end

function songSelect:exit()
    beam.clear()
end

function songSelect:playSong()
    if type(source) ~= "nil" then
        source:stop()
    end
    source = love.audio.newSource(songData[currentSong].file, "stream")
    source:setLooping(true)
    source:seek(songData[currentSong].demo, "seconds")
    source:play()
    nowPlayingText:set("Now playing " .. songData[currentSong].name)
end

function songSelect:sortSongs()
    local songs = {}
    for k in pairs(songData) do table.insert(songs, k) end
    table.sort(songs)
    return songs
end

return songSelect