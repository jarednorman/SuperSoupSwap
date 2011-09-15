module(..., package.seeall)

Intro = states.State:subclass('Intro')

function Intro:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
end

function Intro:update(dt)
	print(dt)
end
