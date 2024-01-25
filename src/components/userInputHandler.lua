local vector2 = require "lib.vector2"

local function userInputHandler()
    local handler = {}

    function handler:load()
        self.direction = vector2()

        return self
    end

    function handler:update()
        self.direction = vector2()

        if love.keyboard.isScancodeDown("s") then
            self.direction.y = self.direction.y + 1
        end
        if love.keyboard.isScancodeDown("w") then
            self.direction.y = self.direction.y - 1
        end
        if love.keyboard.isScancodeDown("d") then
            self.direction.x = self.direction.x + 1
        end
        if love.keyboard.isScancodeDown("a") then
            self.direction.x = self.direction.x - 1
        end

        return self.direction:normalize()
    end

    return handler
end

return userInputHandler

--[[
    TODO
        Support controller input
        Handle keybindings
]]