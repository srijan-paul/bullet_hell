local Particle = require 'particles/particle'
local PEmitter = Class('PEmitter')

function PEmitter:init(pos, properties)
    self.pos = pos
    self.velocity = properties.velocity and properties.velocity:clone() or Vec2(0, 0)
    self.angular_speed = properties.angular_speed or 0
    self.spread = properties.spread or 0
    self.min_speed = properties.speed or properties.min_speed or 0
    self.max_speed = properties.speed or properties.max_speed or 0
    self.spawn_radius = properties.spawn_radius or 5
    self.rotation = properties.rotation or 0
end

function PEmitter:get_spawn_loc() end

function PEmitter:emit()
    local spawn_pos = self:get_spawn_loc()
    local speed = self.min_speed + math.random() *
                      (self.max_speed - self.min_speed)
    return Particle(spawn_pos)
end

function PEmitter:update(dt)
    self.pos = self.pos + self.velocity * dt
    self.rotation = self.rotation + self.angular_speed * dt
end

return PEmitter
