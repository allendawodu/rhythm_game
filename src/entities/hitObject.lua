local vector2 = require "lib.vector2"

return function ()
    local hit = {}

    function hit:load(beatTime, height)
        self.position = vector2(love.graphics.getWidth() / 2, height)
        self.judgementLineHeight = 700
        self.disappearHeight = self.judgementLineHeight + 50
        self.isVisible = false
        self.shouldDestroy = false

        flux.to(self.position, beatTime, {y = self.judgementLineHeight})
            :ease("linear"):after(1, {y = self.disappearHeight})

        return self
    end

    function hit:update()
        if self.position.y > -100 and not self.isVisible then
            self.isVisible = true
        end

        if self.position.y >= self.disappearHeight - 1 then
            self.isVisible = false
            self.shouldDestroy = true
        end
    end

    function hit:draw()
        if self.isVisible then
            love.graphics.circle("fill", self.position.x, self.position.y, 10)
        end
    end

    return hit
end