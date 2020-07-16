local Grid = require 'grid'

local World = class('World')

local TIME_STEP = 0.016
local MAX_SPEED = 70
local MIN_SPEED = 0.8
local DEFAULT_GRID_ROWS = 10
local DEFAULT_GRID_COLS = 10

function World:init(width, height)
    assert(type(width) == 'number' and type('height') == 'number',
           'expected number as world dimension')
    self.width = width
    self.height = height
    self.entities = {}
    self.time_lag = 0
    self.self.grid = Grid(self, DEFAULT_GRID_ROWS, DEFAULT_GRID_COLS)
end

function World:update(dt)
    -- body
end

function World:draw() 
    -- body
end


return World