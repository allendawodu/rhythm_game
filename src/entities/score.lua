return function()
    local score = {}

    function score:load(currentSongData)
        self.numNotes = currentSongData.timings[#currentSongData.timings]
        self.hitNotes = 0
        self.ratings = {
            s = 1.0,
            a = 0.9,
            b = 0.8,
            c = 0.7,
            d = 0.6,
        }

        beam.receive("judgement", self, function(type)
            if type == "hit" then
                self.hitNotes = self.hitNotes + 1
            end
        end)

        beam.receive("onSongClear", self, function()
            print(self.hitNotes / self.numNotes)
        end)
    end

    function score:draw()
        
    end

    return score
end