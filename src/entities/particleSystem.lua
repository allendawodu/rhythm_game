local tiktok  = require "lib.tiktok"
local vector2 = require "lib.vector2"

local function particle(position, direction, speed, lifetime, image)
    return {
        position = position,
        direction = direction,
        speed = speed,
        lifetime = lifetime or 10,
        image = image,
    }
end

local function spawner(position, rotation, image)
    return {
        position = position or vector2(),
        rotation = rotation or 0,
        image = image,
    }
end

local function pfx()
    local particleSystem = {}

    function particleSystem:load(spawnTime, maxParticleLifetime, spawnFunction)
        self.particles = {}
        self.spawners = {}
        self.maxParticleLifetime = maxParticleLifetime
        self.spawnFunction = spawnFunction
        self.spawnTimer = tiktok():load(
            spawnTime or 0.1,
            true,
            false,
            function ()
                self.spawnFunction(self.spawners)
            end
        )

        return self
    end

    function particleSystem:update(dt)
        self.spawnTimer:update(dt)
        for i = #self.particles, 1, -1 do
            local speck = self.particles[i]

            speck.position.x = speck.position.x + speck.direction.x * speck.speed * dt
            speck.position.y = speck.position.y + speck.direction.y * speck.speed * dt

            speck.lifetime = speck.lifetime - dt
            if speck.lifetime < 0 then
                table.remove(self.particles, i)
            end
        end
    end

    function particleSystem:draw()
        for _, speck in ipairs(self.particles) do
            if speck.image then
                -- FIXME, this shouldn't have magic values
                -- I want it to rotate in the direction it's moving
                -- Later, turn rotation into a parameter that is stored in the particle
                love.graphics.draw(speck.image, speck.position.x + 4, speck.position.y + 4, speck.direction:lookAt(vector2(0, 1)), 1, 1, speck.image:getWidth() / 2, speck.image:getHeight() / 2)
            else
                love.graphics.setColor(0.52, 0.68, 0.64, 0.5)
                -- Offset particles because position is top left of spirte
                love.graphics.circle("fill", speck.position.x + 4, speck.position.y + 4, 4)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    function particleSystem:start()
        self.spawnTimer:start()
    end

    function particleSystem:addSpawner(position, rotation, image)
        table.insert(self.spawners, spawner(position, rotation, image))
    end

    function particleSystem:addParticle(position, direction, speed, lifetime, image)
        table.insert(self.particles, particle(position, direction, speed, lifetime or self.maxParticleLifetime, image))
    end

    return particleSystem
end

return pfx

--[[
    Usage
        spiral = particleSystem:load(
            spawnTime (ex. 0.1),
            maxParticleLifetime (ex. 10 seconds),
            spawnFunction ex: function (spawners)
                for _, spawner in ipairs(spawners) do
                    spiral:addParticle(vector2(spawner.position()), vector2(math.cos(spawner.rotation), math.sin(spawner.rotation)), 100)
                    spawner.rotation = spawner.rotation + 0.1
                end
            end
        )

        spiral:addSpawner(vector2(256, 384), 0)
        spiral:addSpawner(vector2(256, 384), math.pi)
        spiral:addSpawner(vector2(256, 384), math.pi / 2)
        spiral:addSpawner(vector2(256, 384), -math.pi / 2)
        spiral:start()
]]