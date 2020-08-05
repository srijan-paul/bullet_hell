local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)

function Projectile:init(owner, ptype, properties, ...)
    GameObject.init(self, ...)
    self.owner = owner
    self.type = ptype

    self:set_scale(ptype.sx or 1, ptype.sy or 1)
    self:add_component(cmp.Drawable, ptype.render())
    local collider = self:add_component(cmp.Collider, ptype.width, ptype.height,
                                        'projectile', Vec2(ptype.width / 2, 0))
    collider:add_mask(properties.mask or '')

    local dir = properties.target - self:get_pos()

    self:set_rotation(dir:angle())
    self.velocity = dir:with_mag(properties.speed or 0)
    self.damage = properties.damage or 0
    self.knockback = properties.knockback or 0
end

function Projectile:_physics_process(dt)
    self:set_pos(self:get_pos() + self.velocity * dt)
end

function Projectile:on_collide(target)
    local x, y = target:get_pos():unpack()
    target:damage(self.damage, self:get_pos(), self.knockback)

    if self.type.destroy_effect then
        self.type.destroy_effect(self.world, x, y)
    end
    self:delete()
end

function Projectile:delete()
    self.world:remove_gameobject(self)
    self.world:remove_drawable(self:get_component(cmp.Drawable))
end

function Projectile:on_world_exit()
    if self.type.destroy_effect then
        self.type.destroy_effect(self.world, self:get_pos():unpack())
    end
    self:delete()
end

return Projectile
