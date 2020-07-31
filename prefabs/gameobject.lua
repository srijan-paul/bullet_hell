local GameObject = Class('GameObject')
local Transform = require('component/transform')


function GameObject:init(world, x, y, r, sx, sy)
    self.world = world
    self._components = {}
    self._cmp_map = {}
    self:add_component(Transform, x, y, r, sx, sy)
    world:add_gameobject(self)
end


function GameObject:add_component(comp, ...)
 -- TODO: assert component doesn't already exist
    local c = comp(self, ...)
    self._components[#self._components + 1] = c
    self._cmp_map[comp] = #self._components
    return c
end


function GameObject:get_component(cmp)
    return self._components[self._cmp_map[cmp]]
end


function GameObject:has_component(cmp)
    return self._cmp_map[cmp] ~= nil
end


function GameObject:update(dt)
    for i = 1, #self._components do
        local c = self._components[i]
        if c.update then
            c:update(dt)
        end
    end
end

-- to be overidden
function GameObject:_physics_process(dt)
    -- body
end


function GameObject:delete()
    self.world:remove_gameobject(self)
    for k, v in pairs(self._components) do
        if v.delete then
            v:delete()
        end
        self._components[k] = nil
    end
end


function GameObject:get_pos()
    return self:get_component(Transform).pos:clone()
end


function GameObject:set_pos(p)
    self:get_component(Transform).pos = p:clone()
end

function GameObject:get_scale()
    return self:get_component(Transform).scale
end

function GameObject:set_scale(sx, sy)
    self:get_component(Transform).scale = Vec2(sx, sy)
end

function GameObject:rotation()
    return self:get_component(Transform).rotation
end

function GameObject:set_rotation(r)
    self:get_component(Transform).rotation = r
end

function GameObject:rotate(angle)
    local t = self:get_component(Transform)
    t.rotation = t.rotation + angle
end

function GameObject:move(velocity)
    local t = self:get_component(Transform)
    t.pos = t.pos + velocity
end

return GameObject