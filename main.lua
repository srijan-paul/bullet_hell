local Room = require 'world.room'


local room
function love.load()
    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(0.96, 1, 0.95)
    Resource.load()
    room = Room()
end

function love.draw()
    room:draw()
end

function love.update(dt)
    room:update(dt)
end
