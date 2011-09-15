module(..., package.seeall)

GameStart = states.State:subclass('GameStart')

function GameStart:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	loadImage('bg.png')
	self.countDown = 3
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
end

