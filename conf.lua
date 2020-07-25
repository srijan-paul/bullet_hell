Vec2 = require 'lib/vector2'
Class = require 'lib/middleclass/middleclass'
Timer = require 'lib/vrld/timer'
_G.util = require 'lib/util'
_G.Concord = require 'lib/concord'
_G.Resource = require 'resource'

function love.conf(t)
    t.console = true
    return t
end