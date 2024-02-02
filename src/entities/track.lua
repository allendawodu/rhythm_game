local hitObject = require "src.entities.hitObject"

return function ()
    local track = {}

    function track:load(currentSongData)
        self.noteSpeed = 100
        self.timings = currentSongData.timings
        self.hitObjects = {}

        beam.receive("onGenerateBeatTimes", self, function(beatTimes)
            -- Debug
            -- for i, beatTime in ipairs(beatTimes) do
            --     if i % 4 == 1 then
            --         table.insert(self.hitObjects, hitObject():load(beatTime, -(i * self.noteSpeed) - 100))
            --     end
            -- end
            for _, timing in ipairs(self.timings) do
                table.insert(self.hitObjects, hitObject():load(beatTimes[timing], -(timing * self.noteSpeed)))
            end
        end)

        beam.receive("onJudgement", self, function()
            self.hitObjects[1].shouldDestroy = true
        end)

        return self
    end

    function track:update()
        for i = #self.hitObjects, 1, -1 do
            self.hitObjects[i]:update()

            if self.hitObjects[i].shouldDestroy then
                table.remove(self.hitObjects, i)

                if #self.hitObjects == 0 then
                    beam.emit("onSongClear")
                end
            end
        end
    end

    function track:draw()
        for i = #self.hitObjects, 1, -1 do
            self.hitObjects[i]:draw()
        end
    end

    return track
end