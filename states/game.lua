
module(..., package.seeall)

Game = states.State:subclass('Game')

function Game:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
end

function Game:update(dt)
	print(dt)
end

