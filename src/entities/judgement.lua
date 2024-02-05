local box = require "lib.box"

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

        beam.receive("onGenerateBeatTimes", self, function(beatTimes, startTime)
            self.startTime = startTime

            for lane, timings in ipairs(self.timings) do
                self.hitObjectTimings[lane] = {}

                for _, timing in pairs(timings) do
                    table.insert(self.hitObjectTimings[lane], beatTimes[timing])
                end
            end
        end)

        beam.receive("onJudgement", self, function(_, lane)
            self:removeFirstHitObject(lane)
        end)

        return self
    end

    function judgement:draw()
        love.graphics.rectangle("fill", self.body())
    end

    function judgement:keyPressed(key)
        if key == "left" then
            local timingDifference = math.abs(love.timer.getTime() - self.startTime - self.hitObjectTimings[1][1])

            if timingDifference <= self.judgements.hit then
                beam.emit("onJudgement", "hit", 1)
            elseif timingDifference <= self.judgements.miss then
                beam.emit("onJudgement", "miss", 1)
            else
                print("... (1)")
            end
        end

        if key == "right" then
            local timingDifference = math.abs(love.timer.getTime() - self.startTime - self.hitObjectTimings[2][1])

            if timingDifference <= self.judgements.hit then
                beam.emit("onJudgement", "hit", 2)
            elseif timingDifference <= self.judgements.miss then
                beam.emit("onJudgement", "miss", 2)
            else
                print("... (2)")
            end
        end

        if key == "n" then
            print("^")
        end
    end

    function judgement:removeFirstHitObject(lane)
        table.remove(self.hitObjectTimings[lane], 1)
    end

    return judgement
end