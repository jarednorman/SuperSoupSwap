module(..., package.seeall)

Menu = states.State:subclass('Menu')

function Menu:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	loadImage('PRESSANYKEY.png')
	loadImage('SUPER.png')
	loadImage('SOUP.png')
	loadImage('SWAP.png')
end

function Menu:update(dt)
end

function Menu:draw()
	love.graphics.draw(graphics['PRESSANYKEY.png'], (love.graphics.getWidth() - 3*graphics['PRESSANYKEY.png']:getWidth())/2, love.graphics.getHeight()*.75 - 1.5*graphics['PRESSANYKEY.png'], 0, 3, 3, 0)
	love.graphics.draw(graphics['SUPER.png'], 0, 0, 0, 3, 3, 0)
	love.graphics.draw(graphics['SOUP.png'], 0, 0, 0, 3, 3, 0)
	love.graphics.draw(graphics['SWAP.png'], 0, 0, 0, 3, 3, 0)
end

function Menu:mousepressed(x, y, button)
	changeState("gamestart")
end

function Menu:keypressed(key, unicode)
	changeState("gamestart")
end

