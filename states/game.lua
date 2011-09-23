
module(..., package.seeall)

Game = states.State:subclass('Game')

function Game:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	loadImage('SUPER.png')
	loadImage('SOUP.png')
	loadImage('SWAP.png')
end

function Game:update(dt)
end

function Game:draw()
	g:draw()
end

function Game:mousepressed(x, y, button)
	if button == 'l' then
		g:mouseClicked(x, y)
	end
end
