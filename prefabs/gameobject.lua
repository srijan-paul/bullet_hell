local GameObject = Class('GameObject')
local Transform = require('component.transform')

function GameObject:init(x, y, r, sx, sy)
    self[Transform] = Transform(x, y, r, sx, sy)
end

function GameObject:add_component(comp, ...)
    assert(not self[comp], 'component already exists on game object')
    self[comp] = comp(...)
end

return GameObject