local cmp = require 'component/common'
local GameObject = require 'prefabs/gameobject'
local Corpse = require 'prefabs/enemies/corpse'

local Enemy = Class('Enemy', GameObject)

local KNOCKBACK_SPEED = 80

function Enemy:init(world, x, y, properties)
  GameObject.init(self, world, x, y)
  self:add_component(cmp.Collider, properties.collider_width or 10,
                     properties.collider_height or 10, 'enemy')
    :add_masks('tile')
  -- range within which it can detect the player
  self.id = 'enemy'
  self.detect_range = properties.detect_range
  self.max_health = properties.health or 1
  self.current_health = self.max_health
  self.stats = properties.stats or {}
  self.corpse_sprite = properties.corpse
  self.knock_velocity = Vec2(0, 0)
end

-- TODO: apply stats
-- *amount (number)= damage amount
-- *source_pos (Vec2) = location where the damage came from (to apply knockback)
-- *knockback (number) = magnitude of knockback (distance)

function Enemy:damage(amount, source_pos, knockback)
  Resource.Sound.EnemyHurt:play()
  self.current_health = self.current_health - amount
  self.knock_velocity = (self:get_pos() - source_pos):with_mag(KNOCKBACK_SPEED)
  self.knock_dist = knockback
  if self.current_health <= 0 then self:death() end
end

function Enemy:death()
  local pos = self:get_pos()
  if self.corpse_sprite then
    Corpse(self.world, pos.x, pos.y, self:rotation(), self.corpse_sprite,
           self.knock_velocity, self.knock_dist)
  end
  self:delete()
end

return Enemy
