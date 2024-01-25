local function tiktok()
    local timer = {}

    function timer:load(seconds, isLooping, isActive, onAlarmCallback, ...)
        self.time = seconds or 1
        self.initialTime = self.time
        self.onAlarmCallback = onAlarmCallback
        self.args = {...}
        self.isLooping = isLooping or false
        self.isActive = isActive or true
        self.isAlarming = false

        return self
    end

    function timer:update(dt)
        if not self.isAlarming and self.isActive then
            self.time = self.time - dt

            if self.time <= 0 then
                self.isAlarming = true
                self.onAlarmCallback(unpack(self.args))

                if self.isLooping then
                    self:reset()
                    self:start()
                end
            end
        end
    end

    function timer:start()
        self.isActive = true
    end

    function timer:reset()
        self.isActive = false
        self.time = self.initialTime
        self.isAlarming = false
    end

    return timer
end

return tiktok