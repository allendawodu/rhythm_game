return function ()
    local conductor = {}

    function conductor:load(currentSongData)
        self.song = love.audio.newSource(currentSongData.file, "stream")
        self.bpm = currentSongData.bpm
        -- Initial time offset for the first beat
        self.offset = currentSongData.offset
        -- Counter for which eighth note we're on
        self.beat = 1
        -- Used for error correction in beat timing
        self.errorCorrectionFactor = 0
        -- Smooth out timing discrepancies without causing abrupt changes
        self.correctionRate = 60 / self.bpm * 0.005


        -- Offset set by the user during calibration (positive moves judgement downwards)
        self.userOffset = settings.data.userOffset
        print("User Offset: " .. self.userOffset)

        -- Number of notes in the song
        -- FIXME: Breaks if there are no notes
        self.numNotes = currentSongData.timings[1][#currentSongData.timings[1]]
        for _, timings in ipairs(currentSongData.timings) do
            if timings[#timings] > self.numNotes then
                self.numNotes = #timings
            end
        end

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

    function conductor:stop()
        self.song:stop()
    end

    return conductor
end
