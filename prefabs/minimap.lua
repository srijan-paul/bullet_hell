local Minimap = Class('Minimap')

local ALPHA = 0.6
local ROOM_WIDTH = 30
local ROOM_HEIGHT = 20
local PADDING = 15


-- *there are probably more efficient ways to do this re-rendering each time the player enters a new node,
-- *instead of walking the entire room tree again. But I'll worry about that later

function Minimap:init(roomtree)
    self.current_node = roomtree
    self.width = 150
    self.height = 150
    self.canvas = lg.newCanvas(self.width, self.height)
    self:re_render()
end

function Minimap:draw(x, y)
    lg.setColor(0, 0, 0, ALPHA)
    lg.rectangle('fill', x, y, self.width, self.height)
    lg.setColor(1, 1, 1, ALPHA)
    lg.rectangle('line', x, y, self.width, self.height)
    sugar.push_translate(x, y)
    lg.draw(self.canvas, 0, 0)
    sugar.pop()
end

local function get_draw_coords(prev_coords, dir)
    if dir == Direction.LEFT then
        return {x = prev_coords.x - ROOM_WIDTH - PADDING, y = prev_coords.y}
    end

    if dir == Direction.RIGHT then
        return {x = prev_coords.x + ROOM_WIDTH + PADDING, y = prev_coords.y}
    end

    if dir == Direction.UP then
        return {x = prev_coords.x, y = prev_coords.y - ROOM_HEIGHT - PADDING}
    end

    return {x = prev_coords.x, y = prev_coords.y + ROOM_HEIGHT + PADDING}
end

-- Do a depth first traversal on the room graph to
-- re-render the whole mini map taking explored and uneplored
-- rooms into account.

function Minimap:re_render()
    local root = self.current_node
    local stack = sugar.stack()

    local draw_coords = {
        x = self.width / 2 - ROOM_WIDTH / 2,
        y = self.height / 2 - ROOM_HEIGHT / 2
    }

    stack:push({root, draw_coords})

    local visited_nodes = {}

    self.canvas:renderTo(function()
        lg.clear()
        lg.setColor(1, 1, 1, 1)
        while not stack:is_empty() do
            local data = stack:pop()
            local node = data[1]
            draw_coords = data[2]
            visited_nodes[node] = true

            if not node.explored then goto draw end

            for dir, child in pairs(node.children) do
                if not visited_nodes[child] then
                    visited_nodes[child] = true
                    stack:push({child, get_draw_coords(draw_coords, dir)})
                end
            end

            ::draw::

            lg.setColor(1, 1, 1, 1)
            if node.active then
                lg.rectangle('fill', draw_coords.x, draw_coords.y, ROOM_WIDTH,
                             ROOM_HEIGHT)
            elseif node.explored then
                lg.rectangle('line', draw_coords.x, draw_coords.y, ROOM_WIDTH,
                             ROOM_HEIGHT)
            else
                lg.setColor(1, 0.7, 0.8, 0.5)
                lg.rectangle('fill', draw_coords.x, draw_coords.y, ROOM_WIDTH,
                             ROOM_HEIGHT)
            end

            if node.explored then
                if node.children[Direction.DOWN] then
                    local x = draw_coords.x + ROOM_WIDTH / 2
                    local y = ROOM_HEIGHT + draw_coords.y
                    lg.line(x, y, x, y + PADDING)
                end

                -- if node.children[Direction.UP] then
                --     local x = draw_coords.x + ROOM_WIDTH / 2
                --     local y = draw_coords.y
                --     lg.line(x, y, x, y - PADDING)
                -- end

                if node.children[Direction.LEFT] then
                    local x = draw_coords.x
                    local y = draw_coords.y + ROOM_HEIGHT / 2
                    lg.line(x, y, x - PADDING, y)
                end

            end

        end
    end)

end

return Minimap
