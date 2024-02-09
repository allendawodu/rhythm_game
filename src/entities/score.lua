return function()
    local score = {}

    function score:load(currentSongData)
        self.hitNotes = 0
        self.ratings = {
            perfect = 1.0,
            superb = 0.5,
            ok = 0.3,
        }

        -- FIXME: This is duplicated code from conductor.lua
        self.numNotes = currentSongData.timings[1][#currentSongData.timings[1]]
        for _, timings in ipairs(currentSongData.timings) do
            if type(timings[#timings]) == "nil" then
                goto continue
            end

            if timings[#timings] > self.numNotes then
                self.numNotes = #timings
            end

            ::continue::
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