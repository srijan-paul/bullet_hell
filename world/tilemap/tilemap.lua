local Tile = require 'world/tilemap/tiles'
local Collider = require 'component/collider'

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
  lg.draw(self.canvas, 0, 0)

  -- DEBUG code:

  -- local player_pos = Vec2.ZERO()
  -- for _, ent in ipairs(self.world.entities) do
  --   if ent.id == 'player' then
  --     player_pos = ent:get_component(Collider):get_pos()
  --   end
  -- end
  --
  -- for i = 1, self.rows do
  --   for j = 1, self.cols do
  --     if self.tiles[i][j].collides then
  --       local x, y = self:toXY(i, j)
  --       lg.line(x + TILE_SIZE / 2, y + TILE_SIZE / 2, player_pos.x, player_pos.y)
  --     end
  --   end
  -- end

  --- /DEBUG code

end

function TileMap:draw_walls()

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
    if ent:has_component(Collider) then --
      self:check_collision(ent)
    end
  end
end

-- Returns the direction of an Entity-Tile collision.
-- The direction returned is the position of the tile
-- with respect to the player. So, [TILE][PLAYER] returns
-- 'left'.
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

local function resolve_collision(ent, collider, tile_topleft, dir)
  if dir == Direction.LEFT then
    ent:setx(tile_topleft.x + TILE_SIZE + collider.width / 2)

  elseif dir == Direction.RIGHT then
    ent:setx(tile_topleft.x - collider.width / 2)

  elseif dir == Direction.UP then
    ent:sety(tile_topleft.y + TILE_SIZE + collider.height / 2)

  else -- dir == Directon.DOWN
    ent:sety(tile_topleft.y - collider.width / 2)
  end

  ent:on_tile_collide(tile_topleft + Vec2(TILE_SIZE / 2, TILE_SIZE / 2))
end

function TileMap:check_collision(ent)
  local collider = ent:get_component(Collider)
  if not collider:collides_with('tile') then return end
  local collider_pos = collider:get_pos()
  local topleft = collider_pos - Vec2(collider.width / 2, collider.height / 2)

  local start_row, start_col = self:to_row_col(topleft.x, topleft.y)
  local end_row, end_col = self:to_row_col(topleft.x + collider.width,
                                           topleft.y + collider.height)
  for i = start_row, end_row do
    for j = start_col, end_col do
      if self.tiles[i][j].collides then
        local x, y = self:toXY(i, j)
        local tile_center = Vec2(x + TILE_SIZE / 2, y + TILE_SIZE / 2)
        local dir = collision_dir(tile_center - collider_pos)
        resolve_collision(ent, collider, Vec2(x, y), dir)
      end
    end
  end
end

return TileMap
