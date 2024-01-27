-- return function ()
--     local conductor = {}

--    function conductor:load(beam, song, bpm, offset)
--         self.beam = beam
--         self.song = song
--         self.bpm = bpm
--         self.eighthNoteDuration = 60 / self.bpm / 2
--         self.offset = offset
--         self.songPosition = 0
--         self.lastBeat = 0
--         self.beat = 1

--         self.song:play()

--         return self
--    end

--    function conductor:update()
--         self.songPosition = self.song:tell() - self.offset + self.eighthNoteDuration

--         if self.songPosition > self.lastBeat + self.eighthNoteDuration then
--             local error = self.songPosition - (self.lastBeat + self.eighthNoteDuration)
--             self.lastBeat = self.lastBeat + self.eighthNoteDuration - error

--             self.beam:emit("beat", self.beat)
--             -- print("ding!", error)

--             self.beat = self.beat + 1
--         end
--    end

--    return conductor
-- end

-- return function ()
--     local conductor = {}

--     function conductor:load(beam, song, bpm, offset)
--         self.beam = beam
--         self.song = song
--         self.bpm = bpm
--         self.eighthNoteDuration = 60 / self.bpm / 2
--         self.offset = offset
--         self.songPosition = 0
--         self.lastBeat = 0
--         self.beat = 1

--         self.song:play()
--         self.startTime = love.timer.getTime() - self.eighthNoteDuration -- Use a high-precision timer

--         return self
--     end

--     function conductor:update()
--         local currentTime = love.timer.getTime() - self.startTime
--         local expectedPosition = self.beat * self.eighthNoteDuration + self.offset

--         if currentTime >= expectedPosition then
--             self.beam:emit("beat", self.beat)
--             -- print("Beat!", self.beat)

--             self.beat = self.beat + 1
--             self.lastBeat = expectedPosition
--         end
--     end

--     return conductor
-- end

return function ()
    local conductor = {}

    function conductor:load(beam, song, bpm, offset)
        self.beam = beam
        self.song = song
        self.bpm = bpm
        self.eighthNoteDuration = 60 / self.bpm / 2
        self.offset = offset
        self.beatTimes = {}
        self.beat = 1

        -- Pre-calculate beat times
        for i = 1, 1000 do
            self.beatTimes[i] = i * self.eighthNoteDuration + self.offset
        end

        self.song:play()
        self.startTime = love.timer.getTime() - self.eighthNoteDuration -- Replace with an appropriate high-precision timer function

        return self
    end

    function conductor:update()
        local currentTime = love.timer.getTime() - self.startTime
        local nextBeatTime = self.beatTimes[self.beat]

        if currentTime >= nextBeatTime then
            self.beam:emit("beat", self.beat)
            if self.beat % 4 == 1 then
                -- print("ding!", self.beat)
            end
            self.beat = self.beat + 1
        end
    end

    return conductor
end
