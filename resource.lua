local janim = require 'lib/janim'
local Resource = {Sprite = {}, Image = {}}

function Resource.load()
    Resource.Sprite.Player = janim.newSpriteSheet('assets/image/player_yellow.png', 12, 1)
    Resource.Image.Handgun = love.graphics.newImage('assets/image/handgun.png')
    Resource.Sprite.Bullet = love.graphics.newImage('assets/image/bullet.png')
    Resource.Image.Cursor = love.graphics.newImage('assets/image/cursor.png')
end

return Resource
