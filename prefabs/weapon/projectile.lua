local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)

function Projectile:init(owner, ptype, target, ...)
    GameObject.init(self, ...)
    self.owner = owner
    self:add_component(cmp.Sprite, Resource.Sprite[ptype.sprite_path])
    self:add_component(cmp.Collider, self.world, ptype.width, ptype.height)
    local dir = target - self:get_pos()
    self:get_component(cmp.Transform).rotation = dir:angle()
    self.velocity = dir:with_mag(ptype.speed)
    self:set_scale(1.5, 2)
    Timer.tween(0.05, self:get_scale(), {x = 1.4, y = 1.4}, 'in-out-cubic')
end

function Projectile:update(dt)
    GameObject.update(self, dt)
end

function Projectile:_physics_process(dt)
    self:set_pos(self:get_pos() + self.velocity * dt)
end


return Projectile