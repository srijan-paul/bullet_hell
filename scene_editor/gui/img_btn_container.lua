local imgbtn = require 'scene_editor.gui.image_button'
local btncontainer = Class('ButtonContainer')

local default_opts = {
    rows = 1, cols = 1,
    button_width = 20,
    button_height = 20
}

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
            tx = tx + self.button_width
        end
        tx = self.x
        ty = ty + self.button_height
    end
end

function btncontainer:draw()
    for r = 1, #self.buttons do
        for c = 1, #self.buttons[r] do self.buttons[r][c]:draw() end
    end
end

function btncontainer:add_button(row, col, clickfn) end

return btncontainer
