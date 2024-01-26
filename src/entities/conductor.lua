return function ()
    local conductor = {}

   function conductor:load()
            self.bpm = 0
            self.crotchet = 0
            

        return self
   end

   function conductor:update(dt)

   end
end