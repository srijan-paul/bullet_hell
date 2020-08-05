local Enemy = require 'prefabs/enemies/enemy'
local Timer = require('component/timer')
local ProjectileType = require 'prefabs/weapon/projectiletype'
local cmp = require 'component/common'
local Attack = require 'component/attack'

local ATTACK_RATE = 0.5
local PROJECTILE_SPEED = 100
local PATROL_DISTANCE = 30
local MOVE_SPEED = 30
local DETECT_RANGE = 10

local Fly = Class('Stinger', Enemy)

local State = {
    ATTACK = {
        update = function(self, fly, dt)
            if not fly.target_loc then return end
            fly:attack(fly.target_loc)
        end,

        switch = function(self, fly, state) fly.state = state end
    },

    PATROL = {
        update = function(self, fly, dt)
            fly:move(Vec2.from_polar(MOVE_SPEED * dt, fly.target_loc:angle()))
        end,

        switch = function(self, fly, state) fly.state = state end
    },
}

State.HURT = {
    hurt_timer = 0,

    update = function(self, fly, dt)
        self.hurt_timer = self.hurt_timer + dt
        if self.hurt_timer > 0.3 then
            fly.state = State.PATROL
            fly:get_component(cmp.AnimatedSprite):play('idle')
            self.hurt_timer = 0
        end
    end,

    switch = function(self, fly, state)
        if self.hurt_timer >= 0.3 or state == State.DEAD then
            fly.state = state
        end
    end
}

local function fly_ai(fly)
    local t = fly:get_component(cmp.Transform)
    local nearby = fly.world:query('circle', t.pos.x, t.pos.y, DETECT_RANGE)
    local player_spotted = false

    sugar.foreach(nearby, function(ent, i)
        if ent.id == 'player' then
            player_spotted = true
            fly:set_state(State.ATTACK)
            local pos = ent:get_pos()
            fly.target_loc = pos
            if pos.x < t.pos.x then
                fly:set_scale(-1, 1)
            else
                fly:set_scale(1, 1)
            end
        end
    end)

    if not player_spotted then
        fly.target_loc = Vec2.from_polar(PATROL_DISTANCE,
                                         -math.random() * 2 * math.pi)
        fly:set_state(State.PATROL)
    end
end

function Fly:init(world, x, y)
    Enemy.init(self, world, x, y, {
        collider_width = 10,
        collder_height = 10,
        detect_range = 50,
        health = 10,
        corpse = Resource.Image.FlyCorpse
    })

    local anim = self:add_component(cmp.AnimatedSprite, Resource.Sprite.Fly, {
        {'idle', 1, 3, 0.04, true}, {'hurt', 4, 4, 0.1, false}
    })

    self:add_component(Timer, 0.2, function() fly_ai(self) end)

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
    self.target_loc = self:get_pos()
end

function Fly:_physics_process(dt)
    self.state:update(self, dt)
    self:move(Vec2(0, math.sin(love.timer.getTime() * 5) / 2))
end

function Fly:set_state(state) self.state:switch(self, state) end

function Fly:damage(amount, ...)
    self:get_component(cmp.AnimatedSprite):play('hurt')
    self:set_state(State.HURT)
    Enemy.damage(self, amount, ...)
end


function Fly:attack(target_pos)
    self.attack_comp:attack(target_pos)
end

return Fly
