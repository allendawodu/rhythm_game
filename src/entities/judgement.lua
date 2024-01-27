local box = require "lib.box"

return function()
    local hit = {}

    function hit:load(timings)
        self.body = box(0, 700, love.graphics.getWidth(), 2)
        self.timings = timings or {}
        self.currentBeat = 1

        beam:receive("beat", self, function(beat)
            if self.timings[self.currentBeat] == beat then
                -- print("hit!", beat)
                self.currentBeat = self.currentBeat + 1
            end
        end)

        return self
    end

    function hit:draw()
        love.graphics.rectangle("fill", self.body())
    end

    return hit
end