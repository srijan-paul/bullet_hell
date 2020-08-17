local camera = require 'camera'
local ImgButton = Class('Button')


function ImgButton:init(x, y, w, h, img_object)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.img = img_object
    self.clickfn = nil
    self.container = nil
end

function ImgButton:draw()
    if self.img then
        lg.draw(self.img, self.x, self.y)
        return
    end
    lg.setColor(0, 0, 0, 1)
    lg.rectangle('line', self.x, self.y, self.w, self.h)
    lg.setColor(1, 1, 1, 1)
    lg.rectangle('fill', self.x, self.y, self.w, self.h)
end

function ImgButton:check_click(mx, my)
    -- convert mouse coords since camera is zoomed in
    local cx, cy = camera:toWorldX(mx), camera:toWorldY(my)
    if (cx > self.x and cx < self.x + self.w) and
        (cy > self.y and cy < self.y + self.h) then
        if self.clickfn then self:clickfn() end
        return true
    end
    return false
end

function ImgButton:onclick(fn)
    self.clickfn = fn
end

function ImgButton:emit(event, ...)
    if self.container then
        self.container:catch(event, ...)
    end
end

return ImgButton
