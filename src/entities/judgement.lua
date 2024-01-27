return function()
    local hit = {}

    function hit:load(timings)
        self.timings = timings
        self.currentBeat = 1

        beam:receive("beat", self, function(beat)
            if self.timings[self.currentBeat] == beat then
                -- print("hit!", beat)
                self.currentBeat = self.currentBeat + 1
            end
        end)
    end

    function hit:draw()
        
    end

    return hit
end