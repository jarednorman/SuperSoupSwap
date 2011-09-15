module(..., package.seeall)

State = class('State')

function State:initialize()
end

function State:update(dt)
end

function State:draw()
end

function State:mousepressed(x, y, button)
end

function State:mousereleased(x, y, button)
end

function State:keypressed(key, unicode)
end

function State:keyreleased(key, unicode)
end

function State:focus(f)
end

require 'states.intro'
require 'states.menu'
require 'states.game'

stateList = {}
stateList.intro = states.intro.Intro
stateList.menu = states.menu.Menu
stateList.game = states.game.Game

