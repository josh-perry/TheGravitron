-- main.lua

require('kikito-middleclass')
require('Player')
require('Obstacle')
require('Utility') -- Collisions
require('SpawnBullets') -- Bullet spawning functions

DoOnce = false

function love.load()
	Player.Vel = {X = 0, Y = 350}
	
	if DoOnce == false then
		--love.audio.play(Moosics)
		Player = Player:new()
		Player.just_died = false
		RecordTime = 0
		Deaths = 0
		CurrentTime = -5

		Arrow = love.graphics.newImage("data/gfx/Arrow.png")
		Blip = love.audio.newSource("data/sfx/blip.ogg", "static")
		Hit = love.audio.newSource("data/sfx/ow.ogg", "static")
		Moosics = love.audio.newSource("data/moosics/Doomed (Cube Edition).mp3", "stream")
		NewRecord = love.audio.newSource("data/sfx/record.ogg", "static")
		
		Moosics:setLooping(true)
		ScoreFont = love.graphics.newFont("data/fonts/04B_03__.TTF", 32)
		BigFont = love.graphics.newFont("data/fonts/04B_03__.TTF", 72)
		love.graphics.setFont(ScoreFont)

		BounceLines = {}
		BackgroundSquares = {}

		love.audio.play(Moosics)
		DoOnce = true
	else
		CurrentTime = 1
		Player.Pos.X = 400 - Player.Graphic:getWidth()/2
		Player.Pos.Y = 300 - Player.Graphic:getHeight()/2
	end
	
	local BounceTop = {}
	BounceTop.Y = 100
	table.insert(BounceLines, BounceTop)
	
	local BounceBottom = {}
	BounceBottom.Y = 500
	table.insert(BounceLines, BounceBottom)
	
	Obstacles = {}
	
	Obstacle_Def =
	{
		Graphic = love.graphics.newImage("data/gfx/Square.png")
	}
	
	Background = {r = math.random(1, 20), g = math.random(1, 20), b = math.random(1, 20)}
	
	Square_Def = 
	{
		x = 400,
		y = 300,
		h = 0,
		w = 0
	}
	
	Started = false
	SpawnTime = 1
	SquareTime = 0
	SquareCount = 0
	BGChangeTime = 0
	NewRecordSet = false

	if RecordTime ~= 0 then
		RecordSoundPlayed = false
	else
		RecordSoundPlayed = true
	end
end

function love.update(dt)
	if Player.Pos.Y <= 90 then
		Player.Pos.Y = 100 + 1
	elseif Player.Pos.Y >= 510 then
		Player.Pos.Y = 500 - (1 + Player.Graphic:getHeight())
	end

	CurrentTime = CurrentTime + dt
	CurrentTime = math.floor(CurrentTime * math.pow(10, 2) + 0.5) / math.pow(10, 2) -- Rounds score to 2 decimal places
	SquareTime = SquareTime + dt
	BGChangeTime = BGChangeTime + dt
	
	if CurrentTime > RecordTime then
		NewRecordSet = true
		
		if RecordSoundPlayed == false then
			love.audio.play(NewRecord)
			RecordSoundPlayed = true
		end
	end
	
	if BGChangeTime > 2 then
		BGChangeTime = 0
		Background = {r = math.random(1, 20), g = math.random(1, 20), b = math.random(1, 20)}
	end
	
	if SquareTime > 0.5 then
		SquareTime = 0
		SquareCount = SquareCount + 1
		
		local Square = {}
		Square.w = 0
		Square.h = 0
		Square.x = 400
		Square.y = 300
		Square.r = math.random(1, 20)
		Square.g = math.random(1, 20)
		Square.b = math.random(1, 20)
		Square.SquareCount = SquareCount

		if Player.just_died then
			Square.death = true
			Player.just_died = false
		end

		table.insert(BackgroundSquares, Square)
	end
	
	for i,v in ipairs(BackgroundSquares) do
		v.w = v.w + 200 * dt
		v.h = v.h + 200 * dt
		v.x = v.x - 100 * dt
		v.y = v.y - 100 * dt
		
		if v.w > 1400 then
			table.remove(BackgroundSquares, i)
		end
	end
	
	if Started == false and CurrentTime > 0 then
		Started = true
	end
	
	if Started then
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			Player.Vel.X = Player.Vel.X - Player.Speed
		elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			Player.Vel.X = Player.Vel.X + Player.Speed
		end
		
		Player:update(dt)

		for i,v in ipairs(BounceLines) do
			if CheckCollision(0, v.Y, 800, 1, Player.Pos.X, Player.Pos.Y, Player.Graphic:getWidth(), Player.Graphic:getHeight()) then
				if Player.Vel.Y > 0 then
					Player.Pos.Y = v.Y - Player.Graphic:getHeight()
				else
					Player.Pos.Y = v.Y + Player.Graphic:getHeight()
				end
				
				Player.Vel.Y = Player.Vel.Y - Player.Vel.Y*2
				love.audio.play(Blip)
			end
		end
		
		SpawnTime = SpawnTime - 1
		
		if SpawnTime <= 0 then
			TempGen = math.random(1, 70)
	
			if TempGen <= 30 and TempGen >= 0 then -- Stray
				SpawnStray()
			elseif TempGen <= 35 and TempGen >= 31 then -- 3 at once
				SpawnThreeAtOnce()
			elseif TempGen <= 40 and TempGen >= 46 then -- Stream
				SpawnStream()
			elseif TempGen <= 56 and TempGen >= 51 then
				SpawnTwoAtOnce()
			else
				SpawnTime = 0
			end
			
			SpawnTime = SpawnTime / 5
		end
		
		for i,v in ipairs(Obstacles) do
			v:update(dt)
			
			if CheckCollision(Player.Pos.X, Player.Pos.Y, Player.Graphic:getWidth(), Player.Graphic:getHeight(), v.Pos.X, v.Pos.Y, v.Graphic:getWidth(), v.Graphic:getHeight()) then
				kill_player()
			end
			
			if v.Pos.X < 0 and v.Vel.X < 0 then
				table.remove(Obstacles, i)
			elseif v.Pos.X > 800 and v.Vel.X > 0 then
				table.remove(Obstacles, i)
			end
		end
		
	else
		Player.Pos.X = 400 - Player.Graphic:getWidth()/2
		Player.Pos.Y = 300 - Player.Graphic:getHeight()/2
	end
