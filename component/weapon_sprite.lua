local cmp = require 'component/common'
local WeaponSprite = Class('WeaponSprite', cmp.Sprite)

function WeaponSprite:init(...)
    cmp.Sprite.init(self, ...)
end

function WeaponSprite:draw()
    local t  = self.owner:get_component(cmp.Transform)
    local x = t.pos.x - self.width / 2
    local y = t.pos.y - self.height / 2

    -- for animated sprites, when the scale is negative, it means the
    -- entity is facing left and hence we still draw the sprite from the same
    -- offset
    if t.scale.x < 0 then
        x = x + self.width * - 1 * t.scale.x
    end

    sugar.push_translate_rotate(x, y, t.rotation)
    lg.draw(self.image, x, y, 0, t.scale.x, t.scale.y)
    sugar.pop()
end


function WeaponSprite:delete()
    self.world:remove_drawable(self)
end

return WeaponSprite