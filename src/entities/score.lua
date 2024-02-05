return function()
    local score = {}

    function score:load(currentSongData)
        self.hitNotes = 0
        self.ratings = {
            perfect = 1.0,
            superb = 0.8,
            ok = 0.5,
        }

        self.numNotes = currentSongData.timings[1][#currentSongData.timings[1]]
        for _, timings in ipairs(currentSongData.timings) do
            if timings[#timings] > self.numNotes then
                self.numNotes = #timings
            end
        end

        beam.receive("onJudgement", self, function(type, _)
            if type == "hit" then
                self.hitNotes = self.hitNotes + 1
            end
        end)

        beam.receive("onSongClear", self, function()
            print("Score: ", self:getRating())
        end)
    end

    function score:draw()
        
    end

    function score:getRating()
        local ratio = self.hitNotes / self.numNotes
        print(ratio)
        if ratio >= self.ratings.perfect then
            return "PERFECT"
        elseif ratio >= self.ratings.superb then
            return "Superb"
        elseif ratio >= self.ratings.ok then
            return "ok"
        else
            return "Try again..."
        end
    end

    return score
end