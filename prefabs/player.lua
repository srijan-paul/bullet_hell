local cmp = require 'component.common'
local InputComponent  = require 'component.playerinput'
local GameObject = require 'prefabs.gameobject'


-- TODO: implement state pattern if need be
local PlayerState = {
    IDLE = 'idle',
    RUN = 'run'
}

local Player = Class('Player', GameObject)

function Player:init(world, x, y)
    GameObject.init(self, world, x, y)
    self:add_component(cmp.AnimatedSprite, Resource.Sprite.Player,
                       {{'idle', 1, 5, 0.1, true}, {'run', 6, 10, 0.07, true},
                        {'hurt', 11, 12, 0.2, true}})
    self:add_component(InputComponent)
    self:get_component(cmp.AnimatedSprite):play('idle')
    self.face_dir = 1 -- 1 is right, -1 is left
    self.speed = 1.5
    self.state = PlayerState.IDLE
end


function Player:update(dt)
    GameObject.update(self, dt)
    local movedir = self:get_component(InputComponent).movedir
    
    if movedir.x == -1 then
        self:get_component(cmp.Transform).scale.x = -1
        self.face_dir = -1
    elseif movedir.x == 1 then
        self:get_component(cmp.Transform).scale.x = 1
        self.face_dir = -1
    end

    if movedir.x ~= 0 or movedir.y ~= 0 then
        self:switch_state(PlayerState.RUN)
    else
        self:switch_state(PlayerState.IDLE)
    end
end

function Player:switch_state(state)
    if self.state ~= state then
        self.state = state
        self:get_component(cmp.AnimatedSprite):play(state)
    end
end

function Player:_physics_process(dt)
    local t = self:get_component(cmp.Transform)
    local movedir = self:get_component(InputComponent).movedir
    if movedir.x == 0 and movedir.y == 0 then return end
    local velocity = movedir:with_mag(self.speed)
    t.pos = t.pos + velocity
end

function Player:movement_loop()
    
end

return Player
