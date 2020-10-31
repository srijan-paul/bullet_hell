local Animation = require 'prefabs/player/playeranimstate'

local State = {}
local DASH_DISTANCE = 60
local DASH_SPEED = 300

local function get_move_dir()
  local move_x = Input:keydown('d') - Input:keydown('a')
  local move_y = Input:keydown('s') - Input:keydown('w')
  return Vec2(move_x, move_y)
end

State.MOVING = {
  init = function(self, player)
    player:switch_anim(Animation.MOVE)
  end,

  update = function(self, player, dt)
    local movedir = get_move_dir()
    if movedir.x == 0 and movedir.y == 0 then
      player:switch_state(State.IDLE)
      return
    end
    local velocity = movedir:with_mag(player.speed * dt)
    player:move(velocity)
  end,

  switch = function(self, player, state)
    player:set_state(state)
  end
}

State.DASHING = {
  dash_dist = DASH_DISTANCE,

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
    if self.dash_dist <= 0 then self:switch(player, State.MOVING) end
    player.weapon:set_pos(player:get_weapon_pivot())
  end,

  switch = function(self, player, state)
    if self.dash_dist <= 0 then
      -- player:set_scale(1, 1)
      self.dash_dist = DASH_DISTANCE
      player:set_state(state)
    end
  end
}

State.IDLE = {
  init = function(self, player)
    player:switch_anim(Animation.IDLE)
  end,

  update = function(self, player, dt)
    local movedir = get_move_dir()
    if movedir.x ~= 0 or movedir.y ~= 0 then
      player:switch_state(State.MOVING)
    end
  end,

  switch = function(self, player, state)
    player:set_state(state)
  end
}

return State
