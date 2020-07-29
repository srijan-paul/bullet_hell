local Door = require 'prefabs/door'

local dirs = {Direction.LEFT, Direction.RIGHT, Direction.UP, Direction.DOWN}

-- adds the travel doors (graph edges) to the room of this node

local function get_door_pos(world, dir)
    if dir == Direction.LEFT then
        return Vec2(0, world.height / 2)
    end

    if dir == Direction.RIGHT then
        return Vec2(world.width, world.height / 2)
    end
    
    if dir == Direction.UP then
        return Vec2(world.width / 2, 0)
    end

    if dir == Direction.DOWN then
        return Vec2(world.width / 2, world.height)
    end

end

local function add_doors(node)
    for i = 1, #dirs do
        local dir = dirs[i]
        if node.children[dir] then
            local pos = get_door_pos(node.world, dir)
            Door(node.world, pos.x, pos.y, dir)
        end
    end
end

return function(node)
    add_doors(node)
end

