return {
    Bullet = {
        width = 5,
        height = 5,
        render = function ()
            local canvas = love.graphics.newCanvas(10, 4)
            canvas:renderTo(function ()
                graphics.setColor(1, 1, 1, 1)
                graphics.rectangle('fill', 0, 0, 10, 4)
                graphics.setColor(sugar.rgb('#18dcff'))
                graphics.rectangle('fill', 0, 0, 4, 4)
            end)
            return canvas
        end
    },
    Sting = {
        width = 2,
        height = 2,
        render = function ()
            local canvas = love.graphics.newCanvas(10, 1)
            canvas:renderTo(function ()
                lg.setColor(1, 0, 0.2, 1)
                lg.rectangle('fill', 0, 0, 10, 2)
                -- graphics.rectangle('fill', 0, 0, 4, 4)
            end)
            return canvas
        end
    }
}