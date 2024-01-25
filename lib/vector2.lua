local function vector2(x, y)
    local vector2Metatable = {
        __add = function (a, b)
            return vector2(a.x + b.x, a.y + b.y)
        end,
        __sub = function (a, b)
            return vector2(a.x - b.x, a.y - b.y)
        end,
        __call = function (self)
            return self.x, self.y
        end,
        __tostring = function (self)
            return "(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
        end
    }

    local vector = {
        x = x or 0,
        y = y or 0,
        getMagnitude = function (self)
            return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
        end,
        getDistance = function (self, v)
            return math.sqrt(math.pow(self.x - v.x, 2) + math.pow(self.y - v.y, 2))
        end,
        dot = function (self, v)
            return self.x * v.x + self.y * v.y
        end,
        scale = function (self, by)
            return vector2(self.x * by, self.y * by)
        end,
        normalize = function (self)
            local magnitude = self:getMagnitude()
            if magnitude ~= 0 then
                self.x = self.x / magnitude
                self.y = self.y / magnitude
            end
            return self
        end,
        lookAt = function (self, what)
            local resultant = what - self
            return math.atan2(resultant.y, resultant.x)
        end,
        lerp = function (self, to, by)
            return self:scale(1 - by) + to:scale(by)
        end,
        random = function ()
            local sign1 = 1
            local sign2 = 1
            if love.math.random() > 0.5 then
                sign1 = -1
            end
            if love.math.random() > 0.5 then
                sign2 = -1
            end
            return vector2(sign1 * love.math.random(), sign2 * love.math.random())
        end
    }

    setmetatable(vector, vector2Metatable)
    return vector
end

return vector2