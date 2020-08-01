local cmp = require 'component/common'
local GameObject = require 'prefabs/gameobject'

local Enemy = Class('Enemy', GameObject)

function Enemy:init(world, x, y, properties)
    GameObject.init(self, world, x, y)
    self:add_component(cmp.Collider, properties.collider_width or 10,
                       properties.collider_height or 10, 'enemy')
    -- range within which it can detect the player
    self.detect_range = properties.detect_range
    self.health = properties.health or 1
    self.stats = properties.stats or {}
end


-- TODO: apply stats
function Enemy:damage(amount)
    self.health = self.health - amount
    if self.health <= 0 then self:death() end
end

function Enemy:death()
    --TODO
end

return Enemy