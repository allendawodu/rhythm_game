--[[
    once.run(test, false)
        If the function hasn't already been ran, run it
    once.run(test, true)
        Pretend that the test function has already been ran, but don't run it
    once.reset(test)
        Allow the test function to be run the next time once.run(test) is called
    
    TODO
        Check if this works with multiple instances of the same object
        Should this be a singleton?
]]

local once = {
    ranFunctions = {}
}

function once.run(fn, startClosed, ...)
    if once.ranFunctions[fn] then
        return
    end

    if startClosed and once.ranFunctions[fn] == nil then
        once.ranFunctions[fn] = true
        return
    end

    once.ranFunctions[fn] = true
    fn(...)
end

function once.reset(fn)
    once.ranFunctions[fn] = false
end

function once.clear()
    once.ranFunctions = {}
end

return once

-- -- Debug
-- local function testPrint(num)
--     print(num)
-- end

-- for i = 1, 10, 1 do
--     once:run(testPrint, true, i)
--     if i % 2 == 0 then
--         once:reset(testPrint)
--     end
-- end
-- -- Debug
