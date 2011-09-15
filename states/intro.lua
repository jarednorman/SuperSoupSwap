module(..., package.seeall)

Intro = states.State:subclass('Intro')

function Intro:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
	self.counter = 0
end

function Intro:update(dt)
	self.counter = self.counter + dt
	if self.counter >= 2 then
		changeState("menu")
	end
end

