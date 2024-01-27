return function()
    local hit = {}

    function hit:load(beam, timings)
        self.beam = beam
        self.timings = timings
        self.currentTiming = 1

        self.beam:receive("beat", self, function(beat)
            if self.timings[self.currentTiming] == beat then
                print("hit!", beat)
                self.currentTiming = self.currentTiming + 1
            end
        end)
    end

    function hit:update()
        
    end

    function hit:draw()
        
    end

    return hit
end