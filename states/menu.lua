module(..., package.seeall)

Menu = states.State:subclass('Menu')

function Menu:initialize()
	love.graphics.setBackgroundColor(25, 34, 41)
end

function Menu:update(dt)
	print(dt)
end

