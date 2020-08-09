local Particle = require 'particles/particle'
local PEmitter = Class('PEmitter')

function PEmitter:init(pos, properties)
    self.pos = pos:clone()
    self:configure(properties)
end

function PEmitter:configure(properties)
    self.velocity = properties.velocity and properties.velocity:clone() or
                        Vec2(0, 0)
    self.angular_speed = properties.angular_speed or 0
    self.spread = properties.spread or 0
    self.min_speed = properties.speed or properties.min_speed or 0
    self.max_speed = properties.speed or properties.max_speed or 0
    self.radius = properties.radius or 5
    self.rotation = properties.rotation or 0
    self.spread = properties.spread or (2 * math.pi)
    self.p_velocity = properties.particle_velocity and
                          properties.particle_velocity:clone() or Vec2(0, 0)
    self.p_randomness = properties.particle_vel_randomness or 0
    self.p_life_span = properties.particle_life or 1
end

function PEmitter:_get_spawn_loc()
    local r = random() * self.radius
    local theta = self.rotation + random() * self.spread
    return self.pos + Vec2.from_polar(r, theta)
end

function PEmitter:_get_velocity()
    local x, y = self.p_velocity.x, self.p_velocity.y
    local dx = -self.p_randomness * x + random() * self.p_randomness * x * 2
	local dy = -self.p_randomness * y + random() * self.p_randomness * y * 2
	return Vec2:new(x + dx, y + dy)
end

function PEmitter:emit()
    local spawn_pos = self:_get_spawn_loc()

    return Particle(spawn_pos, self:_get_velocity(), self.p_life_span)
end

function PEmitter:update(dt)
    self.pos = self.pos + self.velocity * dt
    self.rotation = self.rotation + self.angular_speed * dt
end

return PEmitter
