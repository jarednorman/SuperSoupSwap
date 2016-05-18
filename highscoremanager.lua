module(..., package.seeall)

HighscoreManager = class("HighscoreManager")

local Highscores

function HighscoreManager:initialize()
	if not love.filesystem.exists( 'Highscores.lst' ) then
		love.filesystem.newfile( 'Highscores.lst' )
	
	else
		Highscores = love.filesystem.load( 'Highscores.lst' )
	end

	--Load highscores from file
	--Create file if it does no exist
end

function HighscoreManager:getAverageScore()
	local highscores = {}
	local average = 0

	for line in love.filesystem.lines("Highscores.lst") do
		  table.insert( highscores, string.gmatch(line, "%d+") )
	end
	
	for i, score in pairs(highscores) do 
		average = average + score
	end

	average = average / #highscores

	return average

end

function HighscoreManager:getMedianScore()
	local highscores = {}

	for line in love.filesystem.lines("Highscores.lst") do
		  table.insert( highscores, string.gmatch(line, "%d+") )
	end

	table.sort(highscores)

	return highscores[ (#highscores / 2) % 1 ]
end

function HighscoreManager:getHighscores(n)
	local highscores = {}
	local nScores = {}

	for line in love.filesystem.lines("Highscores.lst") do
		  table.insert( highscores, string.gmatch(line, "%d+") )
	end

	table.sort(highscores)

	for i = #highscores, #highscores - n, -1 do
		table.insert(nscores, highscores[i])
	end

	return nscores
end

function HighscoreManager:writeOut()
end

