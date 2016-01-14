-- Player.lua

Player = class('Player')

function Player.initialize(this)
	this.Pos = {X = 400, Y = 300}
	this.Vel = {X = 0, Y = 350}
	this.Graphic = love.graphics.newImage("data/gfx/Player.png")
	this.Speed = 200
	this.MaxVel = {Y = 350, X = 400}
end

function Player.draw(this)
	love.graphics.draw(this.Graphic, this.Pos.X, this.Pos.Y)
end

function Player.update(this, dt)
	-- X friction
	if this.Vel.X > 0.1 then
		this.Vel.X = this.Vel.X - 25
	elseif this.Vel.X < -0.1 then
		this.Vel.X = this.Vel.X + 25
	else
		this.Vel.X = 0
	end

	if this.Vel.X > this.MaxVel.X then
		this.Vel.X = this.MaxVel.X
	elseif this.Vel.X < -this.MaxVel.X then
		this.Vel.X = -this.MaxVel.X
	end
	
	if this.Vel.Y > this.MaxVel.Y then
		this.Vel.Y = this.MaxVel.Y
	elseif this.Vel.Y < -this.MaxVel.Y then
		this.Vel.Y = -this.MaxVel.Y
	end

	-- Movement
	this.Pos.X = this.Pos.X + (this.Vel.X * dt)
	this.Pos.Y = this.Pos.Y + (this.Vel.Y * dt)
	
	if this.Pos.X < 0 then
		this.Pos.X = 800
	elseif this.Pos.X > 800 then
		this.Pos.X = 0
	end
end