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
	if (love.timer.getTime()*10 % 11 < 7) then 
		love.graphics.draw(graphics['PRESSANYKEY.png'],
				(love.graphics.getWidth() - 3*graphics['PRESSANYKEY.png']:getWidth())/2,
				love.graphics.getHeight()/4*3 - 3*graphics['PRESSANYKEY.png']:getHeight()/3,
				0, 3, 3)
	end
	love.graphics.draw(graphics['SUPER.png'],
			(love.graphics.getWidth() - 3*graphics['SUPER.png']:getWidth())/2,
			love.graphics.getHeight()*.2 - 1.5*graphics['SUPER.png']:getHeight(),
			0, 3, 3)
	love.graphics.draw(graphics['SOUP.png'],
			(love.graphics.getWidth() - 3*graphics['SOUP.png']:getWidth())/2,
			love.graphics.getHeight()*.2 - 1.5*graphics['SOUP.png']:getHeight() + 3*graphics['SUPER.png']:getHeight(),
			0, 3, 3)
	love.graphics.draw(graphics['SWAP.png'],
			(love.graphics.getWidth() - 3*graphics['SWAP.png']:getWidth())/2,
			love.graphics.getHeight()*.2 - graphics['SWAP.png']:getHeight() + 3*graphics['SOUP.png']:getHeight() + 3*graphics['SUPER.png']:getHeight(),
			0, 3, 3)
end

function Menu:mousepressed(x, y, button)
	changeState("gamestart")
end

function Menu:keypressed(key, unicode)
	changeState("gamestart")
end

