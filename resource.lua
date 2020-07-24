local janim = require 'lib/janim'
local Resource = {Sprite = {}}

function Resource.load()
    Resource.Sprite.Player = janim.newSpriteSheet('assets/image/main_char_alt.png', 7, 1)
end

return Resource
