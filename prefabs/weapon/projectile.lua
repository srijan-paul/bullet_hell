local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)
Projectile.Type = require 'prefabs/weapon/projectiletype'

function Projectile:init(owner, ptype, properties, ...)
  GameObject.init(self, ...)
  self.owner = owner
  self.type = ptype

  self:set_scale(ptype.sx or 1, ptype.sy or 1)
  ptype.add_render(self)
  local collider = self:add_component(cmp.Collider, ptype.width, ptype.height,
                                      'projectile', Vec2(ptype.width / 2, 0))
  for i = 1, #properties.mask do collider:add_mask(properties.mask[i]) end
  collider:add_mask('tile')

  local dir = properties.target - self:get_pos()

  self:set_rotation(dir:angle())
  self.velocity = dir:with_mag(properties.speed or 0)
  self.damage = properties.damage or 0
  self.knockback = properties.knockback or 0

  if ptype.on_tile_collide then self.on_tile_collide = ptype.on_tile_collide end

end

function Projectile:_physics_process(dt)
  self:set_pos(self:get_pos() + self.velocity * dt)
end

function Projectile:on_collide(target)
  local x, y = target:get_pos():unpack()
  target:damage(self.damage, self:get_pos(), self.knockback)

  if self.type.destroy_effect then self.type.destroy_effect(self.world, x, y) end
  self:delete()
end

function Projectile:on_tile_collide()
  self:on_world_exit()
end

function Projectile:on_world_exit()
  self.type.tile_hit_sound:play()
  if self.type.destroy_effect then
    self.type.destroy_effect(self.world, self:get_pos():unpack())
  end
  self:delete()
end

return Projectile
