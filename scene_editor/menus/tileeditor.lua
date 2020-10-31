local BtnContainer = require 'scene_editor.gui.buttoncontainer'
local Tile = require 'world.tilemap.tiles'

local TileMenu = {}

function TileMenu:init(editor, x, y)
  self.btn_grid = BtnContainer(x, y, {
    rows = Tile.MAP_ROWS,
    cols = Tile.MAP_COLS,
    padding = {2, 4}
  })

  self.editor = editor

  for i = 1, self.btn_grid.rows do
    for j = 1, self.btn_grid.cols do
      self.btn_grid:add_button(i, j, {
        type = 'quad',
        quad = Tile.Quads[i][j],
        image = Tile.Map,
        scale = {2, 2},
        onclick = function(b)
          local t = sugar.index_of(Tile.Id_Q, Tile.Quads[i][j])
          self.editor:notify('tile-clicked', t)
        end
      })

    end
  end

  self.quads = Tile.Quads
end

function TileMenu:draw()
  lg.setColor(1, 1, 1, 1)
  self.btn_grid:draw()
end

function TileMenu:mousepressed(x, y, btn)
  if btn ~= 1 then return end
  return self.btn_grid:check_click(x, y)
end

return TileMenu
