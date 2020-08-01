local camera = require 'camera'
local LevelGenerator = require 'world/worldgen/levelgen'
local Player = require 'prefabs/player'
local Weapon = require 'prefabs/weapon/weapon'
local Minimap = require 'prefabs/minimap'
local WeaponType = require 'prefabs/weapon/weapontypes'
local Healthbar = require 'prefabs/healthbar'

local Level = Class('Level')
local ZOOM = 4.8

-- A little explanation to self about the way I'm coding this
-- Each Level consits of many interconnected rooms that the player has to clear
-- to finally reach the boss room, beat the boss and go to the next Level.
-- Each room is kind of a "world" of it's own. The nomenclature here is silly,
-- but the point is, when a player exits a room and enters into the next,
-- he is actually leaving the current "world" and entering a world adjacent to it
-- depending on what door he uses.

function Level:init()
    Healthbar.init()
    self.world_tree = LevelGenerator(self, 5):generate()
    self.current_node = self.world_tree
    
    -- *active: the player is currently in this node
    -- *explored: the player has visited this area before
    
    self.current_node.active = true
    self.current_node.explored = true
    self.current_world = self.current_node.world
    self.player = Player(self.current_world, 100, 100)
    self.player.level = self
    self.player.weapon = Weapon(self.player, WeaponType.HandGun)
    self.map = Minimap(self.world_tree)
    camera:zoom(ZOOM)
    camera:follow(self.player)
end


function Level:switch_world(dir)
    -- TODO: switch effects and shaders
    local node = self.current_node.children[dir]
    
    assert(node, 'invalid room')
    node.explored = true
    node.active = true

    self.current_node.active  = false
    self.current_node = node
    self.map.current_node = self.current_node
    self.map:re_render()

    self.current_world:player_leave(self.player)
    self.current_world = node.world
    self.current_world:player_enter(self.player, OppositeDirection(dir))
    camera:setPos(self.player:get_pos().x, self.player:get_pos().y)
end


function Level:draw()
    graphics.setColor(1, 1, 1, 1)
    camera:set()
    self.current_world:draw()
    camera:unset()
    Healthbar.draw(20, 30)
    self.map:draw(NATIVE_WIDTH - self.map.width - 10, 30)
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
