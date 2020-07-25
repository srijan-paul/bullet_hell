local GameObject = require 'prefabs.gameobject'

local Player = Class('Player', GameObject)

function Player:init(world, x, y)
    GameObject.init(self, world, x, y)
end

return Player