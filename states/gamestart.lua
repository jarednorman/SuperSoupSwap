module(..., package.seeall)

GameStart = states.State:subclass('GameStart')

function GameStart:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	self.countDown = 3
end

function GameStart:update(dt)
	self.countDown = self.countDown - dt
	if self.countDown <= 0 then
		changeState('game')
	end
end

function GameStart:draw()
	print(self.countDown)
end

