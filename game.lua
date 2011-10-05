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
		love.graphics.setColor(255, 0, 255)
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
	
	self:getContiguous(6)
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

function Game:getBlock(x, y) --Takes in x, y on game grid, returns the block
	local height = 0
	local realY = 1
	while height < y do
		if self.columns[x][realY].half == 'half' then
			height = height + 1
		else
			height = height + 2
		end

		if height < y then
			break
		end

		realY = realY + 1
	end
	local block = self.columns[x][realY]

	return block
end

function Game:getLocation( block )
	local x = 1
	local y = 1
	while self.columns[x][y] ~= nil do
		while self.columns[x][y] ~= nil do
			if self.columns[x][y] == block then
				local height = 0
				local yPrime = 1
				while yPrime <= y do
					if self.columns[x][yPrime].half == 'half' then
						height = height + 1
					else
						height = height + 2
					end
					yPrime = yPrime + 1
				end

				return x, height
			end
			y = y + 1
		end
		y = 1
		x = x + 1
	end
end

function Game:findLocalContiguous( block ) --returns a table with all those blocks contiguous to and the same colour as the given block
	local colour = block.colour
	local contiguous = {}
	local x, y = self:getLocation( block )
	contiguous[1] = block
	block.flagged = 1


	if block.half == 'half' then
		if y + 1 <= #self.columns[x] then
			if self:getBlock(x, y + 1).colour == colour then
				table.insert(contiguous, self:getBlock(x, y + 1) )
			end
		end

		if y - 1 > 0 then
			if self:getBlock(x, y - 1).colour == colour then
				table.insert(contiguous, self:getBlock(x, y - 1))
			end
		end

		if x + 1 <= #self.columns then
			if self:getBlock(x + 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x + 1, y))
			end
		end

		if x - 1 > 0 then
			if self:getBlock(x - 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x - 1, y))
			end
		end

	else

		if y + 1 <= #self.columns[x] then
			if self:getBlock(x, y + 1).colour == colour then
				table.insert(contiguous, self:getBlock(x, y + 1) )
			end
		end
		
		if y - 2 > 0 then
			if self:getBlock(x, y - 2).colour == colour then
				table.insert(contiguous, self:getBlock(x, y - 2))
			end
		end

		if x + 1 <= #self.columns then
			if self:getBlock(x + 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x + 1, y) )
			end
		end

		if x + 1 <= #self.columns and y - 1 > 0 then
			if self:getBlock(x + 1, y) ~= self:getBlock(x + 1, y - 1) then
				if self:getBlock(x + 1, y - 1).colour == colour then
					table.insert(contiguous, self:getBlock(x + 1, y - 1) )
				end
			end
		end

		if x - 1 > 0 then
			if self:getBlock(x - 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x - 1, y) )
			end
		end

		if x - 1 > 0 and y - 1 > 0 then
			if self:getBlock(x - 1, y) ~= self:getBlock(x - 1, y - 1) then
				if self:getBlock(x - 1, y - 1).colour == colour then
					table.insert(contiguous, self:getBlock(x - 1, y - 1) )
				end
			end	
		end
	end
	return contiguous
end

function Game:areContiguous( table1, table2 ) --takes two tables and returns true if they have an elements in common false otherwise
	for foo, b1 in pairs(table1) do
		for foo2, b2 in pairs(table2) do
			if b1 == b2 then
				return true
			end
		end
	end
	return false
end		

function Game:mergeTables( table1, table2 ) --takes two tables of blocks and returns their union
	local t = {}

	for foo, b1 in pairs(table1) do
		local common = false
		for foo2, b2 in pairs(table2) do
			if b1 == b2 then
				common = true
			end
		end
		if not common then
			table.insert(t, b1)
		end
	end

	for foo, b in pairs(table2) do
		table.insert(t, b)
	end

	return t
end

function Game:getContiguous( n )
	local contiguous = {}
	for k, c in pairs(self.columns) do
		for k2, b in pairs(c) do	
			table.insert(contiguous, self:findLocalContiguous(b))
		end
	end
	local changed = true
	while changed do
		changed = false
		for k, t in pairs(contiguous) do 
			for k2, t2 in pairs(contiguous) do
				if self:areContiguous(t, t2) and t ~= t2 then
					local temp = {}
					for k3, t3 in pairs (contiguous) do
						if t3 ~= t and t3 ~= t2 then
							table.insert(temp, t3)
						end
					end
					
					table.insert(temp, self:mergeTables(t, t2))
					contiguous = temp
					print (#contiguous)
					changed = true
					break
				end
			if changed then
				break
			end
			end
		end
	end


	local temp = {}

	for foo, t in pairs(contiguous) do --filtering out contiguous groups that are too small
		if #t >= n then
			table.insert(temp, t)			
		end
	end

	contiguous = temp

	for k, t in pairs(contiguous) do
		print(#t)
		for k2, b in pairs(t) do
			b.selected = true
		end
		break
	end


	return contiguous

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
