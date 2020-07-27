local Grid = require 'world/grid'
local cmp = require 'component/common'
local World = Class('World')

local TIME_STEP = 0.016

function World:init(width, height)
    self.width = width or 200
    self.height = height or 200
    self.drawables = {}
    self.colliders = {}
    self.entities = {}
    self.grid = Grid(self, 5, 5)
    self.time_elapsed = 0
end

function World:draw()

    for i = 1, #self.drawables do
        self.drawables[i]:draw()
    end


    -- * DEBUG CODE
    -- self.grid:draw()

    -- graphics.setColor(1, 0, 0, 1)

    -- for i = 1, #self.colliders do
    --     self.colliders[i]:draw()
    -- end

    graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 0, 0, self.width, self.height)
    -- * / DEBUG CODE
end


function World:update(dt)
    self.time_elapsed = self.time_elapsed + dt
    for i = 1, #self.entities do
        self.entities[i]:update(dt)
    end
    while self.time_elapsed >= TIME_STEP do
        self:_physics_process(self.time_elapsed)
        self.time_elapsed = self.time_elapsed - TIME_STEP
    end
end


function World:_physics_process(dt)

    self.grid:clear()

    for i = 1, #self.entities do 
        local e = self.entities[i]
        e:_physics_process(dt)
    end

    for i = 1, #self.colliders do
        self.grid:insert(self.colliders[i])
    end
end


function World:add_drawable(d)
    -- TODO: after depth sorting, change this logic
    --  to insert in sorted array
    self.drawables[#self.drawables + 1] = d
end


function World:add_collider(c)
    self.colliders[#self.colliders + 1] = c
end

function World:add_entity(e)
    -- TODO: register and handle collision classes as well
    self.entities[#self.entities + 1] = e
end

return World