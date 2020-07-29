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


function World:bounds_check(e)
    if not e:has_component(cmp.Collider)then return end

    local collider = e:get_component(cmp.Collider)
    local pos = collider:get_pos()

    -- TODO: account for collider dimensions
    if pos.x < 0 or pos.x > self.width or
         pos.y > self.height or pos.y < 0 then
            pos.x = sugar.clamp(pos.x, 0, self.width)
            pos.y = sugar.clamp(pos.y, 0, self.height)
            if collider.owner.on_world_exit then
                collider.owner:on_world_exit()
                return
            end
    end
end


function World:_physics_process(dt)
    self.grid:clear()

    for i = #self.entities, 1, -1 do
        local e = self.entities[i]

        if self.entities[i]:has_component(cmp.Collider) then
            self.grid:insert(self.entities[i]:get_component(cmp.Collider))
        end
        e:_physics_process(dt)
        self:bounds_check(e)
    end

    self.grid:process_collisions()
end


function World:add_drawable(d)
    -- TODO: after depth sorting, change this logic
    --  to insert in sorted array
    table.insert(self.drawables, d)
end

function World:add_gameobject(e)
    -- TODO: register and handle collision classes as well
    e.world = self
    table.insert(self.entities, e)
end
function World:remove_drawable(d)
    local index = sugar.index_of(self.drawables, d)
    table.remove(self.drawables, index)
end

function World:remove_gameobject(g)
    local index = sugar.index_of(self.entities, g)
    table.remove(self.entities, index)
end

return World