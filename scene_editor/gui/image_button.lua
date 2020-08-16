local ImgButton = Class('Button')

function ImgButton:init(x, y, w, h, img_object)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.img = img_object
    self.clickfn = nil
end

function ImgButton:draw()
    if self.img then
        lg.draw(self.img, self.x, self.y)
        return
    end
    lg.setColor(0, 0 ,0, 1)
    lg.rectangle('line', self.x, self.y, self.w, self.h)
    lg.setColor(1, 1, 1, 1)
    lg.rectangle('fill', self.x, self.y, self.w, self.h)
end

function ImgButton:check_click(mx, my)
    if (mx > self.x and mx < self.x + self.w) and
        (my > self.y and my < self.y + self.h) then
        if self.clickfn then self.clickfn() end
    end
end

function ImgButton:onclick(fn) self.clickfn = fn end

return ImgButton
