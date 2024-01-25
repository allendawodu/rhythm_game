local box     = require "lib.box"
local vector2 = require "lib.vector2"

local function tile()
    local draggable = {}

    function draggable:load(image)
        self.image = image
        self.body = box(0, 0, self.image:getWidth(), self.image:getHeight())
        self.isDragging = false
        self.mouseOffset = vector2()
        self.initialPosition = vector2(self.body.x, self.body.y)

        return self
    end

    function draggable:update()
        if self.isDragging then
            self.frame.x, self.frame.y = (vector2(love.mouse.getPosition()) + self.mouseOffset)()
        end
    end

    function draggable:draw()
        love.graphics.draw(self.image, self.body:getPosition())
    end

    function draggable:mousePressed(mouseX, mouseY)
        self.mouseOffset = self.body:getMouseOffset(mouseX, mouseY)
        self.isDragging = true
    end

    function draggable:mouseReleased()
        if self.isDragging then
            self.isDragging = false
        end
    end

    return draggable
end

return tile