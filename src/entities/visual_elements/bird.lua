local box = require "lib.box"
local dance = require "lib.dance"

return function()
    local bird = {}

    function bird:load()
        self.image = love.graphics.newImage("assets/kiwi/bird/idle/1.png")
        self.body = box(100, 200, self.image:getWidth(), self.image:getHeight())
        self.animations = {
            idle = dance():load("assets/kiwi/bird/idle", 2, true),
        }
        self.currentAnimation = "idle"

        beam.receive("onJudgement", self, function(judgement)
            if judgement == "hit" then
                print("CHOMP.")
            else
                print("MISS.")
            end
        end)

        beam.receive("onBeat", self, function(beat)
            self.animations[self.currentAnimation]:update()
        end)

        return self
    end

    function bird:draw()
        love.graphics.draw(self.animations[self.currentAnimation]:getCurrentFrame(), self.body.x, self.body.y, 0, 1/4, 1/4)
    end

    return bird
end