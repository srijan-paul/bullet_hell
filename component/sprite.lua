local Transform = require 'component/transform'
local Sprite = Class('Sprite')

function Sprite:init(owner, texture)
    self.owner = owner
    self.world = self.owner.world
    self.image = texture
    self.width = texture:getWidth()
    self.height = texture:getHeight()
    self.owner.world:add_drawable(self)
end

function Sprite:draw()
    assert(self.owner:has_component(Transform),
           'no transform component on sprite component owner')
    local t = self.owner:get_component(Transform)

    
    local dp = Vec2(self.width / 2, self.height / 2):rotated(t.rotation)
    local x = t.pos.x - dp.x
    local y = t.pos.y - dp.y
 
    if t.scale.x < 0 then
        x = x + self.width * - 1 * t.scale.x
    end

    love.graphics.draw(self.image, x, y, t.rotation, t.scale.x, t.scale.y)
end


function Sprite:delete()
    self.world:remove_drawable(self)
end


return Sprite
