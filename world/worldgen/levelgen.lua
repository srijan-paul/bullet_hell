local GenerateRoom = require 'world/worldgen/roomgen'
local World = require 'world/world'

-- The code in this module simply generates the room/world 'tree'.
-- which is a basically an undirected graph where the nodes the rooms
-- and the edges are the doors connecting them that the player has to enter
-- to go the adjacent world

local LevelGenerator = Class('LevelGenerator')

local function new_node(world)
    return {world = world, active = false, visited = true, children = {}}
end

function LevelGenerator:init(level, roomcount)
    self.level = level
    self.to_generate = roomcount - 1 -- since we create the root right away

    self.room_grid = {}

    local n = roomcount * roomcount

    for i = 1, n do
        self.room_grid[i] = {}
        for j = 1, n do self.room_grid[i][j] = false end
    end

    -- step 1: pick a random place in the array to place the
    -- starting room

    self.start_loc = Vec2(math.random(1, n), math.random(1, n))
    self.room_grid[self.start_loc.x][self.start_loc.y] =
        new_node(World(self.level))
    self.current_loc = self.start_loc:clone()

    self.current_node = self.room_tree
end

function LevelGenerator:generate()
    -- TODO rename
    while self.to_generate > 0 do self:generate_grid() end
    self:connect_rooms()
    self:generate_rooms()
    return self.room_grid[self.start_loc.x][self.start_loc.y]
end

function LevelGenerator:generate_grid()
    -- available neighbor indexes in the room grid
    local available_dirs = {}

    sugar.foreach({Vec2.LEFT(), Vec2.RIGHT(), Vec2.UP(), Vec2.DOWN()},
                  function(v)
        local index = self.current_loc + v
        if self.room_grid[index.x] and self.room_grid[index.x][index.y] ~= nil then
            table.insert(available_dirs, v)
        end
    end)

    -- pick a random direction to move in
    local dir = available_dirs[math.random(1, #available_dirs)]
    -- move in that direction and place a room there
    self.current_loc = self.current_loc + dir
    self.room_grid[self.current_loc.x][self.current_loc.y] =
        new_node(World(self.level))
    self.to_generate = self.to_generate - 1
end

local function make_connections(grid, i, j)
    local node = grid[i][j]

    if grid[i + 1] and grid[i + 1][j] then
        node.children[Direction.RIGHT] = grid[i + 1][j]
    end

    if grid[i - 1] and grid[i - 1][j] then
        node.children[Direction.LEFT] = grid[i - 1][j]
    end

    if grid[i][j + 1] then node.children[Direction.DOWN] = grid[i][j + 1] end

    if grid[i][j - 1] then node.children[Direction.UP] = grid[i][j - 1] end

end

function LevelGenerator:connect_rooms()
    for i = 1, #self.room_grid do
        for j = 1, #self.room_grid[i] do
            if self.room_grid[i][j] then
                make_connections(self.room_grid, i, j)
            end
        end
    end
end

function LevelGenerator:generate_rooms()
    sugar.foreach(self.room_grid, function(row)
        sugar.foreach(row, function(cell)
            if not cell then return end
            GenerateRoom(cell)
        end)
    end)
end

return LevelGenerator
