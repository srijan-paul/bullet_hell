local Tile = require 'world/tilemap/tiles'

local TILE_SIZE = 16
local TileMap = Class('TileMap')

function TileMap:init(world, rows, cols)
    self.tiles = {}
    self.world = world
    self.rows = rows
    self.cols = cols
    for i = 1, rows do
        self.tiles[i] = {}
        for j = 1, cols do
            self.tiles[i][j] = Tile.Create(Tile.Type.WALL, false)
        end
    end
    self:composite()
end

function TileMap:composite()
    local canvas = lg.newCanvas(self.world.width, self.world.height)
    canvas:renderTo(function ()
        for i = 1, self.rows do
            for j = 1, self.cols do
                local x, y = self:toXY(i, j)
                Tile.Draw(self.tiles[i][j], x, y)
            end
        end
    end)
    self.canvas = canvas
end

function TileMap:draw()
    lg.draw(self.canvas, 0, 0)
end

function TileMap:toRowCol(_x, _y)
    local col = math.floor(_x / Tile.SIZE) + 1
    local row = math.floor(_y / Tile.SIZE) + 1

    if row > self.rows then
        row = self.rows
    elseif row < 1 then
        row = 1
    end

    if col > self.cols then
        col = self.cols
    elseif col < 1 then
        col = 1
    end
    return row, col
end

function TileMap:toXY(r, c) return (c - 1) * TILE_SIZE, (r - 1) * TILE_SIZE end

function TileMap:_physics_process(dt) end

return TileMap
