local Tile = require 'world/tilemap/tiles'
local collider = require 'component/collider'

local TILE_SIZE = 16
local TileMap = Class('TileMap')

function TileMap:init(world, rows, cols, tiledata)
  self.tiles = {}
  self.world = world
  self.rows = rows
  self.cols = cols
  self.tiles = tiledata
  self:composite()
end

function TileMap:composite()
  local canvas = lg.newCanvas(self.world.width, self.world.height)
  canvas:renderTo(function()
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
  lg.setColor(1, 1, 1, 1)
  -- lg.rectangle("fill", 100, 100, 100, 100)
  lg.draw(self.canvas, 0, 0)

  -- DEBUG code:
  for i = 1, self.rows do
    for j = 1, self.cols do
      if self.tiles[i][j].collides then
        local x, y = self:toXY(i, j)
        lg.rectangle('line', x, y, 16, 16)
      end
    end
  end
end

function TileMap:draw_walls(arg1, arg2, arg3)

end

function TileMap:to_row_col(_x, _y)
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

function TileMap:toXY(r, c)
  return (c - 1) * TILE_SIZE, (r - 1) * TILE_SIZE
end

function TileMap:_physics_process(dt)
  for _, ent in ipairs(self.world.entities) do
    if ent:has_component(collider) then --
      self:check_collision(ent)
    end
  end
end

local function collision_dir(dist)
  if math.abs(dist.x) == math.abs(dist.y) then
    if dist.y > 0 then return Direction.DOWN end
    return Direction.UP
  elseif math.abs(dist.x) > math.abs(dist.y) then
    if (dist.x > 0) then return Direction.RIGHT end
    return Direction.LEFT
  end

  if dist.y > 0 then return Direction.DOWN end
  return Direction.UP
end

function TileMap:check_collision(ent)
  local collider = ent:get_component(collider)
  if not collider:collides_with('tile') then return end
  local collider_pos = collider:get_pos()
  local ent_tl = collider_pos - Vec2(collider.width / 2, collider.height / 2)

  local start_row, start_col = self:to_row_col(ent_tl.x, ent_tl.y)
  local end_row, end_col = self:to_row_col(ent_tl.x + collider.width,
                                           ent_tl.y + collider.height)
  for i = start_row, end_row do
    for j = start_col, end_col do
      if self.tiles[i][j].collides then
        local x, y = self:toXY(start_col, start_row)
        local dir = collision_dir(Vec2(x + TILE_SIZE / 2, y + TILE_SIZE / 2) -
                                    collider_pos)
        print(dir)
      end
    end
  end
end

local collision_resolution = {
  [Direction.DOWN] = function(tile_pos, ent)

  end
}

return TileMap
