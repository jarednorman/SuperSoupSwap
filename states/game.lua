
module(..., package.seeall)

Game = states.State:subclass('Game')

function Game:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	print(nextState)
	if graphics['SUPER.png'] == nil then
		love.graphics.newImage('Graphics/SUPER.png')
	end
end

function Game:update(dt)
end

