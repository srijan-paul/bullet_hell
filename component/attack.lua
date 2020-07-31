local Projectile = require 'prefabs/weapon/projectile'
-- local ProjectileType = require 'prefabs/weapon/projectiletype'
local Transform = require 'component/transform'

local Attack = Class('Attack')

function Attack:init(owner, ptype, config)
    self.owner = owner
    self.ptype = ptype
    self.cooldown = config.cooldown or 0
    -- time remaining before it can attack again
    self.time_remaining = 0
    self.accuracy = config.accuracy or 1
    self.speed = config.speed or 100
    self.spawn_offset = config.spawn_offset or Vec2.ZERO()
    self.sound = config.sound
    self.mask = config.mask or ''
end

function Attack:update(dt)
    self.time_remaining = sugar.clampmin(self.time_remaining - dt, 0)
end

function Attack:delete()
    -- body
end


function Attack:play_sound()
    if not self.sound then return end
    if self.sound:isPlaying() then
        self.sound:stop()
    end
    self.sound:play()
end

function Attack:attack(target_loc)
    if self.time_remaining > 0 then return end
    self:play_sound()
    local t = self.owner:get_component(Transform)
    local spawn_pos = t.pos + self.spawn_offset:rotated(t.rotation)

    Projectile(self.owner, self.ptype, target_loc, self.speed, self.mask,
               self.owner.world, spawn_pos.x, spawn_pos.y)
    self.time_remaining = self.cooldown
end


function Attack:is_on_cooldown()
    return self.time_remaining >= 0
end

return Attack