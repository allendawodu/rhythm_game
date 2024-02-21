local settings = {
    data = {
        userOffset = 0.0,
        vsync = 1,
    },
}

function settings.save()
    local serializedData = lume.serialize(settings.data)
    love.filesystem.write("savedata.txt", serializedData)
end

function settings.load()
    if love.filesystem.getInfo("savedata.txt") then
        local file = love.filesystem.read("savedata.txt")
        settings.data = lume.deserialize(file)
    else
        settings.reset()
        settings.load()
    end
end

function settings.reset()
    local defaults = {
        userOffset = 0.0,
        vsync = 1,
    }

    love.filesystem.write("savedata.txt", lume.serialize(defaults))
end

return settings