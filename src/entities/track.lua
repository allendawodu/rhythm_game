local vector2 = require "lib.vector2"

local hitObject = require "src.entities.hitObject"

return function ()
    local track = {}

    function track:load(currentSongData)
        self.noteSpeed = 100
        self.timings = currentSongData.timings
        self.hitObjects = {}

        beam.receive("onGenerateBeatTimes", self, function(beatTimes)
            for lane, timings in ipairs(self.timings) do
                self.hitObjects[lane] = {}

                for _, timing in pairs(timings) do
                    table.insert(self.hitObjects[lane], hitObject():load(
                        beatTimes[timing],
                        vector2(love.graphics.getWidth() / 2 - 100 + (lane - 1) * 200, -(timing * self.noteSpeed)),
                        lane
                    ))
                end
            end
        end)

        beam.receive("onJudgement", self, function(_, lane)
            self.hitObjects[lane][1].shouldDestroy = true

            if #self.hitObjects[1] == 0 and #self.hitObjects[2] == 0 then
                beam.emit("onSongClear")
            end
        end)

        return self
    end

    function track:update()
        for lane, _ in ipairs(self.hitObjects) do
            for i = #self.hitObjects[lane], 1, -1 do
                self.hitObjects[lane][i]:update()

                if self.hitObjects[lane][i].shouldDestroy then
                    table.remove(self.hitObjects[lane], i)
                end
            end
        end
    end

    function track:draw()
        for lane, _ in ipairs(self.hitObjects) do
            for i = #self.hitObjects[lane], 1, -1 do
                self.hitObjects[lane][i]:draw()
            end
        end
    end

    return track
end