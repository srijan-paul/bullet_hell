local Transform = require 'component/transform'
local Sprite = Class('Sprite')

function Sprite:init(owner, texture)
    self.owner = owner
    self.image = texture
    self.width = texture:getWidth()
    self.height = texture:getHeight()
    self.owner.world:add_drawable(self)
end

function Sprite:draw()
    assert(self.owner:has_component(Transform),
           'no transform component on sprite component owner')
    local t = self.owner:get_component(Transform)
    local x = t.pos.x - self.width / 2
    local y = t.pos.y - self.height / 2

    -- for animated sprites, when the scale is negative, it means the
    -- entity is facing left and hence we still draw the sprite from the same
    -- offset
    if t.scale.x < 0 then
        x = x + self.width * - 1 * t.scale.x
    end

    love.graphics.draw(self.image, x, y, t.rotation, t.scale.x, t.scale.y)
end

return Sprite
