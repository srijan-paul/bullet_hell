local camera = require 'camera'
local Button = Class('Button')

-- a button can be of different "types"
-- one that shows an image, one that displays text
-- one that draws a quad, or one where the user forgets
-- to specify the type

local button_draw = {
    none = function (btn)
        lg.setColor(0, 0, 0, 1)
        lg.rectangle('line', btn.x, btn.y, btn.w, btn.h)
        lg.setColor(1, 1, 1, 1)
        lg.rectangle('fill', btn.x, btn.y, btn.w, btn.h)
    end,

    quad = function(btn)
        lg.draw(btn.image, btn.quad, btn.x, btn.y, 0, btn.scale[1], btn.scale[2])
    end,

    image = function(btn)
        lg.draw(btn.image, btn.x, btn.y)
    end,

    text = function (btn)
        lg.print(btn.text, btn.x + 4, btn.y + 4)
    end
}

local DEFAULTS = {
    width = 32,
    height = 32,
    scale = {1, 1}
}

function Button:init(x, y, properties)
    self.x, self.y = x, y
    self.w, self.h = DEFAULTS.width, DEFAULTS.height
    self.image = properties.image
    self.clickfn = properties.onclick
    self.container = properties.container
    self.quad = properties.quad
    self.type = properties.type or 'none'
    self.scale = properties.scale or DEFAULTS.scale
end

function Button:draw()
    button_draw[self.type](self)
end

function Button:check_click(mx, my)
    -- convert mouse coords since camera is zoomed in
    if (mx > self.x and mx < self.x + self.w) and
        (my > self.y and my < self.y + self.h) then
        if self.clickfn then self:clickfn() end
        return true
    end
    return false
end

function Button:onclick(fn)
    self.clickfn = fn
end

function Button:emit(event, ...)
    if self.container then
        self.container:catch(event, ...)
    end
end

return Button
