local play = {
    scenes = {},
    current = nil
}

function play.start(default, ...)
    play.current = default
    local otherScenes = {...}
    for _, scene in ipairs(otherScenes) do
        play.scenes[scene.name] = scene
    end
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
        mouseMoved = function(self, x, y, dx, dy, isTouch) end,
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
    play.current = play.scenes[to]
    play.current:enter(previous, ...)
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

function play.mouseMoved(x, y, dx, dy, isTouch)
    play.current:mouseMoved(x, y, dx, dy, isTouch)
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