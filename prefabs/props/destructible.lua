local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Destructible = Class('Barrel', GameObject)


function Destructible:init(world, x, y, dtype)
    GameObject.init(self, world, x, y)
    self:add_component(unpack(dtype.drawable))
    self:add_component(cmp.Collider, dtype.size[1], dtype.size[2], 'neutral')
    self.health = dtype.health
    self.type = dtype
end

function Destructible:damage(amount)
    self.type.on_damage(self, amount)
end

return Destructible