return function ()
    local conductor = {}

    function conductor:load(currentSongData)
        self.song = love.audio.newSource(currentSongData.file, "stream")
        self.bpm = currentSongData.bpm
        -- Initial time offset for the first beat
        self.offset = currentSongData.offset
        -- Number of notes in the song
        self.numNotes = currentSongData.timings[#currentSongData.timings]
        -- Counter for which eighth note we're on
        self.beat = 1
        -- Used for error correction in beat timing
        self.errorCorrectionFactor = 0
        -- Smooth out timing discrepancies without causing abrupt changes
        self.correctionRate = 60 / self.bpm * 0.005
        -- Offset set by the user during calibration (positive moves judgement downwards)
        self.userOffset = 0.25  -- 0.25 for laptop, 0.0 for Desktop

        -- Beat prediction and timing
        self.eighthNoteDuration = 60 / self.bpm / 2
        self.beatTimes = {}
        for i = 1, self.numNotes do
            self.beatTimes[i] = i * self.eighthNoteDuration + self.offset - self.userOffset
        end

        -- Start song
        self.song:play()
        self.startTime = love.timer.getTime() - self.eighthNoteDuration

        beam.emit("onGenerateBeatTimes", self.beatTimes, self.startTime)

        return self
    end

    function conductor:update()
        local currentTime = love.timer.getTime() - self.startTime
        local nextBeatTime = self.beatTimes[self.beat] + self.errorCorrectionFactor

         if (currentTime >= nextBeatTime) and not (self.beat >= self.numNotes) then
            beam.emit("onBeat", self.beat)

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
