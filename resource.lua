local janim = require 'lib/janim'
local Resource = {Sprite = {}}

function Resource.load()
    Resource.Sprite.Player = janim.newSpriteSheet('assets/image/main_char.png', 7, 1)
end

return Resource
