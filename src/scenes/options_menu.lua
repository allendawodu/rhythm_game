local play = require "lib.play"
local box = require "lib.box"

local optionsMenu = play.Scene("optionsMenu")

local buttons

function optionsMenu:load()
end

function optionsMenu:enter(previous, ...)
    local buttonInstancer = require("src.entities.button")
    buttons = {
        vsync = buttonInstancer():load(
            box(0, 0, 512, 200),
            function()
                -- Toggle between 0 and 1
                if settings.data.vsync == 1 then
                    settings.data.vsync = 0
                    print("VSync off")
                else
                    settings.data.vsync = 1
                    print("Vsync on")
                end
                settings.save()
                print("Changes will occur on next startup.")
            end,
            nil
        ),
        calibrate = buttonInstancer():load(
            box(0, 201, 512, 200),
            function()
                play.switch("calibration")
            end,
            nil
        )
    }
end

function optionsMenu:update(dt)
end

function optionsMenu:draw()
    for _, button in pairs(buttons) do
        button:draw()
    end
end

function optionsMenu:mousePressed(x, y, mouseButton)
    for _, button in pairs(buttons) do
        button:mousePressed(x, y, mouseButton)
    end
end

function optionsMenu:exit()
    beam.clear()
end

return optionsMenu