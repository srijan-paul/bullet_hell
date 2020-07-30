local GenerateRoom = require 'world/worldgen/roomgen'
local World = require 'world/world'

-- The code in this module simply generates the room/world 'tree'.
-- which is a basically an undirected graph where the nodes the rooms
-- and the edges are the doors connecting them that the player has to enter
-- to go the adjacent world

local LevelGenerator = Class('LevelGenerator')

local function new_node(world) return {world = world, children = {}} end

function LevelGenerator:init(level, roomcount)
    self.level = level
    self.to_generate = roomcount - 1 -- since we create the root right away
    self.room_tree = new_node(World(level))
    self.current_node = self.room_tree
    self.stack = sugar.stack()
    self.stack:push(self.current_node)
end

local function add_child(node, child)
    local dirs = {Direction.LEFT, Direction.RIGHT, Direction.UP, Direction.DOWN}

    for i = 1, #dirs do
        local dir = dirs[i]
        if not node.children[dir] then
            node.children[dir] = child
            child.children[OppositeDirection(dir)] = node
            return dir
        end
    end
    return false
end

function LevelGenerator:generate()
    while not self.stack:is_empty() do self:tick() end
    return self.room_tree
end

function LevelGenerator:tick()
    local node = self.stack:pop()
    local childcount = math.random(1, sugar.clamp(self.to_generate, 0, 3))

    if self.to_generate == 0 then goto skip end

    for _ = 1, childcount do
        local child = new_node(World(self.level))
        add_child(node, child)
        self.to_generate = self.to_generate - 1
        self.stack:push(child)
    end

    ::skip::
    GenerateRoom(node)  
end

return LevelGenerator
