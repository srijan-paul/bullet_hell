local camera = require 'camera'
local World = require 'world/world'

local Room = Class('Room')
local ZOOM = 4

function Room:init()
    self.world = World:init()
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