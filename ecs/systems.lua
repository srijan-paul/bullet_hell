local Components = require 'ecs/components'
local Transform = Components.Transform
local AnimatedSprite = Components.AnimatedSprite
local Velocity = Components.Velocity
local Systems = {}

-- *Animation system

Systems.AnimationSystem = Concord.system({Transform, AnimatedSprite})

function Systems.AnimationSystem:update(dt)
    for _, e in ipairs(self.pool) do 
        local anim = e[AnimatedSprite]
        anim.current:update(dt)
    end
end

function Systems.AnimationSystem:draw()
    for _, e in ipairs(self.pool) do
        local t = e[Transform]
        local anim = e[AnimatedSprite]
        love.graphics.setColor(1, 1, 1, 1)
        anim.current:draw(t.pos.x, t.pos.y, t.rotation, t.scale.x, t.scale.y)
    end
end

-- *Move system

Systems.MoveSystem = Concord.system({Transform, Velocity})
function Systems.MoveSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local t = e[Transform]
        local v = e[Velocity]
        t.pos = t.pos + dt * v.velocity
    end
end


return Systems
