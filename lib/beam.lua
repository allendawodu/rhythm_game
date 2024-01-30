local beam = {
    events = {}
}

local function createEvent(event)
    if beam.events[event] == nil then
        beam.events[event] = {}
    end
end

function beam.emit(event, ...)
    createEvent(event)
    for _, receiver in ipairs(beam.events[event]) do
        receiver.callback(unpack({...}))
    end
end

function beam.receive(event, obj, callback)
    createEvent(event)
    table.insert(
        beam.events[event],
        {
            obj = obj,
            callback = callback
        }
    )
end

function beam.close(event, obj)
    for i, receiver in ipairs(beam.events[event]) do
        if receiver.obj == obj then
            table.remove(beam.events[event], i)
            break
        end
    end
end

function beam.closeAll(obj)
    for event, _ in pairs(beam.events) do
        for i = #beam.events[event], 1, -1 do
            if beam.events[event].obj == obj then
                table.remove(beam.events[event], i)
            end
        end
    end
end

return beam