module(..., package.seeall)

GameStart = states.State:subclass('GameStart')

function GameStart:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	loadImage('bg.png')
	self.countDown = 4
	loadImage('1.png')
	loadImage('2.png')
	loadImage('3.png')
	loadImage('GO.png')
	g:reinitialize()
end

function GameStart:update(dt)
	self.countDown = self.countDown - dt
	if self.countDown <= 0 then
		changeState('game')
	end
end

function GameStart:draw()
	g:draw()
	if self.countDown < 1 then
		love.graphics.draw(graphics['GO.png'],
								love.graphics.getWidth()/2 - graphics['GO.png']:getWidth()*10/2,
								love.graphics.getHeight()/2 - graphics['GO.png']:getHeight()*10/2,
								0, 10, 10)
	elseif self.countDown < 2 then
		love.graphics.draw(graphics['1.png'],
								love.graphics.getWidth()/2,
								love.graphics.getHeight()/2,
								self.countDown%1*math.pi*2, 8, 8,
								graphics['1.png']:getWidth()/2, graphics['1.png']:getHeight()/2)
	elseif self.countDown < 3 then
		love.graphics.draw(graphics['2.png'],
								love.graphics.getWidth()/2,
								love.graphics.getHeight()/2,
								self.countDown%1*math.pi*2, 8, 8,
								graphics['2.png']:getWidth()/2, graphics['2.png']:getHeight()/2)
	elseif self.countDown < 4 then
		love.graphics.draw(graphics['3.png'],
								love.graphics.getWidth()/2,
								love.graphics.getHeight()/2,
								self.countDown%1*math.pi*2, 8, 8,
								graphics['3.png']:getWidth()/2, graphics['3.png']:getHeight()/2)
	end
end

