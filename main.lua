
require 'middleclass'

require 'states'

function love.load()
	states = states.stateList
	state = states.intro
end

function love.update(dt)
	state:update(dt)
end

function love.draw()
	state:draw()
end

function love.mousepressed(x, y, button)
	state:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	state:mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
	state:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	state:keyreleased(key, unicode)
end

function love.focus(f)
	state:focus(f)
end

function love.quit()
end

