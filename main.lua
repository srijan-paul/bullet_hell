local Systems = require 'ecs/systems'
local Components = require 'ecs/components'

local world = Concord.world()
world:addSystems(Systems.AnimationSystem)

function love.load()
    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(0.96, 1, 0.95)

    Resource.load()

    local player = Concord.entity(world)
        :give(Components.Transform, 100, 100, 0, 4, 4)
        :give(Components.AnimatedSprite, Resource.Sprite.Player,
        {'idle', 1, 2, 0.2, true},
        {'walk', 3, 7, 0.1, true})
end

function love.draw()
    world:emit("draw")
end

function love.update(dt)
    world:emit("update", dt)
end
