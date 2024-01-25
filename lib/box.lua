local vector2 = require "lib.vector2"

local boxMetatable = {
    __call = function(self)
        return self.x, self.y, self.width, self.height
    end,
    __tostring = function(self)
        return "Box(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ", " .. tostring(self.width) .. ", " .. tostring(self.height) ")"
    end
}

local function rect(x, y, width, height)
    local box =  {
        x = x or 0,
        y = y or 0,
        width = width or 0,
        height = height or 0,
        getPosition = function (self)
            return vector2(self.x, self.y)
        end,
        getCenter = function (self)
            return vector2(self.x + self.width / 2, self.y + self.height / 2)
        end,
        getEdges = function (self)
            return {
                ["top"] = self.y,
                ["right"] = self.x + self.width,
                ["bottom"] = self.y + self.height,
                ["left"] = self.x
            }
        end,
        getCorners = function (self)
            return {
                ["topLeft"] = vector2(self.x, self.y),
                ["topRight"] = vector2(self.x + self.width, self.y),
                ["bottomRight"] = vector2(self.x + self.width, self.y + self.height),
                ["bottomLeft"] = vector2(self.x, self.y + self.height)
            }
        end,
        isColliding = function (self, with)
            return self.x < with.x + with.width
                and with.x < self.x + self.width
                and self.y < with.y + with.height
                and with.y < self.y + self.height
        end,
        isMouseColliding = function (self, mouseX, mouseY)
            return mouseX < self:getEdges().right
                and mouseX > self:getEdges().left
                and mouseY < self:getEdges().bottom
                and mouseY > self:getEdges().top
        end,
        getMouseOffset = function (self, mouseX, mouseY)
            return self:getCorners().topRight - vector2(mouseX, mouseY)
        end,
    }

    setmetatable(box, boxMetatable)
    return box
end

return rect