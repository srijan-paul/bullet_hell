local Tile = require 'world/tilemap/tiles'
local camera = require 'camera'

local RoomView = {}

local DEFAULTS = {rows = 10, cols = 10, screen_pos = Vec2(10, 10)}


function RoomView:init(editor, rows, cols, sp)
    self.rows = rows or DEFAULTS.rows
    self.cols = cols or DEFAULTS.cols
    self.pos = sp or DEFAULTS.screen_pos:clone()
    self.current_tile = Tile.Type.WALL
    self.mouse_in_body = false
    self.editor = editor

    self.tiles = {}
    for i = 1, self.rows do
        self.tiles[i] = {}
        for j = 1, self.cols do
            self.tiles[i][j] = Tile.Create(Tile.Type.FLOOR1)
        end
    end
end

local function draw_grid(x, y, r, c)
    for i = 1, r do
        local y1 = (i - 1) * Tile.SIZE
        lg.line(x, y + y1, x + c * Tile.SIZE, y + y1)
    end

    for i = 1, c do
        local x1 = (i - 1) * Tile.SIZE
        lg.line(x + x1, y, x + x1, y + r * Tile.SIZE)
    end
end

local function get_mouse_row_col()
    local mx, my = camera:toWorldPos(mousePos()):unpack()
    local col = math.floor(my / Tile.SIZE)
    local row = math.floor(mx / Tile.SIZE)
    return row, col
end

function RoomView:draw()
    for i = 1, self.rows do
        for j = 1, self.cols do
            local x = self.pos.x + (i - 1) * Tile.SIZE
            local y = (j - 1) * Tile.SIZE + self.pos.y
            Tile.Draw(self.tiles[i][j], x, y)
        end
    end

    if self.mouse_in_body then
        lg.setColor(1, 1, 1, 0.5)

        local row, col = get_mouse_row_col()
        local x, y = self.pos.x + (row - 1) * Tile.SIZE,
                     self.pos.y + (col - 1) * Tile.SIZE
        lg.draw(Tile.Map, Tile.GetQuad(self.current_tile), x, y)
    end

    lg.setColor(1, 1, 1, 0.5)
    -- draw_grid(self.pos.x, self.pos.y, self.rows, self.cols)
end

function RoomView:update(dt)
    local mx, my = camera:toWorldPos(mousePos()):unpack()
    self.mouse_in_body = ((mx > self.pos.x) and
                             (mx < self.pos.x + self.pos.x + self.rows *
                                 Tile.SIZE)) and
                             ((my > self.pos.y) and
                                 (my < self.pos.y + self.cols * Tile.SIZE))
end

function RoomView:add_tile(r, c, t_type)
    if r < 1 or r > self.rows or c < 0 or c > self.cols then return end
    self.tiles[r][c] = Tile.Create(t_type)
end

function RoomView:mousepressed(x, y, btn)
    if btn == 1 and self.mouse_in_body then
        local r, c = get_mouse_row_col()
        self:add_tile(r, c, self.current_tile)
    end
end

function RoomView:get_data()
    return self.tiles
end

return RoomView
