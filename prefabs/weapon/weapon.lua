local cmp = require 'component/common'
local Sprite = require 'component/weapon_sprite'
local GameObject = require 'prefabs/gameobject'
local Projectile = require 'prefabs/weapon/projectile'

local Weapon = Class('Weapon', GameObject)


function Weapon:init(owner, wtype)
    self.owner = owner
    local wpivot = self.owner:get_weapon_pivot()
    -- active : can shoot
    self.active = true
    self.cooldown = wtype.cooldown
    self.projectile = wtype.projectile
    self.auto = false
    self.speed = wtype.speed
    self.sound = Resource.Sound[wtype.sound]
    GameObject.init(self, self.owner.world, wpivot.x, wpivot.y)
    self:add_component(Sprite, Resource.Image[wtype.sprite_path])
end

function Weapon:update(dt)
    GameObject.update(self, dt)
    local t = self:get_component(cmp.Transform)
    t.pos = self.owner:get_weapon_pivot()
    local scl = self.owner:get_scale()
    if t.scale.x < 0 then
        t.scale.x = -scl.x
    end
end

function Weapon:face(point)
    local t = self:get_component(cmp.Transform)
    t.rotation = (point - t.pos):angle()
    t.scale.y = self.owner.face_dir
    -- t.scale = self.owner:get_scale():clone()
end


function Weapon:fire(target)
    if not self.active then return false end

    local t = self:get_component(cmp.Transform)
    local spawn_pos = t.pos + Vec2(4, 0):rotated(t.rotation)
    
    if self.sound:isPlaying() then
        self.sound:stop()
    end

    self.sound:play()

    Projectile(self.owner, self.projectile, target, self.speed,
                            self.world, spawn_pos.x, spawn_pos.y)

    Timer.after(self.cooldown, function ()
        self.active = true
    end)
    self.active = false
    return true
end


return Weapon