end

function love.draw()
	for i,v in ipairs(BackgroundSquares) do
		love.graphics.setColor(Background.r, Background.g, Background.b)
			
		if v.SquareCount % 2 == 0 then -- Every second square is a lighter shade
			love.graphics.setColor(Background.r + 10, Background.g + 10, Background.b + 10)
		end

		if v.death then
			love.graphics.setColor(Background.r + 25, Background.g + 10, Background.b + 10)
		end

		love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
		love.graphics.setColor(255, 255, 255)
	end

	Player:draw()
	
	for i,v in ipairs(Obstacles) do
		love.graphics.setColor(Background.r + 150, Background.g + 150, Background.b + 150)
		v:draw()
		love.graphics.setColor(255, 255, 255)
		
		if v.Pos.X < 0 and v.Pos.X > -200 then
			love.graphics.draw(Arrow, 10, v.Pos.Y)
		elseif v.Pos.X > 800 and v.Pos.X < 1000 then
			love.graphics.draw(Arrow, 800-10-Arrow:getWidth()*2, v.Pos.Y, 0, -1, 1, v.Graphic:getWidth())
		end
	end
	
	love.graphics.setColor(Background.r + 200, Background.g + 200, Background.b + 200)
	for i,v in ipairs(BounceLines) do
		love.graphics.line(0, v.Y, 800, v.Y)
	end
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, 800, 100)
	love.graphics.rectangle("fill", 0, 500, 800, 100)	
	love.graphics.setColor(255, 255, 255)
	
	if CurrentTime > 0 then
		love.graphics.print("Time: "..string.format("%.2f", CurrentTime), 10, 10)
	else
		love.graphics.print("Time: -", 10, 10)
	end
	
	love.graphics.print("Deaths: "..Deaths, 600, 10)
	
	if NewRecordSet then
		love.graphics.setColor(0, 255, 0) -- Set text to green
	end
	
	if RecordTime > 0 then
		love.graphics.print("Record: "..RecordTime, 10, 40)
	else
		love.graphics.print("Record: -", 10, 40)
	end
	love.graphics.setColor(255, 255, 255) 
	if Started == false and CurrentTime < 0 then
		TempCurrentTime = -CurrentTime -- Make Positive
		love.graphics.setFont(BigFont)
		
		if TempCurrentTime ~= 0 then
			love.graphics.print(string.format("%.0f", TempCurrentTime), 375, 255)
		else
			love.graphics.print("GO", 355, 255)
		end
		love.graphics.setFont(ScoreFont)
	end
end

function kill_player()
	love.audio.play(Hit)
	if CurrentTime > RecordTime then
		RecordTime = CurrentTime
	end
	Deaths = Deaths + 1
	Player.just_died = true
	love.load()
end

function love.quit()
end