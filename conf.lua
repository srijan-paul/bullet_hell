Vec2 = require 'lib/vector2'
Class = require 'lib/middleclass/middleclass'
Timer = require 'lib/vrld/timer'
_G.sugar = require 'lib/sugar'
_G.Concord = require 'lib/concord'
_G.Resource = require 'resource'

-- Global variables (Game Contants)

_G.Direction = {
    LEFT = 'left',
    RIGHT = 'right',
    UP = 'up',
    DOWN = 'down'
}

function love.conf(t)
    t.console = true
    return t
end