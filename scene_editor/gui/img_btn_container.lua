local imgbtn = require 'scene_editor.gui.image_button'
local btncontainer = Class('ButtonContainer')

local default_opts = {rows = 1, cols = 1, button_width = 32, button_height = 32}

function btncontainer:init(x, y, properties)
    self.x, self.y = x, y

    for k, _ in pairs(default_opts) do
        self[k] = properties[k] and properties[k] or default_opts[k]
    end

    self.buttons = {}
    local tx, ty = self.x, self.y
    for i = 1, self.rows do
        self.buttons[i] = {}
        for j = 1, self.cols do
            self.buttons[i][j] = imgbtn(tx, ty, self.button_width,
                                        self.button_height)
            self.buttons[i][j].container = self
            tx = tx + self.button_width
        end
        tx = self.x
        ty = ty + self.button_height
    end

    self.event_listeners = {}

end

function btncontainer:draw()
    for r = 1, #self.buttons do
        for c = 1, #self.buttons[r] do self.buttons[r][c]:draw() end
    end
end

function btncontainer:add_button(row, col, clickfn)
    if (row < 1 or row > self.rows) or (col < 1 or col > self.cols) then
        return
    end
    local x = self.x + (row - 1) * self.button_width
    local y = self.x + (row - 1) * self.button_height
    local btn = imgbtn(x, y, self.button_width, self.button_height)
    self.buttons[row][col] = btn
    if clickfn then btn:onclick(clickfn) end
    btn.container = self
end

function btncontainer:check_click(mx, my)
    for i = 1, #self.buttons do
        for j = 1, #self.buttons[i] do
            self.buttons[i][j]:check_click(mx, my)
        end
    end
end

function btncontainer:catch(event, ...)
    if self.event_listeners[event] then self.event_listeners[event](...) end
end

return btncontainer
