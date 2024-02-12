local box = require "lib.box"

return function ()
    local hit = {}

    function hit:load(beatTime, position, lane)
        self.image = love.graphics.newImage("assets/kiwi/" .. lume.randomchoice({
            "pink",
            "black",
            "blue",
            "orange",
            "yellow",
            "green"
        }) .. ".png")
        self.body = box(position.x, position.y, self.image:getWidth(), self.image:getHeight())
        self.judgementLineHeight = 700
        self.disappearHeight = self.judgementLineHeight + 50
        self.isVisible = false
        self.shouldDestroy = false
        self.rotation = {
            offset = love.math.random() * 5,
            rotation = 0,
        }
        self.lane = lane

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
            beam.emit("onJudgement", "miss", self.lane)
        end

        self.rotation.rotation = math.sin(love.timer.getTime() + self.rotation.offset) * 5
    end

    function hit:draw()
        if self.isVisible then
            love.graphics.draw(self.image, self.body.x, self.body.y, self.rotation.rotation, 1, 1, self.body.width / 2, self.body.height / 2)
        end
    end

    return hit
end