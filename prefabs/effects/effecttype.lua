return {
    Block = function(color, w, h)
        local canvas = lg.newCanvas(w or 15, h or 15)
        canvas:renderTo(function()
            if color then
                lg.setColor(color[1], color[2], color[3], color[4] or 1)
            else
                lg.setColor(1, 0.1, 0.3, 1)
            end
            lg.rectangle('fill', 0, 0, w or 15, h or 15)
        end)
        return canvas
    end
}
