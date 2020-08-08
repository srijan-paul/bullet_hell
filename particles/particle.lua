local Particle = Class('Particle')

function Particle:init(pos, vel, span)
    self.pos = pos
    self.velocity = vel
    self.life_span = span
end

function Particle:draw()
    
end

function Particle:update(dt)
    self.pos = self.pos + self.vel * dt
    self.life_span = self.life_span - dt
end

return Particle