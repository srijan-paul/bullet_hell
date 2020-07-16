local Collider = require('ecs/collider')

local Grid = {}

function Grid:new(_world, rows, cols)
    local grid = {}
    self.__index = self
    grid.world = _world -- world which the grid belongs too
    grid.rows, grid.cols = rows, cols
    grid.cellWidth = _world.width / grid.cols
    grid.cellHeight = _world.height / grid.rows
    grid.cells = {}
    for i = 1, grid.rows do
        grid.cells[i] = {}
        for j = 1, grid.cols do grid.cells[i][j] = {} end
    end
    setmetatable(grid, self)
    return grid
end

local _insert_shape = {
    ['rect'] = function(body, grid)
        local collider = body.collider
        local pos = body.collider.pos
        --[[ 
        finding the row and column of the min and max cell locations.
        An entity can span multiple grid cells, so I need to find out :
        -> the row and column where the TOP LEFT corner of the entity ends up 
        -> the last column that the entity takes up
        -> the last row that the entity takes up
        --]]

        local row, col = grid:to_row_col(pos.x, pos.y)
        local endRow, endCol = grid:to_row_col(pos.x + collider.width,
                                               pos.y + collider.height)

        for i = row, endRow do
            for j = col, endCol do
                table.insert(grid.cells[i][j], body)
            end
        end
        -- There is probably a more efficient solution out there 
        -- than doing this if check every time I insert
        -- but I'll look for micro optimizations later
        -- (Note: later = never)
    end,
    ['circle'] = function(body, grid)
        local collider = body.collider
        local pos = body.collider.pos

        local startRow, startCol = grid:to_row_col((pos.x - collider.radius),
                                                   (pos.y - collider.radius))
        local endRow, endCol = grid:to_row_col((pos.x + collider.radius),
                                               pos.y + collider.radius)

        for i = startRow, endRow do
            for j = startCol, endCol do
                table.insert(grid.cells[i][j], body)
            end
        end

    end
}

function Grid:to_row_col(_x, _y)
    local col = math.floor(_x / self.cellWidth) + 1
    local row = math.floor(_y / self.cellHeight) + 1

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

function Grid:insert(body) _insert_shape[body.collider.shape](body, self) end

function Grid:draw()
    for i = 1, self.rows do
        for j = 1, self.cols do
            love.graphics.setColor(1, 1, 1, 0.1)
            local x, y = (j - 1) * self.cellWidth, (i - 1) * self.cellHeight
            local w, h = self.cellWidth, self.cellHeight
            love.graphics.rectangle('line', x, y, w, h)
            if #self.cells[i][j] > 0 then
                love.graphics.setColor(1, 1, 1, 0.1 * #self.cells[i][j])
                love.graphics.rectangle('fill', x, y, w, h)
            end
            local centerX = x + self.cellWidth / 2 - 10
            local centerY = y + self.cellHeight / 2 - 10
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(#self.cells[i][j], centerX, centerY)
        end
    end
end

function Grid:clear()
    for i = 1, self.rows do
        self.cells[i] = {}
        for j = 1, self.cols do self.cells[i][j] = {} end
    end
end

function updateCell(cell)
    for i = 1, #cell do
        cell[i].collider.pos = cell[i].collider.pos + cell[i].collider.vel
    end
end

function Grid:update(dt)
    for i = 1, self.rows do
        for j = 1, self.cols do updateCell(self.cells[i][j]) end
    end
end

local grid_query = {
    ['circle'] = function(grid, pos, radius)
        local startRow, startCol = grid:to_row_col((pos.x - radius),
                                                   (pos.y - radius))
        local endRow, endCol = grid:to_row_col((pos.x + radius), pos.y + radius)

        local cells = {}
        for i = startRow, endRow do
            for j = startCol, endCol do
                for k = 1, #grid.cells[i][j] do
                    table.insert(cells, grid.cells[i][j][k])
                end
            end
        end
        return cells
    end

}

function Grid:query(shape, pos, width, height)
    return grid_query[shape](self, pos, width)
end

function Grid:process_collisions()
    for i = 1, self.rows do
        for j = 1, self.cols do
            local cell = self.cells[i][j]
            for k = 1, #cell do
                for l = 1, #cell do
                    if k == l or not cell[k].collider or not cell[l].collider then
                        goto continue
                    end
                    if Collider.check_collision(cell[k].collider,
                                                cell[l].collider) then
                        self.world:resolve_collision(cell[k], cell[l],
                                                     Collider.AABB_dir(
                                                         cell[k].collider,
                                                         cell[l].collider))
                    end
                    ::continue::
                end
            end
        end
    end
end

return Grid
