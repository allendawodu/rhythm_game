local box = require "lib.box"

return function()
    local button = {}

    function button:load(bounds, onClick, onHover)
        self.body = bounds or box(0, 0, 50, 50)
        self.onClickCallback = onClick or function() end
        self.onHoverCallback = onHover or function() end

        return self
    end

    function button:update(dt)

    end

    function button:draw()
        love.graphics.rectangle("line", self.body())
    end

    function button:mouseMoved(mouseX, mouseY)
        if self.body:isMouseColliding(mouseX, mouseY) then
            self.onHoverCallback()
        end
    end

    function button:mousePressed(mouseX, mouseY)
        if self.body:isMouseColliding(mouseX, mouseY) then
            self.onClickCallback()
        end
    end

    return button
end