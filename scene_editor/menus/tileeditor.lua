local BtnContainer = require 'scene_editor.gui.buttoncontainer'
local TileMenu = {}

local TILEMAP_ROWS, TILEMAP_COLS = 4, 4
local TILE_SIZE = 16

local TileMap = Resource.Image.TileMap
local TileQuads = {}

for i = 1, TILEMAP_ROWS do
    TileQuads[i] = {}
    for j = 1, TILEMAP_COLS do
        local x, y = (i - 1) * TILE_SIZE, (j - 1) * TILE_SIZE
        TileQuads[i][j] = lg.newQuad(x, y, TILE_SIZE, TILE_SIZE,
                                     TileMap:getDimensions())
    end
end

function TileMenu:init(x, y)
    self.btn_grid = BtnContainer(x, y, {
        rows = 4,
        cols = 4,
        padding = {2, 4}
    })
    for i = 1, self.btn_grid.rows do
        for j = 1, self.btn_grid.cols do
            self.btn_grid:add_button(i, j, {
                type = 'quad',
                quad = TileQuads[i][j],
                image = TileMap,
                scale = {2, 2}
            })
        end
    end
    self.quads = TileQuads
end

function TileMenu:draw() self.btn_grid:draw() end

function TileMenu:mousepressed(x, y, btn)
    if btn ~= 1 then return end
    self.btn_grid:check_click(x, y)
end

return TileMenu
