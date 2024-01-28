function shallowCopy(original)
    local originalType = type(original)
    local copy
    if originalType == 'table' then
        copy = {}
        for originalKey, originalValue in pairs(original) do
            copy[originalKey] = originalValue
        end
    else -- number, string, boolean, etc.
        copy = original
    end
    return copy
end

return function()
    local police = {}

    function police:load()
        self.collidables = {}

        return self
    end

    -- Uses the Sweep & Prune algorithm
    function police:update()
        -- Sort collidables by one axis
        self:sortCollidables()

        -- Update active interval
        local possibleCollisions = {}
        local activeInterval = {self.collidables[1]}

        for _, collidable in ipairs(self.collidables) do
            if #activeInterval == 0 then
                table.insert(activeInterval, collidable)
            elseif collidable.entity.body:getEdges().left > activeInterval[1].entity.body:getEdges().left or collidable.entity.body:getEdges().right < activeInterval[#activeInterval].entity.body:getEdges().right then
                table.insert(activeInterval, collidable)
            else
                table.insert(possibleCollisions, shallowCopy(activeInterval))
                activeInterval = {collidable}
            end
        end
        if #activeInterval ~= 0 then
            table.insert(possibleCollisions, shallowCopy(activeInterval))
            activeInterval = nil
        end

        -- Check for possible collisions
        for _, possibleCollision in ipairs(possibleCollisions) do
            for i = 1, #possibleCollision - 1 do
                for j = 1 + 1, #possibleCollision do
                    if possibleCollision[i].entity.body:isColliding(possibleCollision[j].entity.body) then
                        possibleCollision[i].onCollideCallback(
                            possibleCollision[i].entity,
                            possibleCollision[j].entity,
                            possibleCollision[j].type
                        )
                        possibleCollision[j].onCollideCallback(
                            possibleCollision[j].entity,
                            possibleCollision[i].entity,
                            possibleCollision[i].type
                        )
                    end
                end
            end
        end
    end

    function police:addCollidable(entity, type, onCollideCallback)
        table.insert(
            self.collidables,
            {
                entity = entity,
                type = type,
                onCollideCallback = onCollideCallback,
            }
        )
    end

    function police:removeCollidable(entity)
        for i, collidable in ipairs(self.collidables) do
            if collidable.entity == entity then
                table.remove(self.collidables, i)
                break
            end
        end
    end

    function police:sortCollidables()
        table.sort(
            self.collidables,
            function (a, b)
                return a.entity.body.y < b.entity.body.y
            end
        )
    end

    return police
end

--[[
    TODO
        Go backwards through list
]]