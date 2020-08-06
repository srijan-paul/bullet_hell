local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Corpse = Class('Corpse', GameObject)

function Corpse:init(world, x, y, rotation, image, velocity, dist)
    GameObject.init(self, world, x, y)
    self.velocity = velocity
    self.distance_to_cover = dist
    self:set_rotation(rotation)
    self:add_component(cmp.Sprite, image)
    self:add_component(cmp.Collider, 10, 10, 'corpse')
end

function Corpse:_physics_process(dt)
    if self.distance_to_cover >= 0 then
        local pos = self:get_pos()
        self:move(self.velocity * dt)
        self.distance_to_cover = self.distance_to_cover - (pos - self:get_pos()):mag()
    end
end

function Corpse:on_world_exit()
    self.velocity = self.velocity * -1
end


return Corpse