
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
	love.graphics.draw(graphics['SUPER.png'],
							6,
							6,
							0, 2, 2)
	love.graphics.draw(graphics['SOUP.png'],
							graphics['SUPER.png']:getWidth()*2 + 12,
							6,
							0, 2, 2)
	love.graphics.draw(graphics['SWAP.png'],
							graphics['SUPER.png']:getWidth()*2 + graphics['SOUP.png']:getWidth()*2 + 18,
							6,
							0, 2, 2)
end

