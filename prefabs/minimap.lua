local Minimap = Class('Minimap')

local ALPHA = 0.6
local ROOM_WIDTH = 30
local ROOM_HEIGHT = 20

function Minimap:init(roomtree)
    self.roomtree = roomtree
    self.current_node = roomtree
    self.width = 150
    self.height = 150
end

function Minimap:draw(x, y)
    lg.setColor(0, 0, 0, ALPHA)
    lg.rectangle('fill', x, y, self.width, self.height)
    lg.setColor(1, 1, 1, ALPHA)
    lg.rectangle('line', x, y, self.width, self.height)

    lg.setColor(1, 1, 1, 0.9)
    lg.rectangle('fill', x + self.width / 2 - ROOM_WIDTH / 2,
                 y + self.width / 2 - ROOM_HEIGHT / 2, ROOM_WIDTH, ROOM_HEIGHT)
end

return Minimap
