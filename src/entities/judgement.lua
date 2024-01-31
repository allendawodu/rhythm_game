local box = require "lib.box"
local inspect = require "lib.inspect"

return function()
    local judgement = {}

    function judgement:load(currentSongData)
        self.body = box(0, 700, love.graphics.getWidth(), 2)
        self.timings = currentSongData.timings
        self.hitObjectTimings = {}
        self.startTime = 0
        self.judgements = {
            hit = 0.5,
            miss = 1,
        }

        beam.receive("beatTimes", self, function(beatTimes, startTime)
            self.startTime = startTime

            for _, timing in ipairs(self.timings) do
                table.insert(self.hitObjectTimings, beatTimes[timing])
            end
        end)

        beam.receive("judgement", self, function(type)
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
                -- print("PERFECT!")
                beam.emit("judgement", "hit")
            elseif timingDifference <= self.judgements.miss then
                -- print("MISS.")
                beam.emit("judgement", "miss")
            else
                print("...")
            end

            -- print(timingDifference)
        end

        if key == "n" then
            print("^")
        end
    end

    function judgement:removeFirstHitObject()
        table.remove(self.hitObjectTimings, 1)
        -- Debug
        -- print(inspect(self.hitObjectTimings))
    end

    return judgement
end