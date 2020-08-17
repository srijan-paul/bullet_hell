local BtnContainer = require 'scene_editor.gui.img_btn_container'
local SceneEditor = Class('SceneEditor')
local camera = require 'camera'

function SceneEditor:init(args)
    love.graphics.setBackgroundColor(0.4, 0.88, 1.0)
	self.btns = BtnContainer(10, 10, {
        rows = 3, cols = 3
    })
    lg.setBackgroundColor(0, 0, 0, 0)
    camera:zoom(2)
end

function SceneEditor:update(dt)

end

function SceneEditor:draw()
    camera:set()
    -- draw the map
    camera:unset()
    self.btns:draw()
end

function SceneEditor:mousepressed(x, y, button)
    self.btns:check_click(x, y)
end

return SceneEditor