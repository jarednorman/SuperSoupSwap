module(..., package.seeall)

GameStart = states.State:subclass('GameStart')

function GameStart:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
end

function GameStart:update(dt)
end

function GameStart:draw()
end

