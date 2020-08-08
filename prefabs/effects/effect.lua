local cmp = require 'component/common'
local GameObject = require 'prefabs/gameobject'

local Effect = Class('Effect', GameObject)

function Effect:init(world, x, y, e_canvas, config)
    GameObject.init(self, world, x, y)
    self:add_component(cmp.Drawable, e_canvas)
    self.life_span = config.life_span or {1, 1}

    local start_scale = config.start_scale or {1, 1}
    local end_scale = config.end_scale or {1, 1}
    self:set_scale(start_scale[1], start_scale[2])
    Timer.tween(self.life_span, self:get_component(cmp.Transform).scale,
                {x = end_scale[1], y = end_scale[2]}, 'linear')
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
