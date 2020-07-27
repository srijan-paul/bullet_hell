--[[
MIT License

Copyright (c) 2020 Srijan Paul

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local Vector2 = {}

Vector2.__add =
    function(v1, v2) return Vector2:new(v1.x + v2.x, v1.y + v2.y) end

Vector2.__mul = function(v1, v2)
    if type(v1) == 'number' then return Vector2:new(v1 * v2.x, v1 * v2.y) end
    if type(v2) == 'number' then return Vector2:new(v2 * v1.x, v2 * v1.y) end
    return Vector2:new(v1.x * v2.x, v1.y * v2.y)
end

Vector2.__sub =
    function(v1, v2) return Vector2:new(v1.x - v2.x, v1.y - v2.y) end

Vector2.__unm = function(v) return Vector2:new(-v.x, -v.y) end

Vector2.__eq = function(v1, v2) return v1.x == v2.x and v1.y == v2.y end

Vector2.__tostring =
    function(v) return '{x = ' .. v.x .. ', y = ' .. v.y .. '}' end

Vector2.__lt = function(v1, v2) return v1:mag() < v2:mag() end

Vector2.__le = function(v1, v2) return v1:mag() <= v2:mag() end

Vector2.__gt = function(v1, v2) return v1:mag() < v2:mag() end

Vector2.__ge = function(v1, v2) return v1:mag() >= v2:mag() end


function Vector2:new(_x, _y)
    local newVec = {}

    assert(type(_x) == 'number' and type(_y) == 'number',
           'Expected number as vector dimension')

    newVec.x, newVec.y = _x, _y
    self.__index = self
    return setmetatable(newVec, self)
end


function Vector2.from_polar(r, theta)
    return r * math.cos(theta), r * math.sin(theta)
end

function Vector2:mag() 
    return math.sqrt(self.x * self.x + self.y * self.y) 
end


function Vector2:normalized()
    local root = math.sqrt(self.x * self.x + self.y * self.y)
    if root == 0 then return Vector2:new(0, 0) end
    return Vector2:new(self.x / root, self.y / root)
end


function Vector2:rotated(angle)
    -- https://matthew-brett.github.io/teaching/rotation_2d.html for reference
    local x2 = math.cos(angle) * self.x - math.sin(angle) * self.y
    local y2 = math.sin(angle) * self.x + math.cos(angle) * self.y
    return Vector2:new(x2, y2)
end


function Vector2:rotate(angle)
    local x2 = math.cos(angle) * self.x - math.sin(angle) * self.y
    local y2 = math.sin(angle) * self.x + math.cos(angle) * self.y
    self.x = x2
    self.y = y2
end


function Vector2:set_mag(n)
    local root = math.sqrt(self.x * self.x + self.y * self.y)
    self.x = n * (self.x / root)
    self.y = n * (self.y / root)
end


function Vector2:with_mag(n)
    local root = math.sqrt(self.x * self.x + self.y * self.y)
    local x = n * (self.x / root)
    local y = n * (self.y / root)
    return Vector2:new(x, y)
end


function Vector2.random_unit(n)
    local x = math.random(-10, 10)
    local y = math.random(-10, 10)
    local vec = Vector2:new(x, y)
    vec:setMag(1)
    return vec
end

function Vector2:angle(vec) 
    if vec then 
        return math.atan2(self.y, self.x) - math.atan2(vec.y, vec.x)
    end
    return math.atan2(self.y, self.x) 
end


function Vector2:angle_to(vec)
    return math.atan2(self.y, self.x) - math.atan2(vec.y, vec.x) 
end


function Vector2:clone(vec)
    return Vector2:new(vec.x, vec.y)
end


function Vector2:unpack()
    return self.x, self.y
end

-- test code
-- local v1 = Vector2:new(1, 1)
-- local v2 = Vector2:new(1, 2)
-- print(v2 * 2)

Vector2.LEFT = function() return Vector2:new(-1, 0) end
Vector2.RIGHT = function() return Vector2:new(1, 0) end
Vector2.UP = function() return Vector2:new(0, -1) end
Vector2.DOWN = function() return Vector2:new(0, 1) end
Vector2.ZERO = function() return Vector2:new(0, 0) end


return setmetatable(Vector2, {
    __call = function(_, x, y)
        return Vector2:new(x, y)
    end
})
