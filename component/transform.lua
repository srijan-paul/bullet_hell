function Transform(x, y, r, sx, sy)
    return {
        pos = Vec2(x, y),
        rotation = r or 0,
        scale = Vec2(sx or 1, sy or 1)
    }
end


return Transform