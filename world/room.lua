local camera = require 'camera'
local World = require 'world/world'
local Player = require 'prefabs/player'
local Weapon = require 'prefabs/weapon/weapon'
local WeaponType = require 'prefabs/weapon/weapontypes'

local Room = Class('Room')
local ZOOM = 4.8

function Room:init()
    self.world = World()
    self.player = Player(self.world, 100, 100)
    self.player.weapon = Weapon(self.player, WeaponType.HandGun)
    self.world_tree = {}
    camera:zoom(ZOOM)
    camera:follow(self.player)
end

function Room:draw()
    -- graphics.setColor(0.12549019607843, 0.15686274509804, 0.22352941176471)
    -- graphics.rectangle('fill', 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT)
    graphics.setColor(1, 1, 1, 1)
    camera:set()
    self.world:draw()
    camera:unset()
end

function Room:update(dt)
    self.world:update(dt)
    camera:update(dt)
end


function Room:mousepressed(x, y, btn)
    if btn == 1 then
        self.player:fire()
    end
end

return Room
