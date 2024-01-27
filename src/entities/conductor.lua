return function ()
    local conductor = {}

    function conductor:load(song, bpm, offset)
        self.song = song
        self.bpm = bpm
        -- Initial time offset for the first beat
        self.offset = offset
        -- Counter for which eighth note we're on
        self.beat = 1
        -- Used for error correction in beat timing
        self.errorCorrectionFactor = 0
        -- Smooth out timing discrepancies without causing abrupt changes
        self.correctionRate = 60 / self.bpm * 0.005

        -- Beat prediction and timing
        self.eighthNoteDuration = 60 / self.bpm / 2
        self.beatTimes = {}
        for i = 1, 1000 do
            self.beatTimes[i] = i * self.eighthNoteDuration + self.offset
        end
        beam:emit("beatTimes", self.beatTimes)

        -- Start song
        self.song:play()
        self.startTime = love.timer.getTime() - self.eighthNoteDuration

        return self
    end

    function conductor:update()
        local currentTime = love.timer.getTime() - self.startTime
        local nextBeatTime = self.beatTimes[self.beat] + self.errorCorrectionFactor

        if currentTime >= nextBeatTime then
            beam:emit("beat", self.beat)

            -- Debug
            -- if self.beat % 4 == 1 then
            --     print("ding!", self.beat)
            -- end

            -- Calculate and apply error correction for next beat
            local beatError = currentTime - nextBeatTime
            self.errorCorrectionFactor = self.errorCorrectionFactor - beatError * self.correctionRate

            self.beat = self.beat + 1
        end
    end

    return conductor
end
