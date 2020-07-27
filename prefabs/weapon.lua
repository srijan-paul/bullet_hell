local cmp = require 'component/common'
local Sprite = require 'component/weapon_sprite'
local GameObject = require 'prefabs/gameobject'

local Weapon = Class('Weapon', GameObject)


function Weapon:init(owner, wtype)
    self.owner = owner
    local wpivot = self.owner:get_weapon_pivot()
    GameObject.init(self, self.owner.world, wpivot.x, wpivot.y)
    self:add_component(Sprite, Resource.Image.Handgun)
end

function Weapon:update(dt)
    GameObject.update(self, dt)
    local t = self:get_component(cmp.Transform)
    t.pos = self.owner:get_weapon_pivot()
    local scl = self.owner:get_scale()
    if t.scale.x < 0 then
        t.scale.x = -scl.x
    end
    -- t.scale.y = scl.y
end

function Weapon:face(point)
    local t = self:get_component(cmp.Transform)
    t.rotation = (point - t.pos):angle()
    t.scale.y = self.owner.face_dir
    -- t.scale = self.owner:get_scale():clone()
end


return Weapon