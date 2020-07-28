local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)

function Projectile:init(owner, ptype, target, ...)
    GameObject.init(self, ...)
    self.owner = owner
    self:add_component(cmp.Drawable, ptype.render())
    self:add_component(cmp.Collider, self.world, ptype.width, ptype.height)
    local dir = target - self:get_pos()
    self:get_component(cmp.Transform).rotation = dir:angle()
    self.velocity = dir:with_mag(ptype.speed)
    self:set_scale(1.0, 1.0)
    Timer.tween(0.09, self:get_scale(), {x = 1.2, y = 1}, 'in-out-cubic')
end

function Projectile:update(dt)
    GameObject.update(self, dt)
end

function Projectile:_physics_process(dt)
    self:set_pos(self:get_pos() + self.velocity * dt)
end

function Projectile:on_world_exit()
    self:delete()
end


return Projectile