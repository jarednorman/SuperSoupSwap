module(..., package.seeall)

ScoreCounter = class('ScoreCounter')

function ScoreCounter:initialize()
	self.pointsPerBlock = 10
	
	self:reset()
end


function ScoreCounter:reset()
	self.score = 0
	self.combo = 1
end

function ScoreCounter:getScore()
	return self.score
end

function ScoreCounter:swap()
	-- This should be called every time the player swaps tiles, to clear combo calculations
	self.combo = 1
end

function ScoreCounter:clearSet(n)
	-- When a set of contiguous blocks of size n is cleared, this function should be called
	-- it returns how many points the player scored
	local p = n * self.pointsPerBlock * self.combo
	self:add(p)
	self.combo = self.combo + 1
	return p
end

function ScoreCounter:add(points)
	self.score = self.score + points
end

