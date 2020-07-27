local janim = require 'lib/janim'
local Resource = {Sprite = {}}

function Resource.load()
    Resource.Sprite.Player = janim.newSpriteSheet('assets/image/player_yellow.png', 12, 1)
end

return Resource
