module(..., package.seeall)

Block = class("Block")

function Block:initialize(colour, half)
	loadImage('blue.png')
	loadImage('peaches.png')
	loadImage('mushroom.png')
	loadImage('tomato.png')
	loadImage('bluehalf.png')
	loadImage('peacheshalf.png')
	loadImage('mushroomhalf.png')
	loadImage('tomatohalf.png')
	self.colour = colour
	self.half = half
	self.selected = false
end

function Block:draw(x,y)
	local sprite = self.colour .. self.half .. ".png"
	love.graphics.draw(graphics[sprite], x, y, 0, 2, 2)
	if self.selected then
		if self.half == 'half' then
			love.graphics.rectangle('line', x+0.5, y+0.5, 44, 30 )
			love.graphics.rectangle('line', x+1.5, y+1.5, 44-2, 30-2)
		else
			love.graphics.rectangle('line', x+0.5, y+0.5, 44, 60)
			love.graphics.rectangle('line', x+1.5, y+1.5, 44-2, 60-2)
		end
	end
	
end

Game = class("Game")

function Game:initialize()
end

function Game:reinitialize()
	math.randomseed(os.time())
	self.columns = {}
	for n=1,8 do
		self.columns[n] = {}
	end
	-- POPULATE --
	local initialBlockCount = 50
	local colours = {'tomato', 'peaches', 'blue', 'mushroom'}
	local haff = {'','half'}
	local n = 0
	while n < initialBlockCount do
		local column = math.random(1,#self.columns)
		local colour = colours[math.random(1,#colours)]
		local half = haff[math.random(1,2)]
		-- Only increment the number of blocks if we successfully
		-- place the block (i.e. don't if the column is full)
		if self:insertBlock(column, Block(colour, half)) then
			n = n + 1
		end
	end
	self.columns[1][1].selected = true
end

function Game:insertBlock(column, block)
	-- if the block won't fit, return false
	local c = self.columns[column]
	local columnHeight = 0
	for k,v in ipairs(c) do
		if v.half == 'half' then
			columnHeight = columnHeight + 1
		else
			columnHeight = columnHeight + 2
		end
	end
	-- add the block
	local blockHeight = 1
	if block.half == 'half' then blockHeight = 2 end
	if columnHeight + blockHeight > 17 then
		return false
	end
	table.insert(c, block)
	return true
end

function Game:locateSquare(x, y)
	local x = x - 1
	local y = 18 - y
	x = love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4 + x*44
	y = love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*3 + y*30
	return x, y
end

function Game:convertScreenPosition(x, y)
	local x = (x - love.graphics.getWidth()*.85 + graphics['bg.png']:getWidth()*4)/44
	local y = (y - love.graphics.getHeight() + graphics['bg.png']:getHeight()*2*3)/30
	x = math.floor(x + 1)
	y = math.ceil(18 - y)
	return x, y
end

function Game:draw()
	-- Draw Board --
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*2,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*4,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*3,
							0, 2, 2)
	love.graphics.draw(graphics['bg.png'],
							love.graphics.getWidth()*.85 - graphics['bg.png']:getWidth()*2,
							love.graphics.getHeight() - graphics['bg.png']:getHeight()*2*3,
							0, 2, 2)
	-- Draw blocks --
	for k,v in ipairs(self.columns) do
		local verticalBlock = 0
		for n,b in ipairs(v) do
			if b.half == 'half' then
				verticalBlock = verticalBlock + 1
			else
				verticalBlock = verticalBlock + 2
			end
			local x,y = self:locateSquare(k, verticalBlock)
			b:draw(x,y)
		end
	end

	-- Draw HUD --
	love.graphics.draw(graphics['SUPER.png'],
							6,
							6,
							0, 2, 2)
	love.graphics.draw(graphics['SOUP.png'],
							6,
							10 + graphics['SUPER.png']:getHeight()*2,
							0, 2, 2)
	love.graphics.draw(graphics['SWAP.png'],
							6,
							14 + graphics['SUPER.png']:getHeight()*2 + graphics['SOUP.png']:getHeight()*2,
							0, 2, 2)


end

function Game:mouseClicked(x, y)
end
