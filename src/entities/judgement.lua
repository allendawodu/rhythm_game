local box = require "lib.box"
local inspect = require "lib.inspect"

return function()
    local judgement = {}

    function judgement:load(timings)
        self.body = box(0, 700, love.graphics.getWidth(), 2)
        self.timings = timings
        self.hitObjectTimings = {}
        self.startTime = 0
        self.judgements = {
            hit = 0.5,
            miss = 1,
        }

        beam:receive("beatTimes", self, function(beatTimes, startTime)
            self.startTime = startTime

            for _, timing in ipairs(self.timings) do
                table.insert(self.hitObjectTimings, beatTimes[timing])
            end
        end)

        beam:receive("miss", self, function()
            self:removeFirstHitObject()
        end)

        return self
    end

    function judgement:draw()
        love.graphics.rectangle("fill", self.body())
    end

    function judgement:keyPressed(key)
        if key == "space" then
            local timingDifference = math.abs(love.timer.getTime() - self.startTime - self.hitObjectTimings[1])

            if timingDifference <= self.judgements.hit then
                print("PERFECT!")
            elseif timingDifference <= self.judgements.miss then
                print("MISS.")
            else
                print("...")
            end

            if timingDifference <= self.judgements.miss then
                judgement:removeFirstHitObject()
                beam:emit("hit")
            end

            print(timingDifference)
        end
    end

    function judgement:removeFirstHitObject()
        table.remove(self.hitObjectTimings, 1)
        -- Debug
        -- print(inspect(self.hitObjectTimings))
    end

    return judgement
end