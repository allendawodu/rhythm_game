local function dance()
    local animation = {}

    function animation:load(animationFolderPath, frameDuration, shouldLoop)
        self.animationFolderPath = animationFolderPath
        self.frameDuration = frameDuration or 5
        self.shouldLoop = shouldLoop
        self.frames = {}
        self.time = 0
        self.isDone = false

        local animationFiles = love.filesystem.getDirectoryItems(self.animationFolderPath)
        table.sort(animationFiles)
        for _, animationFile in ipairs(animationFiles) do
            table.insert(self.frames, love.graphics.newImage(self.animationFolderPath .. "/" .. animationFile))
        end

        return self
    end

    function animation:update()
        local animationLength = self.frameDuration * #self.frames
        if self.shouldLoop then
            self.time = (self.time + 1) % animationLength
        else
            -- self.time = math.max(self.time + 1, animationLength)
            self.time = self.time + 1
            if self.time > animationLength then
                self.isDone = true
            end
        end
    end

    function animation:getCurrentFrame()
        return self.frames[math.floor(self.time / self.frameDuration) + 1] or self.frames[#self.frames]
    end

    function animation:reset()
        self.isDone = false
        self.time = 0
    end

    return animation
end

return dance