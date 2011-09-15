
require 'middleclass'

-- A global variable accessible from everyewhere
-- so we don't have duplicate graphics.
-- must be loaded before states so states can
-- load graphics while they are initialized,
-- which happens when we require 'states'
graphics = {}

function changeState(s)
	nextState = s
end

function loadImage(i)
	if graphics[i] == nil then
		graphics[i] = love.graphics.newImage("Graphics/" .. i)
		graphics[i]:setFilter('nearest', 'nearest')
	end
end

require 'states'

function love.load()
	-- The list of all available states
	stateList = states.stateList

	-- The current state, and the name of the next state
	-- see love.update for how this works
	state = stateList.intro()
	print(state)
	currentState = "intro"
	nextState = "intro"
end

function love.update(dt)
	if nextState ~= currentState then
		state = stateList[nextState]()
	end
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
