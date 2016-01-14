-- Obstacle.lua

Obstacle = class('Obstacle')

function Obstacle.initialize(this)
	this.Pos = {X = 0, Y = 300}
	this.Vel = {X = 500, Y = 0}
	this.Graphic = nil
end

function Obstacle.draw(this)
	love.graphics.draw(this.Graphic, this.Pos.X, this.Pos.Y)
end

function Obstacle.update(this, dt)
	-- Movement
	this.Pos.X = this.Pos.X + (this.Vel.X * dt)
	this.Pos.Y = this.Pos.Y + (this.Vel.Y * dt)
end