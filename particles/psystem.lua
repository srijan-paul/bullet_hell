local PSpawner = require 'particles/pspawner'

local PSystem = Class('ParticleSystem')


function PSystem:init(pos, properties)
    self.pos = pos
    self.emitter = PSpawner(pos, properties)
    self.particles = {}
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
    self.emitter:update(dt)
    sugar.foreach(self.particles, function (p)
        p:update(dt)
    end)
end

return PSystem