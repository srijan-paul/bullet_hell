local GameObject = Class('GameObject')
local Transform = require('component/transform')


function GameObject:init(world, x, y, r, sx, sy)
    self.world = world
    self._components = {}
    self._components[Transform] = Transform(self, x, y, r, sx, sy)
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

return GameObject