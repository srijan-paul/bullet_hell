local shader = require 'shader'
local Room = require 'world.room'

_G.keyboard= love.keyboard
_G.graphics = love.graphics
_G.mouse = love.mouse

local room
local CURSOR_SCALE = 4
local CURSOR_OFFSET = -4.5 * CURSOR_SCALE
-- replacing the cursor with the crosshair sprite

local crosshair

_G.mouseY = function()
    return love.mouse.getY()
end

_G.mouseX = function()
    return love.mouse.getX()
end

_G.mousePos = function()
    return Vec2(love.mouse.getX(), love.mouse.getY())
end


local function draw_cursor()
    local x = love.mouse.getX() + CURSOR_OFFSET
    local y = love.mouse.getY() + CURSOR_OFFSET
    graphics.draw(crosshair, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
end

function love.load()
    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(sugar.rgb('19202f'))
    -- print(sugar.rgb('19202f'))
    Resource.load()
    crosshair = Resource.Image.Cursor
    room = Room()
    love.graphics.setShader(shader)
    love.mouse.setVisible(false)
end


function love.draw()
    room:draw()
    draw_cursor()
end



function love.update(dt) room:update(dt) end
