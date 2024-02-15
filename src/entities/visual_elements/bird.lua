local box = require "lib.box"

return function()
    local bird = {}

    function bird:load()
        self.image = love.graphics.newImage("assets/kiwi/bird/idle/1.png")
        self.body = box(100, 200, self.image:getWidth(), self.image:getHeight())
        self.animation = require("lib.dance")():load("assets/kiwi/bird/idle", 1, true)

        beam.receive("onJudgement", self, function(judgement)
            if judgement == "hit" then
                print("CHOMP.")
            else
                print("MISS.")
            end
        end)

        beam.receive("onBeat", self, function(beat)
            self.animation:update()
        end)

        return self
    end

    function bird:draw()
        love.graphics.draw(self.animation:getCurrentFrame(), self.body.x, self.body.y, 0, 1/4, 1/4)
    end

    return bird
end