module(..., package.seeall)

Game = class("Game")

function Game:initialize()
	print("SDFN")
end

function Game:reinitialize()
	print("Game reinited")
end

function Game:locateSquare(x, y)
	local x = love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4 + x*44
	local y = love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*3 + y*30
	return x, y
end

function Game:convertMousePosition(x, y)
	local x = (x - love.graphics.getWidth()*.85 + graphics['bg.png']:getWidth()*4)/44
	local y = (y - love.graphics.getHeight() + graphics['bg.png']:getHeight()*2*3)/30
	return x, y
end

function Game:draw()
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*3,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*3,
							0, 2, 2)

	love.graphics.draw(graphics['SUPER.png'],
							6,
							6,
							0, 2, 2)
	love.graphics.draw(graphics['SOUP.png'],
							6,
							10 + graphics['SUPER.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['SWAP.png'],
							6,
							14 + graphics['SUPER.png']:getHeight()*2 + graphics['SOUP.png']:getHeight()*2,
							0, 2, 2)
end
