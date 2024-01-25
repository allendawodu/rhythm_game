local tiktok = require "lib.tiktok"

local function healthComponent()
    local health = {}

    function health:load(mediator, initialHealth)
        self.mediator = mediator
        self.health = initialHealth or 1
        self.maxHealth = self.health
        self.canTakeDamage = true
        self.invincibilityTimer = tiktok():load(
            0.1,
            false,
            false,
            function ()
                self.canTakeDamage = true
                self.invincibilityTimer:reset()
            end
        )

        return self
    end

    function health:update(dt)
        self.invincibilityTimer:update(dt)
    end

    function health:takeDamage(damage)
        if self.canTakeDamage and self.health ~= 0 then
            self.canTakeDamage = false
            self.health = math.max(self.health - damage, 0)
            self.mediator:emit("damageTaken", self.health)

            if self.health == 0 then
                self.mediator:emit("death")
            end

            self.invincibilityTimer:start()
        end
    end

    return health
end

return healthComponent