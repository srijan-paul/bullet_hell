local cmp = require 'component.common'
local GameObject = require 'prefabs.gameobject'

local Player = Class('Player', GameObject)

function Player:init(world, x, y)
    local a = GameObject.init(self, world, x, y)
    self:add_component(cmp.AnimatedSprite, Resource.Sprite.Player,
                       {{'idle', 1, 3, 0.1, true}, {'walk', 1, 3, 0.1, true}})
    self[cmp.AnimatedSprite]:play('idle')
end

return Player
