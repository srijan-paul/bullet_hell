local cmp = require 'component/common'
local GameObject = require 'prefabs/gameobject'

local Effect = Class('Effect', GameObject)

function Effect:init(world, x, y, etype, life_span, ...)
    GameObject.init(self, world, x, y)
    self:add_component(cmp.Drawable, etype(...))
    self.life_span = life_span
    if not self.life_span then self.update = GameObject.update end
end

function Effect:update(dt)
    GameObject.update(self, dt)
    self.life_span = self.life_span - dt
    if self.life_span <= 0 then self:delete() end
end

function Effect:delete()
    self.world:remove_drawable(self:get_component(cmp.Drawable))
    self.world:remove_gameobject(self)
end

return Effect
