return function()
    local hit = {}

    function hit:load(beam, timings)
        self.beam = beam
        self.timings = timings
        self.currentBeat = 1

        self.beam:receive("beat", self, function(beat)
            if self.timings[self.currentBeat] == beat then
                print("hit!", beat)
                self.currentBeat = self.currentBeat + 1
            end
        end)
    end

    function hit:draw()
        
    end

    return hit
end