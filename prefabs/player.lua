local cmp = require 'component/common'
local InputComponent = require 'component/playerinput'
local GameObject = require 'prefabs/gameobject'
local camera = require 'camera'

local COLLIDER_WIDTH, COLLIDER_HEIGHT = 10, 10

-- TODO: implement state pattern if need be
local PlayerState = {IDLE = 'idle', RUN = 'run', HURT = 'hurt'}

local Player = Class('Player', GameObject)

function Player:init(world, x, y)
    GameObject.init(self, world, x, y)
    self:add_component(cmp.AnimatedSprite, Resource.Sprite.Player, {
        {'idle', 1, 5, 0.1, true}, {'run', 6, 10, 0.07, true},
        {'hurt', 11, 12, 0.2, false}
    }, 'player')
    self:add_component(InputComponent)
    self:add_component(cmp.Collider, COLLIDER_WIDTH, COLLIDER_HEIGHT, 'player')

    self:get_component(cmp.AnimatedSprite):play('idle')
    self.id = 'player'
    self.face_dir = 1 -- 1 is right, -1 is left
    self.speed = 50
    self.state = PlayerState.IDLE

    -- TODO: remove magic number
    self.health = 10
    self.stats = {}
end

function Player:update(dt)
    GameObject.update(self, dt)
    self.weapon:face(camera:toWorldPos(mousePos()))
    local movedir = self:get_component(InputComponent).movedir

    local t = self:get_component(cmp.Transform)

    local centerX = camera:toScreenX(t.pos.x + COLLIDER_WIDTH / 2)
    -- local centerY = camera:toScreenY(t.pos.y + COLLIDER_HEIGHT / 2)

    if mouseX() >= centerX then
        t.scale.x = 1
        self.face_dir = 1
    else
        t.scale.x = -1
        self.face_dir = -1
    end

    if movedir.x ~= 0 or movedir.y ~= 0 then
        self:switch_state(PlayerState.RUN)
    else
        self:switch_state(PlayerState.IDLE)
    end
end

function Player:switch_state(state, callback)
    if self.state == state then return end

    local anim = self:get_component(cmp.AnimatedSprite)
    switch(self.state, {
        [PlayerState.HURT] = function()
           if not self:get_component(cmp.AnimatedSprite):is_playing() then
                self.state = state
                anim:play(self.state)
           end
        end,
        ['default'] = function ()
            self.state = state
            anim:play(self.state)
        end
    })
end

function Player:get_weapon_pivot()
    local t = self:get_component(cmp.Transform)
    if t.scale.x == -1 then return t.pos - Vec2(1, -3) end
    return t.pos + Vec2(8, 3)
end

function Player:_physics_process(dt)
    local t = self:get_component(cmp.Transform)
    local movedir = self:get_component(InputComponent).movedir
    if movedir.x == 0 and movedir.y == 0 then return end
    local velocity = movedir:with_mag(self.speed)
    t.pos = t.pos + velocity * dt
end

function Player:fire()
    self.weapon:fire(camera:toWorldPos(mousePos()), 'enemy')
    -- ?
end

function Player:damage(amount)
    self.health = self.health - amount
    self:switch_state(PlayerState.HURT)
    -- TODO death state
    if self.health <= 0 then self:death() end
end

function Player:heal()
    -- body
end

function Player:death() end

return Player
