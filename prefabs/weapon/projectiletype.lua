return {
    Bullet = {
        sprite_path = 'Bullet',
        width = 5,
        height = 5,
        speed = 150,
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
    }
}