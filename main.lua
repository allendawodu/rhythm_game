flux = require "lib.flux"
beam = require "lib.beam"
once = require "lib.once"
lume = require "lib.lume"
settings = require "src.entities.settings"

local play = require "lib.play"

function love.load()
    settings.load()
	love.window.setVSync(settings.data.vsync)

    songData = require "src.entities.song_data"

    local game = require "src.scenes.game"
    local calibration = require "src.scenes.calibration"
    local songSelect = require "src.scenes.song_select"
    local mainMenu = require "src.scenes.main_menu"
	local optionsMenu = require "src.scenes.options_menu"

    play.start(mainMenu, songSelect, game, calibration, optionsMenu)
    -- play.start(calibration)
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.01) end
	end
end

function love.update(dt)
    flux.update(dt)
    play.update(dt)
end

function love.draw()
    play.draw()
end

function love.keypressed(key, scancode, isRepeat)
    if key == "f5" then
        settings.reset()
        print("Settings have been reset.")
        love.event.quit("restart")
    end

    play.keyPressed(key, scancode, isRepeat)
end

function love.mousepressed(x, y, button, isTouch, presses)
    play.mousePressed(x, y, button, isTouch, presses)
end

function love.mousemoved(x, y, dx, dy, isTouch)
	play.mouseMoved(x, y, dx, dy, isTouch)
end

--------------------------------------------------

if arg[2] == "debug" then
    require("lldebugger").start()
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end