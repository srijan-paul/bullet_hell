local cmp = require 'component/common'
local Sprite = require 'component/weapon_sprite'
local GameObject = require 'prefabs/gameobject'
local AttackComponent = require 'component/attack'


local Weapon = Class('Weapon', GameObject)

function Weapon:init(owner, wtype)
    self.owner = owner
    local wpivot = self.owner:get_weapon_pivot()
    GameObject.init(self, self.owner.world, wpivot.x, wpivot.y)

    self.auto = wtype.auto

    self.attack_comp = self:add_component(AttackComponent, wtype.projectile, {
        cooldown = wtype.cooldown,
        speed = wtype.speed,
        spawn_offset = Vec2(4, 0),
        sound = Resource.Sound[wtype.sound],
        mask = {'enemy', 'neutral'},
        damage = wtype.damage,
        knockback = wtype.knockback
    })

    self:add_component(Sprite, Resource.Image[wtype.sprite_path])
    self.type = wtype
end

function Weapon:update(dt)
    GameObject.update(self, dt)
    local t = self:get_component(cmp.Transform)
    if not self.owner then return end
    t.pos = self.owner:get_weapon_pivot()
    local scl = self.owner:get_scale()
    if t.scale.x < 0 then t.scale.x = -scl.x end
end

function Weapon:face(point)
    local t = self:get_component(cmp.Transform)
    t.rotation = (point - t.pos):angle()
    t.scale.y = self.owner:get_scale().x
end

function Weapon:fire(target)
    -- if self.attack_comp:is_on_cooldown() then return false end
    self.attack_comp.spawn_offset = self.type.muzzle_offset:rotated(self:rotation())
    self.attack_comp:attack(target)
end

return Weapon
