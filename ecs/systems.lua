local Components = require 'ecs/components'
local Transform = Components.Transform
local AnimatedSprite = Components.AnimatedSprite
local Systems = {}

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

return Systems
