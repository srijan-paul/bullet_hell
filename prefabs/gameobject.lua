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
    self._components[#self._components + 1] = comp(self, ...)
    self._cmp_map[comp] = #self._components
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
    return self:get_component(Transform).pos
end


function GameObject:set_pos(p)
    self:get_component(Transform).pos = p
end

function GameObject:get_scale()
    return self:get_component(Transform).scale
end

function GameObject:set_scale(sx, sy)
    self:get_component(Transform).scale = Vec2(sx, sy)
end

return GameObject