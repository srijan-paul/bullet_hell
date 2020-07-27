local GameObject = Class('GameObject')
local Transform = require('component/transform')


function GameObject:init(world, x, y, r, sx, sy)
    self.world = world
    self._components = {}
    self._components[Transform] = Transform(self, x, y, r, sx, sy)
    world:add_entity(self)
end


function GameObject:add_component(comp, ...)
    assert(not self[comp], 'component already exists on game object')
    self._components[comp] = comp(self, ...)
end


function GameObject:get_component(cmp)
    return self._components[cmp]
end


function GameObject:has_component(cmp)
    return self._components[cmp] ~= nil
end


function GameObject:update(dt)
    for _, c in pairs(self._components) do
        if c.update then
            c:update(dt)
        end
    end
end

-- to be overidden
function GameObject:_physics_process(dt)
    -- body
end


function GameObject:get_pos()
    return self:get_component(Transform).pos
end

function GameObject:get_scale()
    return self:get_component(Transform).scale
end

return GameObject