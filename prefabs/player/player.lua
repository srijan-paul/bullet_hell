local cmp = require 'component/common'
local GameObject = require 'prefabs/gameobject'
local camera = require 'camera'
local Healthbar = require 'prefabs/healthbar'
local PSystem = require 'particles/psystem'
local State = require 'prefabs/player/playerstate'
local AnimationState = require 'prefabs/player/playeranimstate'

local COLLIDER_WIDTH, COLLIDER_HEIGHT = 10, 10

local Player = Class('Player', GameObject)

function Player:init(world, x, y)
  GameObject.init(self, world, x, y)
  self:add_component(cmp.AnimatedSprite, Resource.Sprite.Player, {
    {'idle', 1, 5, 0.1, true}, {'run', 6, 10, 0.07, true},
    {'hurt', 11, 12, 0.2, false}
  })
  self:add_component(cmp.Collider, COLLIDER_WIDTH, COLLIDER_HEIGHT, 'player')

  self.id = 'player'
  self.speed = 50

  -- state: IDLE, MOVING, DASHING
  -- AnimationState: hurt, idle, run
  self.state = State.IDLE
  AnimationState.IDLE:enter(self)
  self.dash_dir = Vec2(0, 0)

  self.dash_particles = self.world:add_particle_system(PSystem(self:get_pos()))
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

  local t = self:get_component(cmp.Transform)

  local centerX = camera:toScreenX(t.pos.x + COLLIDER_WIDTH / 2)
  -- local centerY = camera:toScreenY(t.pos.y + COLLIDER_HEIGHT / 2)

  t.scale.x = (mouseX() >= centerX) and 1 or -1
end

function Player:switch_state(state)
  if self.state == state then return end
  self.state:switch(self, state)
end

function Player:set_state(state)
  state:init(self)
  self.state = state
end

function Player:get_weapon_pivot()
  local t = self:get_component(cmp.Transform)
  if t.scale.x == -1 then return t.pos - Vec2(1, -3) end
  return t.pos + Vec2(8, 3)
end

function Player:_physics_process(dt)
  if love.keyboard.isDown('e') then self:dash() end
  self.state:update(self, dt)
  self.animation:update(self, dt)
end

function Player:fire()
  self.weapon:fire(camera:toWorldPos(mousePos()), 'enemy')
  -- ?
end

function Player:damage(amount)
  self.health = sugar.clampmin(self.health - amount, 0)
  self.animation:switch(self, AnimationState.HURT)
  Resource.Sound.PlayerHurt:play()
  -- TODO death state
  Healthbar.update(self.health / self.max_health)
  if self.health <= 0 then self:death() end
end

function Player:dash()
  self.dash_dir = (camera:toWorldPos(mousePos()) - self:get_pos()):normalized()
  self:switch_state(State.DASHING)
end

function Player:death()
  -- TODO
end

function Player:switch_anim(key)
  self.animation:switch(self, key)
end

return Player
