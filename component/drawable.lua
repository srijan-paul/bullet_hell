local Transform = require 'component/transform'

local Drawable = Class('Drawable')

function Drawable:init(owner, canvas)
  self.owner = owner
  self.canvas = canvas
  self.width = self.canvas:getWidth()
  self.height = self.canvas:getHeight()
  self.owner.world:add_drawable(self)
end

function Drawable:draw()
  local t = self.owner:get_component(Transform)
  local dp = Vec2(self.width / 2, self.height / 2):rotated(t.rotation)
  local x = t.pos.x - dp.x
  local y = t.pos.y - dp.y
  love.graphics.draw(self.canvas, x, y, t.rotation, t.scale.x, t.scale.y)
end

function Drawable:delete()
  self.owner.world:remove_drawable(self)
end

return Drawable
