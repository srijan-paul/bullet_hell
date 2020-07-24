local Systems = require 'ecs/systems'
local Components = require 'ecs/components'
local camera = require 'camera'

local Room = Class('Room')
local Player = require 'prefabs.player'
local ZOOM = 4

function Room:init()
    self.world = Concord.world()
    self.world:addSystems(Systems.AnimationSystem, Systems.MoveSystem)
    self.player = Concord.entity(self.world)
    Player:assemble(self.player, 100, 100)

    camera:reset()
    camera:zoom(ZOOM)
end

function Room:draw()
    local pos = self.player[Components.Transform].pos
    camera:setPos(pos.x - love.graphics.getWidth() / (2 * ZOOM),
                  pos.y - love.graphics.getHeight() / (2 * ZOOM))
    camera:set()
    self.world:emit('draw')
    camera:unset()
end

function Room:update(dt) self.world:emit('update', dt) end

return Room
