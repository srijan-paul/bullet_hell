local camera = require 'camera'
local World = require 'world/world'
local Player = require 'prefabs/player'

local Room = Class('Room')
local ZOOM = 4.8

function Room:init()
    self.world = World()
    self.player = Player(self.world, 100, 100)
    self.world:add_ent(self.player)
    camera:zoom(ZOOM)
end


function Room:draw()
    camera:set()
    self.world:draw()
    camera:unset()
end


function Room:update(dt)
    self.world:update(dt)
end

return Room