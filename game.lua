module(..., package.seeall)

Game = class("Game")

function Game:initialize()
	print("SDFN")
end

function Game:reinitialize()
	print("Game reinited")
end

function Game:draw()
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()/2 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()/2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()/2 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()/2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*2,
							0, 2, 2)
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
