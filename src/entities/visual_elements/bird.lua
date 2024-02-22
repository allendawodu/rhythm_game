local box = require "lib.box"
local dance = require "lib.dance"

return function()
    local bird = {}

    function bird:load()
        self.image = love.graphics.newImage("assets/kiwi/bird/idle/1.png")
        self.body = box(100, 200, self.image:getWidth(), self.image:getHeight())
        self.animations = {
            idle = dance():load("assets/kiwi/bird/idle", 1, true),
            peck = dance():load("assets/kiwi/bird/peck", 1, false),
        }
        self.currentAnimation = "idle"

        beam.receive("onBeat", self, function(beat)
            self.animations[self.currentAnimation]:update()
        end)

        return self
    end

    function bird:update()
        if self.animations.peck.isDone then
            self.currentAnimation = "idle"
            self.animations.peck:reset()
        end
    end

    function bird:draw()
        love.graphics.draw(self.animations[self.currentAnimation]:getCurrentFrame(), self.body.x, self.body.y, 0, 1/4, 1/4)
    end

    function bird:keyPressed(key)
        if key == "left" or key == "right" then
            self.animations.peck:reset()
            self.currentAnimation = "peck"
        end
    end

    return bird
end