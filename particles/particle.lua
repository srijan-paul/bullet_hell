local Particle = Class('Particle')

function Particle:init(pos, vel, span)
    self.pos = pos
    self.velocity = vel
    self.life_span = span
    self.alpha = 1
end

function Particle:draw()
    lg.setColor(1, 1, 0, self.alpha)
    lg.circle('fill', self.pos.x, self.pos.y, 1)
end

function Particle:update(dt)
    self.alpha = self.alpha - dt
    self.pos = self.pos + self.velocity * dt
    self.life_span = self.life_span - dt
end

return Particle