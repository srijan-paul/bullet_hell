local World = require 'world/world'

local LevelGenerator = Class('LevelGenerator')

local function new_node(world)
    return {
        world = world,
        children = {}
    }
end


function LevelGenerator:init(roomcount)
    self.to_generate = roomcount
    self.room_tree = new_node(World())
    self.current_node = self.room_tree
    self.stack = sugar.stack()
    self.stack:push(self.current_node)
end

local function add_child(node, child)
    local dirs = {'left', 'right', 'up', 'down'}

    for i = 1, #dirs do
        local dir = dirs[i]
        if not node.children[dir] then
            node.children[dir] = child
            return dir
        end
    end
    return false
end


function LevelGenerator:generate()
    while self.to_generate ~= 0 do
        self:tick()
    end
    return self.room_tree
end


function LevelGenerator:tick()
    local node = self.stack:pop()
    local childcount = math.random(0, sugar.clamp(self.to_generate, 0, 3))
    for _ = 1, childcount do
        local child = new_node(World())
        add_child(node, child)
        self.to_generate = self.to_generate - 1
        self.stack:push(child)
    end
end

return LevelGenerator