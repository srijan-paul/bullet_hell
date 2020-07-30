local Door = require 'prefabs/door'
local GameObject = require 'prefabs/gameobject'
local Drawable = require 'component/drawable'

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

local function add_floor(node)
    local world = node.world

    local floor = GameObject(world, world.width / 2, world.height / 2)
    local floor_canvas = lg.newCanvas(world.width, world.height)
    floor_canvas:renderTo(function ()
        lg.setColor(10 / 255, 20 / 255, 32 / 255)
        lg.rectangle('fill', 0, 0, world.width, world.height)
        lg.setColor(1, 1, 1, 0.4)
        for i = 0, world.width, 16 do
            lg.line(i, 0, i, world.height)
        end

        for i = 0, world.height, 16 do
            lg.line(0, i,  world.width, i)
        end
    end)
    floor:add_component(Drawable, floor_canvas)
end

return function(node)
    add_floor(node)
    add_doors(node)
end

