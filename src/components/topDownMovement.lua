local vector2 = require "lib.vector2"

local function topDownMovement()
    local movement = {}

    function movement:load(mediator, body, maxSpeed, acceleration, deceleration)
        self.mediator = mediator
        self.velocity = vector2()
        self.parentBody = body
        self.maxSpeed = maxSpeed or 1
        self.acceleration = acceleration or 1
        self.deceleration = deceleration or 1

        self.mediator:receive("death", self, function ()
            self.maxSpeed = 0
        end)

        return self
    end

    function movement:update(direction, dt)
        if direction:getMagnitude() == 0 then
            -- Slow down to a stop
            self.velocity = self.velocity:lerp(vector2(), self.deceleration * dt)
        else
            -- Speed up to max speed
            self.velocity = self.velocity:lerp(direction:scale(self.maxSpeed), self.acceleration * dt)
        end

        self.parentBody.x = self.parentBody.x + self.velocity.x
        self.parentBody.y = self.parentBody.y + self.velocity.y
    end

    return movement
end

return topDownMovement