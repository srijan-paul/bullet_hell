local camera = require 'camera'


local Scene = class('Scene')
local DEFAULT_ZOOM = 3.4

local DEFAULT_WORLD_WIDTH, DEFAULT_WORLD_HEIGHT = 200, 200

function Scene:init(player) self.player = player end

function Scene:add_world(w, h)
    self.world = World(DEFAULT_WORLD_WIDTH, DEFAULT_WORLD_HEIGHT)
end

function Scene:add_player(player)
    self.player = player
    self.world:add_player(player)
end

function Scene:update(dt) self.world:update(dt) end

function Scene:draw() self.world:draw() end

return Scene