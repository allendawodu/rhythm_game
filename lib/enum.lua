local function enum(...)
    local enumMetatable = {
        __index = function(table, key)
            if table[key] == nil then
                error("Attempted to index immutable enum.", 2)
            else
                return table[key]
            end
        end,
        __newindex = function(table, key, value)
            error("Attempted to index immutable enum.", 2)
        end,
        __tostring = function(self)
            local stringBuilder = ""

            for key, value in pairs(self) do
                if type(value) == "number" then
                    stringBuilder = stringBuilder .. value .. " : " .. key .. "\n"
                end
            end

            return stringBuilder
        end
    }

    local newEnum = {}

    for index, value in ipairs({...}) do
        newEnum[value] = index
    end

    function newEnum:random()
        local highestInteger = 0

        for _, value in pairs(self) do
            if type(value) == "number" and value > highestInteger then
                highestInteger = value
            end
        end

        return love.math.random(highestInteger)
    end

    setmetatable(newEnum, enumMetatable)
    return newEnum
end

return enum

--[[ 
    You shouldn't be able to do this:
        Elements.Water = Elements.Earth
        Elements.Water = 2
]]