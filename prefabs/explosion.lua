local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Explosion = Class('Explosion', GameObject)

function Explosion:init(world, x, y)
    GameObject.init(self, world, x, y)
    self.anim = self:add_component(cmp.AnimatedSprite, Resource.Sprite.BlastRed,
                                   {{'blast', 1, 14, 0.03, false}})
    self:set_scale(1.3, 1.3)
    -- self:set_scale(2, 2)
    self.anim:play('blast')
end

function Explosion:update(dt)
    GameObject.update(self, dt)
    if not self.anim:is_playing() then self:delete() end
end

return Explosion
