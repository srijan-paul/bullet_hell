_G['graphics'] = love.graphics

-- Defining ComponentClasses
-- I use UpperCamelCase to indicate its a class
local Position = Concord.component(function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

local Velocity = Concord.component(function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

local Drawable = Concord.component()


-- Defining Systems
local MoveSystem = Concord.system({Position, Velocity})

function MoveSystem:update(dt)
    for _, e in ipairs(self.pool) do
        -- I use lowerCamelCase to indicate its an instance
        local position = e[Position]
        local velocity = e[Velocity]

        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt
    end
end


local DrawSystem = Concord.system({Position, Drawable})

function DrawSystem:draw()
    for _, e in ipairs(self.pool) do
        local position = e[Position]

        love.graphics.circle("fill", position.x, position.y, 5)
    end
end


-- Create the World
local world = Concord.world()

-- Add the Systems
world:addSystems(MoveSystem, DrawSystem)

-- This Entity will be rendered on the screen, and move to the right at 100 pixels a second
local entity_1 = Concord.entity(world)
:give(Position, 100, 100)
:give(Velocity, 100, 100)
:give(Drawable)

-- This Entity will be rendered on the screen, and stay at 50, 50
local entity_2 = Concord.entity(world)
:give(Position, 50, 50)
:give(Drawable)

-- This Entity does exist in the World, but since it doesn't match any System's filters it won't do anything
local entity_3 = Concord.entity(world)
:give(Position, 120, 200)
:give(Drawable)

-- Emit the events
function love.update(dt)
    world:emit('update', dt)
end

function love.draw()
    world:emit('draw')
end  
