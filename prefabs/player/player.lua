local cmp = require 'component/common'
local InputComponent = require 'component/playerinput'
local GameObject = require 'prefabs/gameobject'
local camera = require 'camera'
local Healthbar = require 'prefabs/healthbar'
local PSystem = require 'particles/psystem'

local COLLIDER_WIDTH, COLLIDER_HEIGHT = 10, 10
local DASH_DISTANCE = 50
local DASH_SPEED = 300

local DashState = {}

DashState.MOVING = {

    update = function(self, player, dt)
        local movedir = player:get_component(InputComponent).movedir
        if movedir.x == 0 and movedir.y == 0 then return end
        local velocity = movedir:with_mag(player.speed * dt)
        player:move(velocity)
    end,

    switch = function(self, player, state)
        state:init(player)
        player.move_state = state
    end
}

DashState.DASHING = {
    dash_dist = DASH_DISTANCE,
    dash_particles = nil,

    init = function(self, player)
        player.dash_particles:configure({
            particle_velocity = player.dash_dir:with_mag(-20),
            particle_vel_randomness = 1,
            particle_life = 1,
            radius = 10
        })
    end,

    update = function(self, player, dt)
        local velocity = player.dash_dir:with_mag(DASH_SPEED * dt)
        player.dash_particles:emit()
        player:move(velocity)
        self.dash_dist = self.dash_dist - DASH_SPEED * dt
        if self.dash_dist <= 0 then self:switch(player, DashState.MOVING) end
        player.weapon:set_pos(player:get_weapon_pivot())
    end,

    switch = function(self, player, state)
        if self.dash_dist <= 0 then
            -- player:set_scale(1, 1)
            self.dash_dist = DASH_DISTANCE
            player.move_state = state
        end
    end
}

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
    self.speed = 50
    self.state = PlayerState.IDLE
    self.move_state = DashState.MOVING
    self.dash_dir = Vec2(0, 0)

    self.dash_particles =
        self.world:add_particle_system(PSystem(self:get_pos()))
    self.dash_particles.active = false
    self.dash_particles:attach_to(self)

    -- TODO: remove magic number
    self.health = 10
    self.max_health = 10
    self.stats = {}
end

function Player:update(dt)
    GameObject.update(self, dt)
    self.weapon:face(camera:toWorldPos(mousePos()))
    local movedir = self:get_component(InputComponent).movedir

    local t = self:get_component(cmp.Transform)

    local centerX = camera:toScreenX(t.pos.x + COLLIDER_WIDTH / 2)
    -- local centerY = camera:toScreenY(t.pos.y + COLLIDER_HEIGHT / 2)

    t.scale.x = (mouseX() >= centerX) and 1 or -1

    if movedir.x ~= 0 or movedir.y ~= 0 then
        self:switch_state(PlayerState.RUN)
    else
        self:switch_state(PlayerState.IDLE)
    end
end

function Player:switch_state(state)
    if self.state == state then return end

    local anim = self:get_component(cmp.AnimatedSprite)
    switch(self.state, {
        [PlayerState.HURT] = function()
            if not self:get_component(cmp.AnimatedSprite):is_playing() then
                self.state = state
                anim:play(self.state)
            end
        end,
        ['default'] = function()
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
    if love.keyboard.isDown('e') then self:dash() end
    self.move_state:update(self, dt)
end

function Player:fire()
    self.weapon:fire(camera:toWorldPos(mousePos()), 'enemy')
    -- ?
end

function Player:damage(amount)
    self.health = sugar.clampmin(self.health - amount, 0)
    self:switch_state(PlayerState.HURT)
    -- TODO death state
    Healthbar.update(self.health / self.max_health)
    if self.health <= 0 then self:death() end
end

function Player:dash()
    self.dash_dir =
        (camera:toWorldPos(mousePos()) - self:get_pos()):normalized()
    self:switch_move_state(DashState.DASHING)
end

function Player:switch_move_state(state) self.move_state:switch(self, state) end

function Player:heal()
    -- TODO
end

function Player:death()
    -- TODO
end

return Player
