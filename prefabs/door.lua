local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Door = Class('Door', GameObject)

local DOOR_WIDTH, DOOR_HEIGHT = 20, 20

function Door:init(world, x, y, dir)
  GameObject.init(self, world, x, y)
  self.dir = dir
  self:add_component(cmp.Collider, DOOR_WIDTH, DOOR_HEIGHT)
  self:get_component(cmp.Collider):add_mask('player')
  self:add_component(cmp.Sprite, Resource.Image.Door)
  self.level = world.level
end

-- only detects collisions with the player anyway so no args
function Door:on_collide()
  -- TODO: add shaders and effects and all that stuff
  self.level:switch_world((self.dir))
end

return Door

