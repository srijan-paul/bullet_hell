local imgbtn = require 'scene_editor.gui.button'
local btncontainer = Class('ButtonContainer')

local default_opts = {
    rows = 1,
    cols = 1,
    xpadding = 1,
    ypadding = 1
}

local  BTN_DEFAULTS  = {
    width = 32,
    height = 32,
    image = Resource.UI.BtnPlaceHolder,
    type = 'image'
}

function btncontainer:init(x, y, properties)
    self.x, self.y = x, y

    for k, _ in pairs(default_opts) do
        self[k] = properties[k] and properties[k] or default_opts[k]
    end

    self.btn_props = properties.button or BTN_DEFAULTS

    local tx, ty = self.x, self.y
    self.buttons = {}
    for i = 1, self.rows do
        self.buttons[i] = {}
        for j = 1, self.cols do
            self.buttons[i][j] = imgbtn(tx, ty, self.btn_props)
            self.buttons[i][j].container = self
            tx = tx + self.btn_props.width + self.xpadding
        end
        tx = self.x
        ty = ty + self.btn_props.height + self.ypadding
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
