local TileMenu = require 'scene_editor.menus.tileeditor'
local SceneEditor = Class('SceneEditor')
local camera = require 'camera'

function SceneEditor:init(args)
    love.graphics.setBackgroundColor(0.4, 0.88, 1.0)
	TileMenu:init(100, 100)
    lg.setBackgroundColor(0, 0, 0, 0)
    camera:zoom(2)
end

function SceneEditor:update(dt)

end

function SceneEditor:draw()
    camera:set()
    -- draw the map
    camera:unset()
    TileMenu:draw()
end

function SceneEditor:mousepressed(...)
    TileMenu:mousepressed(...)
end

return SceneEditor