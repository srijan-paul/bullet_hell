local camera = require 'camera'
local LevelGenerator = require 'world/worldgen/levelgen'
local Player = require 'prefabs/player'
local Weapon = require 'prefabs/weapon/weapon'
local WeaponType = require 'prefabs/weapon/weapontypes'

local Level = Class('Level')
local ZOOM = 4.8

function Level:init()
    self.world_tree = LevelGenerator(2):generate()
    self.current_world = self.world_tree.world
    self.player = Player(self.current_world, 100, 100)
    self.player.weapon = Weapon(self.player, WeaponType.HandGun)
    camera:zoom(ZOOM)
    camera:follow(self.player)
end


function Level:switch_world()
    
end


function Level:draw()
    -- graphics.setColor(0.12549019607843, 0.15686274509804, 0.22352941176471)
    -- graphics.rectangle('fill', 0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT)
    graphics.setColor(1, 1, 1, 1)
    camera:set()
    self.current_world:draw()
    camera:unset()
end


function Level:update(dt)
    self.current_world:update(dt)
    camera:update(dt)
end


function Level:mousepressed(x, y, btn)
    if btn == 1 then
        self.player:fire()
    end
end

return Level
