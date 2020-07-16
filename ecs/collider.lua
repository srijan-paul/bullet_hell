local Vec2 = require('lib/vector2d')

local Collider = {Class = {Projectile = 1}}

local ColliderShapes = {Point = 'point', Rect = 'rect', Circle = 'circle'}

function Collider:new(_shape, _x, _y, _w, _h)
    assert(type(_x) == 'number' and type(_y) == 'number',
           'Expected number as collider position')

    new_collider = {pos = Vec2:new(_x, _y), shape = _shape}
    new_collider.prev_pos = Vec2:new(_x, _y)
    new_collider.vel = Vec2:new(0, 0)
    self.__index = self

    if _shape == ColliderShapes.Circle then
        new_collider.radius = _w
    elseif _shape == ColliderShapes.Rect then
        new_collider.width, new_collider.height = _w, _h
    elseif _shape ~= ColliderShapes.Point then
        error('collider shape must be rect, circle or point')
    end

    return setmetatable(new_collider, self)
end

local _draw_collider = {
    ['circle'] = function(c)
        love.graphics.circle('line', c.pos.x, c.pos.y, c.radius)
    end,
    ['rect'] = function(r)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle('line', r.pos.x, r.pos.y, r.width, r.height)
    end
}

function Collider:draw() _draw_collider[self.shape](self) end

function Collider:update(dt)
    self.prev_pos = self.pos
    self.pos = self.pos + self.vel
end

function cdPointPoint(p1, p2)
    return p1.pos.x == p2.pos.x and p1.pos.y == p2.pos.y
end

function cdRectRect(r1, r2)
    return not ((r1.pos.x > r2.pos.x + r2.width) or
               (r1.pos.x + r1.width < r2.pos.x) or
               (r1.pos.y + r1.height < r2.pos.y) or
               (r1.pos.y > r2.pos.y + r2.height));
end

function cdCircCirc(c1, c2)
    return (c2.pos - c1.pos):mag() <= c1.radius + c2.radius
end

function cdPointCirc(p, c) return (c.pos - p.pos):mag() > c.radius end

function cdPointRect(p, r) return false end

function cdCircRect(c, r)
    local rCenter = vec2:new(r.pos.x + r.width / 2, r.pos.y + r.height / 2)
    local dist = rCenter - c.pos
    -- TODO: implement this    
end

local _check_collision = {
    ['circle-circle'] = cdCircCirc,
    ['point-point'] = cdPointPoint,
    ['rect-rect'] = cdRectRect,
    ['circle-rect'] = cdCircRect,
    ['point-rect'] = cdPointRect,
    ['point-circle'] = cdPointCirc
}

local _swap_args = {
    ['rect-circle'] = true,
    ['rect-point'] = true,
    ['circle-point'] = true
}

local anim_center = {
    ['circle'] = function(col, w, h)
        return col.pos.x - w / 2, col.pos.y - h / 2
    end,

    ['rect'] = function(col, w, h)
        local xOff = (w - col.width) / 2
        local yOff = (h - col.height) / 2
        return col.pos.x - xOff, col.pos.y - yOff
    end
}

local pos_center = {
    ['circle'] = function(col) return col.pos.x, col.pos.y end,
    ['rect'] = function(col)
        return col.pos.x + col.width / 2, col.pos.y + col.height / 2
    end
}

function Collider:getAnimCenter(w, h) return anim_center[self.shape](self, w, h) end

function Collider:center() return pos_center[self.shape](self) end

function Collider._check_collision(a, b)
    local key = a.shape .. '-' .. b.shape
    if _swap_args[key] then return _check_collision[key](b, a) end
    return _check_collision[key](a, b)
end

function Collider.AABB_dir(a, b)
    local dist = a.pos - b.pos
    if math.abs(dist.x) == math.abs(dist.y) then
        if dist.y > 0 then return Direction.DOWN end
        return Direction.UP
    elseif math.abs(dist.x) > math.abs(dist.y) then
        if (dist.x > 0) then return Direction.RIGHT end
        return Direction.LEFT
    end

    if dist.y > 0 then return Direction.DOWN end
    return Direction.UP
end

function Collider:delete()
    self.vel = nil 
    self.pos = nil 
end

return setmetatable(Collider, {
    __call =  function(_, s, x, y, w, h)
        return Collider:new(s, x, y, w, h)
    end
})
