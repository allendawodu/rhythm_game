local box = require "lib.box"

return function ()
    local hit = {}

    function hit:load(beatTime, position)
        self.image = love.graphics.newImage("dev/tap_note.png")
        self.body = box(position.x, position.y, self.image:getWidth(), self.image:getHeight())
        self.judgementLineHeight = 700
        self.disappearHeight = self.judgementLineHeight + 50
        self.isVisible = false
        self.shouldDestroy = false

        flux.to(self.body, beatTime, {y = self.judgementLineHeight})
            :ease("linear")
            :after(1, {y = self.disappearHeight})

        return self
    end

    function hit:update()
        if self.body.y > -100 and not self.isVisible then
            self.isVisible = true
        end

        if self.body.y >= self.disappearHeight - 1 and not self.shouldDestroy then
            self.isVisible = false
            self.shouldDestroy = true
            -- FIXME: This is a quick fix for the hitObject to know which lane it is on.
            if self.body.x < love.graphics.getWidth() / 2 then
                beam.emit("onJudgement", "miss", 1)
            else
                beam.emit("onJudgement", "miss", 2)
            end
        end
    end

    function hit:draw()
        if self.isVisible then
            love.graphics.draw(self.image, self.body.x - self.body.width / 2, self.body.y - self.body.height / 2)
        end
    end

    return hit
end