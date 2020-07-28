local Transform = require 'component/transform'

local Drawable = Class('Drawable')

function Drawable:init(owner, canvas)
    self.owner = owner
    self.canvas = canvas
    self.owner.world:add_drawable(self)
end

function Drawable:draw()
    local t = self.owner:get_component(Transform)
    love.graphics.draw(self.canvas, t.pos.x, t.pos.y, t.rotation, t.scale.x, t.scale.y)
end

function Drawable:delete()
    self.owner.world:remove_drawable(self)
end

return Drawable