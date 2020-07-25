local Grid = Class('Grid')

local DEFAULT_ROWS, DEFAULT_COLS = 10, 10


function Grid:init(world, rows, cols)
    self.world = world
    self.rows = DEFAULT_ROWS or rows
    self.cols = DEFAULT_COLS or cols
    self.cell_width = world.width / self.cols
    self.cell_height = world.height / self.rows
    self.cells = {}
    for i = 1, self.rows do
        self.cells[i] = {}
        for j = 1, self.cols do 
            self.cells[i][j] = {}
        end
    end
end


function Grid:insert(collider)
    local pos = collider:get_pos()

    local row, col = self:toRowCol(pos.x, pos.y)
    local endRow, endCol = self:toRowCol(pos.x + collider.width,
                                        pos.y + collider.height)

    for i = row, endRow do
        for j = col, endCol do
            table.insert(self.cells[i][j], collider)
        end
    end
end

function Grid:clear()
    for i = 1, self.rows do
        self.cells[i] = {}
        for j = 1, self.cols do 
            self.cells[i][j] = {}
        end
    end
end


function Grid:toRowCol(_x, _y)
    local col = math.floor(_x / self.cell_width) + 1
    local row = math.floor(_y / self.cell_height) + 1

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

return Grid