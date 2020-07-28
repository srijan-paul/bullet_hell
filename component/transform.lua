local Transform = Class('Transform')

function Transform:init(owner, x, y, r, sx, sy)
    self.owner = owner
    self.pos = Vec2(x, y)
    self.rotation = r or 0
    self.scale = Vec2(sx or 1, sy or 1)
end

function Transform:delete()
    -- body
end

return Transform
