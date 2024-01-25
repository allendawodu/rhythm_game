local tiktok = require "lib.tiktok"

local function shootComponent()
    local shoot = {}

    function shoot:load(mediator, reloadTime)
        self.mediator = mediator
        self.reloadTime = reloadTime or 0.1
        self.canShoot = true
        self.reloadTimer = tiktok():load(
            self.reloadTime,
            false,
            false,
            function ()
                self.canShoot = true
                self.reloadTimer:reset()
            end
        )

        self.mediator:receive("death", self, function ()
            self.canShoot = false
        end)

        return self
    end

    function shoot:update(dt)
        self.reloadTimer:update(dt)
    end

    function shoot:shoot()
        if self.canShoot then
            self.canShoot = false
            self.mediator:emit("shoot")
            self.reloadTimer:start()
        end
    end

    return shoot
end

return shootComponent