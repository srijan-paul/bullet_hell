local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)

function Projectile:init(owner, ptype, target, speed, ...)
    GameObject.init(self, ...)
    self.owner = owner
    self:add_component(cmp.Drawable, ptype.render())
    self:add_component(cmp.Collider, ptype.width, ptype.height, 'projectile',
                       Vec2(ptype.width , 0))
    local dir = target - self:get_pos()
    self:get_component(cmp.Transform).rotation = dir:angle()
    self.velocity = dir:with_mag(speed)
    self.damage = ptype.damage
end

function Projectile:_physics_process(dt)
    self:set_pos(self:get_pos() + self.velocity * dt)
end

function Projectile:on_collide(target)
    -- body
end

function Projectile:on_world_exit()
    self:delete()
end

return Projectile
