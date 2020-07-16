graphics = love.graphics

p = Vec2(0, 0)
v = Vec2(1, 1)

function love.load()
    
end

function love.draw()
    graphics.circle('fill', p.x, p.y, 10, 10)
    p = p + v
end

function love.update(dt)
    -- body
end