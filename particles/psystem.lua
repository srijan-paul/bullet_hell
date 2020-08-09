local Transform = require 'component/common'
local PSpawner = require 'particles/pemitter'

local PSystem = Class('ParticleSystem')


function PSystem:init(pos, properties)
    properties = properties or {}
    self.pos = pos
    self.emitter = PSpawner(pos, properties)
    self.particles = {}
    self.spawn_rate = properties.spawn_rate or 1
    self.spawn_time_elapsed = 0
    self.active = true
end

function PSystem:configure(properties)
    self.spawn_rate = properties.spawn_rate or 1
    self.emitter:configure(properties)
end

function PSystem:set_velocity(v)
    self.emitter.velocity = v:clone()
end

function PSystem:set_angular_speed(dtheta)
    self.emitter.angular_speed = dtheta
end


function PSystem:draw()
    sugar.foreach(self.particles, function (p)
        p:draw()
    end)
end

function PSystem:update(dt)

    if self.follow_target then
        self.emitter.pos = self.follow_target:get_pos()
    end

    if self.active then
        self.spawn_time_elapsed = self.spawn_time_elapsed + dt

        if self.spawn_time_elapsed >= self.spawn_rate then
            self.spawn_time_elapsed = 0
            self:emit()
        end
    end


    self.emitter:update(dt)

    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p:update(dt)
        if p.life_span <= 0 then
            table.remove(self.particles, i)
        end
    end
end

function PSystem:emit()
    table.insert(self.particles, self.emitter:emit())
end

function PSystem:delete()
    self.particles = nil
end

function PSystem:move_to(pos)
    self.emitter.pos = pos:clone()
end

function PSystem:attach_to(gameobj)
    self.follow_target = gameobj
end

function PSystem:pause()
    self.active = false
end

function PSystem:resume()
    self.active = true
end

return PSystem