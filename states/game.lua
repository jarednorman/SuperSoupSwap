
module(..., package.seeall)

Game = states.State:subclass('Game')

function Game:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	loadImage('SUPER.png')
end

function Game:update(dt)
end

function Game:draw()
	love.graphics.draw(graphics['SUPER.png'], 255, 255)
end

