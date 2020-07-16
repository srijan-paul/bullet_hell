local camera = {}

function camera:reset()
    self.pos = Vec2.ZERO()
    self.scaleX, self.scaleY = 1, 1
    self.offset = Vec2.ZERO()
end

function camera:setPos(x, y)
    if not y then -- if only a vector is fed
        self.pos.x = x.x
        self.pos.y = x.y
    end
    self.pos.x = x
    self.pos.y = y
end

function camera:update(dt)
    if not self.shaking or self.shakeTimeLeft <= 0 then
        self.shaking = false
        self.offset = Vec2.ZERO()
        return 
    end
    -- print(self.shakeTimeLeft)
    -- self.offset.x = util.lerp(self.shakeDir.x, 0, self.shakeTimeLeft * 15)
    -- self.offset.x = self.offset.x + 0.02
    local diff = (self.pos - self.offset)
    diff:setMag(0.2)
    -- self.offset = self.offset + diff
    -- self.offset.y = util.lerp(self.shakeDir.y, 0, self.shakeTimeLeft * 15)
    self.shakeTimeLeft = self.shakeTimeLeft - dt
    -- print(self.shakeTimeLeft)
end

function camera:set()
    graphics.push()
    graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    graphics.translate(-(self.pos.x + self.offset.x), -(self.pos.y + self.offset.y))
end

function camera:unset() love.graphics.pop() end

function camera:zoom(z)
    self.scaleX = 1 / z
    self.scaleY = 1 / z
end

function camera:scale(sx, sy)
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * sy
end

function camera:toScreenX(x) return (x - self.pos.x) / self.scaleX end

function camera:toScreenY(y) return (y - self.pos.y) / self.scaleY end

function camera:toWorldX(x) return (x * self.scaleX) + self.pos.x end

function camera:toWorldY(y) return (y * self.scaleY) + self.pos.y end

function camera:toWorldPos(vec)
    local x = (vec.x * self.scaleX) + self.pos.x
    local y = (vec.y * self.scaleY) + self.pos.y
    return Vec2:new(x, y)
end

function camera:toScreenPos(vec)
    return Vec2:new(self:toScreenX(vec.x), self:toScreenY(vec.y))
end

return camera
