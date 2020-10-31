local TileMenu = require 'scene_editor.menus.tileeditor'
local MapView = require 'scene_editor.views.map'
local camera = require 'camera'
local fs = require 'scene_editor.util.fs'

local SceneEditor = Class('SceneEditor')

function SceneEditor:init(args)
  lg.setBackgroundColor(0.4, 0.88, 1.0)
  TileMenu:init(self, 10, 10)
  MapView:init(self)
  lg.setBackgroundColor(0, 0, 0, 0)
  camera:zoom(4)
  self.callbacks = {}
  self:on('tile-clicked', function(tile_index)
    MapView.current_tile = tile_index
  end)
  lg.setBackgroundColor(sugar.rgb('#778ca3'))
end

function SceneEditor:update(dt)
  if keyboard.isDown 'lctrl' then
    if keyboard.isDown('up') then
      camera:zoom(camera:get_zoom() + 0.1)
    elseif keyboard.isDown('down') then
      camera:zoom(camera:get_zoom() - 0.1)
    end
  end

  local x = Input:keydown('d') - Input:keydown('a')
  local y = Input:keydown('s') - Input:keydown('w')
  camera:move(Vec2(x * 2, y * 2))

  MapView:update(dt)
end

function SceneEditor:draw()
  camera:set()
  MapView:draw()
  camera:unset()
  TileMenu:draw()
end

function SceneEditor:mousepressed(...)
  if not TileMenu:mousepressed(...) then MapView:mousepressed(...) end
end

function SceneEditor:on(ev, fn)
  self.callbacks[ev] = fn
end

function SceneEditor:notify(event, ...)
  print('editor recieved <' .. event .. '> event')
  if self.callbacks[event] then self.callbacks[event](...) end
end

function SceneEditor:wheelmoved(x, y)
  camera:zoom(camera:get_zoom() + sugar.sign(y) * 0.1)
end

function SceneEditor:keypressed(k)
  if k == 'e' and keyboard.isDown('lctrl') then self:export_data() end
end

function SceneEditor:export_data()
  local leveldata = {}
  leveldata.tilemap = MapView:get_data()
  fs:export(leveldata)
end

return SceneEditor
