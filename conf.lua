Vec2 = require 'lib/vector2'
Class = require 'lib/middleclass/middleclass'
Timer = require 'lib/vrld/timer'
_G.sugar = require 'lib/sugar'
_G.Resource = require 'resource'
_G.util = require 'misc/util'

-- Global variables (Game Contants)

_G.Direction = {LEFT = 'left', RIGHT = 'right', UP = 'up', DOWN = 'down'}

_G.RandomDir = function()
    local dirs = {'left', 'right', 'up', 'down'}
    return dirs[math.random(1, 4)]
end

_G.OppositeDirection = function(dir)
    if dir == Direction.LEFT then return Direction.RIGHT end
    if dir == Direction.RIGHT then return Direction.LEFT end
    if dir == Direction.UP then return Direction.DOWN end
    if dir == Direction.DOWN then return Direction.UP end
end

_G.NATIVE_WIDTH = 800
_G.NATIVE_HEIGHT = 600

_G.settings = {fullscreen = false}

function love.conf(t)
    t.window.fullscreen = false
    t.window.title = 'Mad carbon'
    t.console = true
    return t
end
