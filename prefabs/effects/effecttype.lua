return {
    Block = function(color, w, h)
        w = w or 15
        h = h or 15
        local canvas = lg.newCanvas(w, h)
        canvas:renderTo(function()
            if color then
                lg.setColor(color[1], color[2], color[3], color[4] or 1)
            else
                lg.setColor(1, 0.1, 0.3, 1)
            end
            lg.rectangle('fill', 1, 1, w - 1, h - 1)
        end)
        return canvas
    end
}
