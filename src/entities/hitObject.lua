local vector2 = require "lib.vector2"

return function ()
    local hit = {}

    function hit:load(beatTime, height)
        self.position = vector2(love.graphics.getWidth() / 2, height)
        self.isVisible = true

        flux.to(self.position, beatTime, {y = love.graphics.getHeight()}):ease("linear")

        return self
    end

    function hit:update()
        if self.position.y >= love.graphics.getHeight() - 1 then
            self.isVisible = false
        end
    end

    function hit:draw()
        if self.isVisible then
            love.graphics.circle("fill", self.position.x, self.position.y, 10)
        end
    end

    return hit
end