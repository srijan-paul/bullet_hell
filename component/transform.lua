local transform_meta = {
    __tostring = function(t)
        return 'position: ' .. tostring(t.pos) .. '\nrotation: ' ..
                   tostring(t.rotation) .. '\nscale: ' .. tostring(t.scale)
    end
}

local function Transform(owner, x, y, r, sx, sy)
    return setmetatable({
        owner = owner,
        pos = Vec2(x, y),
        rotation = r or 0,
        scale = Vec2(sx or 1, sy or 1)
    }, transform_meta)
end

return Transform
