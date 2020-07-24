local Components = require('ecs/components')


local Player = Concord.assemblage(function(e, x, y)
    e
    :give(Components.Transform, x, y)
    :give(Components.AnimatedSprite, Resource.Sprite.Player,
        {'idle', 1, 2, 0.2, true},
        {'walk', 3, 7, 0.1, true})
    :give(Components.Velocity, 0, 0)
end)

return Player
