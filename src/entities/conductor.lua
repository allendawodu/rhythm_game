return function ()
    local conductor = {}

   function conductor:load(song, bpm, offset)
            self.song = song
            self.bpm = bpm
            self.crochet = 60 / self.bpm
            self.offset = offset
            self.songPosition = 0
            self.lastBeat = 0

            self.song:play()

        return self
   end

   function conductor:update()
        self.songPosition = self.song:tell() - self.offset + self.crochet

        if self.songPosition > self.lastBeat + self.crochet then
            local error = self.songPosition - (self.lastBeat + self.crochet)
            self.lastBeat = self.lastBeat + self.crochet - error
            print("ding!", error)
        end
   end

   return conductor
end