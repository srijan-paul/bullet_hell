local Grid = require 'world/grid'
local Collider = require 'component/collider'
local World = Class('World')

local TIME_STEP = 0.016

function World:init(width, height)
    self.width = width or 400
    self.height = height or 400
    self.drawables = {}
    self.entities = {}
    self.grid = Grid(self, 5, 5)
    self.time_elapsed = 0
end

function World:draw()
    self.grid:draw()
    for i = 1, #self.drawables do
        self.drawables[i]:draw()
    end


    -- * DEBUG CODE
    graphics.setColor(1, 0, 0, 1)

    for i = 1, #self.entities do
        if self.entities[i]:has_component(Collider) then
            self.entities[i]:get_component(Collider):draw()
        end
    end

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
    for i = 1, #self.entities do 
        local e = self.entities[i]
        e:_physics_process(dt)
    end
end


function World:add_drawable(d)
    -- TODO: after depth sorting, change this logic
    --  to insert in sorted array
    self.drawables[#self.drawables + 1] = d
end

function World:add_ent(e)
    self.entities[#self.entities + 1] = e
end

return World