local GameObject = require 'prefabs/gameobject'
local Effects = require 'prefabs/effects/effecttype'
local Effect = require 'prefabs/effects/effect'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)

function Projectile:init(owner, ptype, target, speed, mask, ...)
    GameObject.init(self, ...)
    self.owner = owner
    self.world = self.owner.world
    self:add_component(cmp.Drawable, ptype.render())
    local collider = self:add_component(cmp.Collider, ptype.width, ptype.height,
                                        'projectile', Vec2(ptype.width / 2, 0))
    collider:add_mask(mask)
    local dir = target - self:get_pos()
    self:get_component(cmp.Transform).rotation = dir:angle()
    self.velocity = dir:with_mag(speed)
    self.damage = ptype.damage
end

function Projectile:_physics_process(dt)
    self:set_pos(self:get_pos() + self.velocity * dt)
end

function Projectile:on_collide(target)
    local x, y = target:get_pos():unpack()
    Effect(self.world, x, y, Effects.Block, 0.1)
    self:delete()
end

function Projectile:delete()
    self.world:remove_gameobject(self)
    self.world:remove_drawable(self:get_component(cmp.Drawable))
end

function Projectile:on_world_exit() self:delete() end

return Projectile
