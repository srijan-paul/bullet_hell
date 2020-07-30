local Grid = require 'world/grid'
local cmp = require 'component/common'
local WeaponSprite = require 'component/weapon_sprite'
local World = Class('World')

local TIME_STEP = 0.016

function World:init(level, width, height)
    self.level = level
    self.width = width or 200
    self.height = height or 200
    self.drawables = {}
    self.colliders = {}
    self.entities = {}
    self.grid = Grid(self, 5, 5)
    self.time_elapsed = 0
end

function World:draw()

    for i = 1, #self.drawables do self.drawables[i]:draw() end

    -- * DEBUG CODE
    -- self.grid:draw()

    -- graphics.setColor(1, 0, 0, 1)

    -- for i = 1, #self.entities do
    --     local e = self.entities[i]
    --     graphics.setColor(1, 0.1, 0.1)
    --     if e:has_component(cmp.Collider) then
    --         e:get_component(cmp.Collider):draw()
    --     end
    -- end

    graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 0, 0, self.width, self.height)
    -- * / DEBUG CODE
end

function World:update(dt)
    self.time_elapsed = self.time_elapsed + dt
    for i = 1, #self.entities do
        self.entities[i]:update(dt)
        self:bounds_check(self.entities[i])
    end
    while self.time_elapsed >= TIME_STEP do
        self:_physics_process(self.time_elapsed)
        self.time_elapsed = self.time_elapsed - TIME_STEP
    end
end

function World:bounds_check(e)
    if not e:has_component(cmp.Collider) then return end

    local collider = e:get_component(cmp.Collider)
    local pos = collider:get_pos()

    -- TODO: account for collider dimensions
    if pos.x < collider.width / 2 or pos.x > self.width - collider.width / 2 or
        pos.y > self.height - collider.height/ 2 or pos.y < collider.height / 2 then
        local p = Vec2(sugar.clamp(pos.x, collider.width / 2,
                                   self.width - collider.width / 2),
                       sugar.clamp(pos.y, collider.height / 2,
                                   self.height - collider.height / 2))
        e:set_pos(p)
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
        -- TODO refactor this out into a collider array
        if self.entities[i]:has_component(cmp.Collider) then
            self.grid:insert(self.entities[i]:get_component(cmp.Collider))
        end
        e:_physics_process(dt)
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

local function get_player_entry_pos(world, dir)
    if dir == Direction.LEFT then return Vec2(25, world.height / 2) end

    if dir == Direction.RIGHT then
        return Vec2(world.width - 25, world.height / 2)
    end

    if dir == Direction.UP then return Vec2(world.width / 2, 25) end

    if dir == Direction.DOWN then
        return Vec2(world.width / 2, world.height - 25)
    end

end

function World:player_enter(p, dir)
    self:add_gameobject(p)
    p:set_pos(get_player_entry_pos(self, dir))
    self:add_drawable(p:get_component(cmp.AnimatedSprite))
    self:add_gameobject(p.weapon)
    self:add_drawable(p.weapon:get_component(WeaponSprite))
end

function World:player_leave(p)
    self:remove_gameobject(p)
    self:remove_drawable(p:get_component(cmp.AnimatedSprite))
    self:remove_gameobject(p.weapon)
    self:remove_drawable(p.weapon:get_component(WeaponSprite))
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
