local BtnContainer = require 'scene_editor.gui.buttoncontainer'
local TileMenu = {}

function TileMenu:init(x, y)
    self.buttons = BtnContainer(x, y, {
        rows = 4,
        cols = 4,
        xpadding = 2,
        ypadding = 4
    })
end

function TileMenu:draw() self.buttons:draw() end

function TileMenu:mousepressed(x, y, btn)
    if btn ~= 1 then return end
    self.buttons:check_click(x, y)
end

return TileMenu
