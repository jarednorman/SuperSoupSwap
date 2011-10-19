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
	self.yOffset = 0
	self.xOffset = 0
end

function Block:draw(x,y)
	local sprite = self.colour .. self.half .. ".png"
	love.graphics.draw(graphics[sprite], x + self.xOffset, y+self.yOffset, 0, 2, 2)
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
	self.minContiguous = 4
	self.maxMoves = 5
end

function Game:reinitialize()
	math.randomseed(os.time())
	self.movesLeft = self.maxMoves
	self.columns = {}
	for n=1,8 do
		self.columns[n] = {}
	end
	-- POPULATE --
	local initialBlockCount = 50
	self.colours = {'tomato', 'peaches', 'blue', 'mushroom'}
	self.haff = {'','half'}
	local n = 0
	while n < initialBlockCount do
		local column = math.random(1,#self.columns)
		local colour = self.colours[math.random(1,#self.colours)]
		local half = self.haff[math.random(1,2)]
		-- Only increment the number of blocks if we successfully
		-- place the block (i.e. don't if the column is full)
		if self:insertBlock(column, Block(colour, half)) then
			n = n + 1
		end
	end

	while #self:getContiguous(self.minContiguous) > 0 do
		local contiguous = self:getContiguous(self.minContiguous)
		for k, t in ipairs(contiguous) do
			for k2, b in ipairs(t) do
				b.colour = self.colours[math.random(1,#self.colours)]
			end
		end
	end
	
	self.waitingOnPlayer = true
	self.blockSelected = nil
end

function Game:update(dt) 
	if not self.waitingOnPlayer then
		self:gameLogicIterate(dt)
	end
	if self.movesLeft == 0 then
		self:addRow()
		self.movesLeft = self.maxMoves
	end
end

function Game:addRow()
	for c, column in ipairs(self.columns) do
		local colour = self.colours[math.random(1,#self.colours)]
		local half = self.haff[math.random(1,2)]
		if not self:insertBlock(c, Block(colour, half)) then
			print("GAME OVER")
		end
	end
end


function Game:gameLogicIterate()
	local xOffsetSpeed = 0.9
	local yOffsetSpeed = 0.9
	local somethingMoved = false
	local minXOffset = 0.1
	local minYOffset = 0.1

	for k, t in ipairs(self.columns) do
		for k2, b in ipairs(t) do
			if math.abs(b.yOffset) < minYOffset then
				b.yOffset = 0
			end
			if math.abs(b.xOffset) < minXOffset then
				b.xOffset = 0
			end


			if b.yOffset ~= 0 then
				b.yOffset = b.yOffset * yOffsetSpeed * dt
				somethingMoved = true
			end

			if b.xOffset ~= 0 then
				b.xOffset = b. xOffset * xOffsetSpeed * dt
				somethingMoved = true
			end
		end
	end
	if not somethingMoved then
		local cont = self:getContiguous(self.minContiguous)
		local destroyedAny = false
		if #cont > 0 then destroyedAny = true end
		for _,group in pairs(cont) do
			for k, block in pairs(group) do
				self:destroyBlock(block)
			end
		end
		if not destroyedAny then
			self.waitingOnPlayer = true
		end
	end
end

function Game:destroyBlock(block)
	local startPushing = false
	local offSet = -30
	if block.half == '' then offSet = offSet*2 end
	
	for _, column in ipairs(self.columns) do
		startPushing = false
		for k, b in ipairs(column) do
			if b == block then
				table.remove(column, k)
				startPushing = true
				if column[k] ~= nil then
					column[k].yOffset = offSet
				end
			elseif startPushing then
				b.yOffset = offSet
			end
		end
	end

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
	table.insert(c, 1, block)
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

	if #self.columns[x] == 0 then return nil end

	while height < y do
		if self.columns[x][realY] == nil then break end
		if self.columns[x][realY].half == 'half' then
			height = height + 1
		else
			height = height + 2
		end


		realY = realY + 1
		
		if self.columns[x][realY] == nil and height + 1 < y then
			return nil
		end
	end
	local block = self.columns[x][realY - 1]

	return block
end

function Game:getLocation( block )
	local x = 1
	local y = 1
	while x <= #self.columns do
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

-- returns a table with all the blocks adjacent to and the same colour as the given block
function Game:findLocalContiguous( block )
	local colour = block.colour
	local contiguous = {}
	local x, y = self:getLocation( block )
	contiguous[1] = block
	block.flagged = 1


	if block.half == 'half' then
		-- The block above
		if y + 1 <= #self.columns[x] and self:getBlock(x, y + 1) ~= nil then
			if self:getBlock(x, y + 1).colour == colour then
				table.insert(contiguous, self:getBlock(x, y + 1) )
			end
		end

		-- The block below
		if y - 1 > 0 and self:getBlock(x, y - 1) ~= nil then
			if self:getBlock(x, y - 1).colour == colour then
				table.insert(contiguous, self:getBlock(x, y - 1))
			end
		end

		-- The block to the right
		if x + 1 <= #self.columns and self:getBlock(x + 1, y) ~= nil then
			if self:getBlock(x + 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x + 1, y))
			end
		end

		-- The block to the left
		if x - 1 > 0 and self:getBlock(x - 1, y) ~= nil then
			if self:getBlock(x - 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x - 1, y))
			end
		end

	else

		-- The block above
		if y + 1 <= #self.columns[x] and self:getBlock(x, y + 1) ~= nil then
			if self:getBlock(x, y + 1).colour == colour then
				table.insert(contiguous, self:getBlock(x, y + 1) )
			end
		end
		
		-- The block below
		if y - 2 > 0 and self:getBlock(x, y - 2) ~= nil then
			if self:getBlock(x, y - 2).colour == colour then
				table.insert(contiguous, self:getBlock(x, y - 2))
			end
		end

		-- The block right
		if x + 1 <= #self.columns and self:getBlock(x + 1, y) ~= nil then
			if self:getBlock(x + 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x + 1, y) )
			end
		end
		-- The block right, down one
		if x + 1 <= #self.columns and y - 1 > 0 and self:getBlock(x + 1, y) ~= nil and self:getBlock(x + 1, y - 1) ~= nil then
			if self:getBlock(x + 1, y) ~= self:getBlock(x + 1, y - 1) then
				if self:getBlock(x + 1, y - 1).colour == colour then
					table.insert(contiguous, self:getBlock(x + 1, y - 1) )
				end
			end
		end
		
		-- The block left
		if x - 1 > 0 and self:getBlock(x - 1, y) ~= nil then
			if self:getBlock(x - 1, y).colour == colour then
				table.insert(contiguous, self:getBlock(x - 1, y) )
			end
		end

		-- The block left, one down
		if x - 1 > 0 and y - 1 > 0 and self:getBlock(x - 1, y - 1) ~= nil and self:getBlock(x - 1, y) ~= nil then
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
		for k2, b in pairs(t) do
		end
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

function Game:actualSwitch(a, b)
	local aColumn = nil
	local bColumn = nil
	local aIndex = nil
	local bIndex = nil
	for _, column in ipairs(self.columns) do
		for k, block in ipairs(column) do
			if block == a then
				aColumn = column
				aIndex = k
			elseif block == b then
				bColumn = column
				bIndex = k
			end
		end
	end
	local tmp = b
	bColumn[bIndex] = a
	aColumn[aIndex] = tmp
	self.movesLeft = self.movesLeft - 1
end

function Game:switchBlocks(a, b)
	local x1, y1 = self:getLocation(a)
	local x2, y2 = self:getLocation(b)
	if y1 == y2 and a.half == b.half then
		if x1 == x2 - 1 then
			a.xOffset = -44
			b.xOffset = 44
			self.waitingOnPlayer = false
			self:actualSwitch(a, b)
		elseif x1 == x2 + 1 then
			a.xOffset = 44
			b.xOffset = -44
			self.waitingOnPlayer = false
			self:actualSwitch(a, b)
		end
	end
end

function Game:mouseClicked(x, y)
	if self.waitingOnPlayer then
		local x, y = self:convertScreenPosition(x, y)
		local block = self:getBlock(x, y)
		if block ~= nil then
			if self.blockSelected == nil then
				self.blockSelected = block
				block.selected = true
			else
				self:switchBlocks(self.blockSelected, block)
				self.blockSelected.selected = false
				self.blockSelected = nil
			end
		end
	end
end
