local Enemy = require 'prefabs/enemies/enemy'
local Timer = require('component/timer')
local ProjectileType = require 'prefabs/weapon/projectiletype'
local cmp = require 'component/common'
local Attack = require 'component/attack'

local ATTACK_RATE = 0.5
local PROJECTILE_SPEED = 100

local Fly = Class('Stinger', Enemy)

local State = {
    ATTACK = {
        update = function (self, fly, dt)
            if not fly.target_loc then return end
            fly:attack(fly.target_loc)
        end,

        switch = function (self, fly, state)
            fly.state = state
        end
    },

    PATROL = {
        update = function (self, fly, dt)
            -- TODO
        end,

        switch = function (self, fly, state)
            fly.state = state
        end
    }
}


State.HURT = {
    hurt_timer = 0,

    update = function (self, fly, dt)
        self.hurt_timer = self.hurt_timer + dt
        if self.hurt_timer > 0.3 then
            fly.state = State.PATROL
            fly:get_component(cmp.AnimatedSprite):play('idle')
            self.hurt_timer = 0
        end
    end,

    switch = function (self, fly, state)
        if self.hurt_timer >= 0.3 then
            fly.state = state
        end
    end
}

local function fly_ai(fly)
    local t = fly:get_component(cmp.Transform)
    local nearby = fly.world:query('circle', t.pos.x, t.pos.y, fly.detect_range)
    local player_spotted = false

    sugar.foreach(nearby, function (ent, i)
        if ent.id == 'player' then
            player_spotted = true
            fly:set_state(State.ATTACK)
            fly.target_loc = ent:get_pos()
        end
    end)

    if not player_spotted then fly:set_state(State.PATROL) end
end

function Fly:init(world, x, y)
    Enemy.init(self, world, x, y, {
        collider_width = 10,
        collder_height = 10,
        detect_range = 50,
        health = 10
    })

    local anim = self:add_component(cmp.AnimatedSprite, Resource.Sprite.Fly, {
        {'idle', 1, 3, 0.04, true}, {'hurt', 4, 4, 0.1, false}
    })

    self:add_component(Timer, 0.2, function ()
        fly_ai(self)
    end)

    anim:play('idle')

    self.attack_comp = self:add_component(Attack, ProjectileType.Ball, {
        cooldown = ATTACK_RATE,
        accuracy = 0.5,
        spawn_offset = Vec2(4, 0),
        speed = PROJECTILE_SPEED,
        mask = 'player',
        damage = 2
    })

    self.state = State.PATROL
    self.target_loc = nil
end

function Fly:_physics_process(dt)
    self.state:update(self, dt)
    self:move(Vec2(0, math.sin(love.timer.getTime() * 5) / 2))
end

function Fly:set_state(state)
    self.state:switch(self, state)
end


function Fly:damage(amount)
    self:get_component(cmp.AnimatedSprite):play('hurt')
    self:set_state(State.HURT)
end


function Fly:attack(target_pos)
    self.attack_comp:attack(target_pos)
end

return Fly
