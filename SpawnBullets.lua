-- SpawnBullets.lua

function SpawnTwoAtOnce()
	local Direction = math.random(1, 2)
	
	local TempObstacle = Obstacle:new() -- Two at once
	
	if Direction == 1 then
		TempObstacle.Pos.X = -100
	else
		TempObstacle.Pos.X = 900
		TempObstacle.Vel.X = TempObstacle.Vel.X - (TempObstacle.Vel.X * 2)
	end
	
	TempObstacle.Pos.Y = 250
	TempObstacle.Vel.Y = 0
	TempObstacle.Graphic = Obstacle_Def.Graphic
	table.insert(Obstacles, TempObstacle)
	
	local TempObstacle = Obstacle:new()
	
	if Direction == 1 then
		TempObstacle.Pos.X = -100
	else
		TempObstacle.Pos.X = 900
		TempObstacle.Vel.X = TempObstacle.Vel.X - (TempObstacle.Vel.X * 2)
	end
	
	TempObstacle.Pos.Y = 350
	TempObstacle.Vel.Y = 0
	TempObstacle.Graphic = Obstacle_Def.Graphic
	table.insert(Obstacles, TempObstacle)
	SpawnTime = 100
end

function SpawnStray()
	local Direction = math.random(1, 2)
	local TempObstacle = Obstacle:new()
	
	TempObstacle.Pos.X = 0
	
	if Direction == 1 then
		TempObstacle.Pos.X = -100
	else
		TempObstacle.Pos.X = 900
		TempObstacle.Vel.X = TempObstacle.Vel.X - (TempObstacle.Vel.X * 2)
	end
	
	TempObstacle.Pos.Y = (math.random(2, 8) * 50) + 50
	TempObstacle.Vel.Y = 0
	TempObstacle.Graphic = Obstacle_Def.Graphic
	table.insert(Obstacles, TempObstacle)
	SpawnTime = 70
end

function SpawnThreeAtOnce()
	local Direction = math.random(1, 2)
	for i = 1, 3 do
		local TempObstacle = Obstacle:new()
		
		if Direction == 1 then
			TempObstacle.Pos.X = -100
		else
			TempObstacle.Pos.X = 900
			TempObstacle.Vel.X = TempObstacle.Vel.X - (TempObstacle.Vel.X * 2)
		end
		
		TempObstacle.Pos.Y = ((i + 1) * 100)
		TempObstacle.Vel.Y = 0
		TempObstacle.Graphic = Obstacle_Def.Graphic
		table.insert(Obstacles, TempObstacle)
	end

	SpawnTime = 140
end

function SpawnStream()
	local Direction = math.random(1, 2)
	Pos = math.random(1, 6)
	GoingUp = false
	NumberOfObstacles = math.random(5, 16)
	for i = 1, NumberOfObstacles do
		local TempObstacle = Obstacle:new()
		TempObstacle.Pos.X = 0 
		
		if Direction == 1 then
			TempObstacle.Pos.X = -100 - (i * 200)
		else
			TempObstacle.Pos.X = 900 + (i * 200)
			TempObstacle.Vel.X = TempObstacle.Vel.X - (TempObstacle.Vel.X * 2)
		end
		
		TempObstacle.Pos.Y = (Pos + 2) * 50
		TempObstacle.Vel.Y = 0
		TempObstacle.Graphic = Obstacle_Def.Graphic
		
		if GoingUp == false then
			Pos = Pos + 1
		else
			Pos = Pos - 1
		end
		
		if Pos > 6 then
			GoingUp = true
		elseif Pos <= 1 then
			GoingUp = false
		end
		table.insert(Obstacles, TempObstacle)
		SpawnTime = SpawnTime + 80
	end
end