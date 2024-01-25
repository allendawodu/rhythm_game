local play = {
    scenes = {},
    current = nil
}

function play.start(default)
    play.current = default
    for _, scene in pairs(play.scenes) do
        scene:load()
    end
    play.current:enter(default)
end

function play.Scene(name)
    local scene = {
        name = name,
        entities = {},
        load = function(self) end,
        enter = function(self, previous, ...) end,
        update = function(self, dt) end,
        draw = function(self) end,
        keyPressed = function(self, key, scancode, isRepeat) end,
        keyReleased = function(self, key, scancode) end,
        mousePressed = function(self, x, y, button, isTouch, presses) end,
        mouseReleased = function(self, x, y, button, isTouch, presses) end,
        exit = function(self) end,
    }

    play.scenes[name] = scene

    return scene
end

function play.update(dt)
    play.current:update(dt)
end

function play.switch(to, ...)
    local previous = play.current
    play.current:exit()
    play.current = to
    to:enter(previous, ...)
end

function play.draw()
    play.current:draw()
end

function play.keyPressed(key, scancode, isRepeat)
    play.current:keyPressed(key, scancode, isRepeat)
end

function play.keyReleased(key, scancode)
    play.current:keyReleased(key, scancode)
end

function play.mousePressed(x, y, button, isTouch, presses)
    play.current:mousePressed(x, y, button, isTouch, presses)
end

function play.mouseReleased(x, y, button, isTouch, presses)
    play.current:mouseReleased(x, y, button, isTouch, presses)
end

return play

-- TODO
-- Add more callback functions

--[[
    Example Usage
        local play = require "lib.play"

        local game = play.Scene("game")

        function game:load()
        end

        function game:enter(previous, ...)
        end

        function game:update(dt)
        end

        function game:draw()
        end

        function game:exit()
        end

        return game
]]