local janim = require 'lib/janim'
local Resource = {Sprite = {}, Image = {}, Sound = {}}

function Resource.load()
    Resource.Sprite.Player = janim.newSpriteSheet('assets/image/player_yellow.png', 12, 1)
    Resource.Sprite.Fly = janim.newSpriteSheet('assets/image/fly.png', 5, 1)
    Resource.Sprite.BlastRed = janim.newSpriteSheet('assets/image/explosion_red.png', 14, 1)
    
    Resource.Image.Bullet = love.graphics.newImage('assets/image/bullet_blue.png')
    Resource.Image.Handgun = love.graphics.newImage('assets/image/handgun.png')
    Resource.Image.Cursor = love.graphics.newImage('assets/image/cursor.png')
    Resource.Image.Door = love.graphics.newImage('assets/image/door.png')
    Resource.Image.Stinger = love.graphics.newImage('assets/image/stinger.png')
    Resource.Image.HealthIcon = love.graphics.newImage('assets/image/health_icon.png')
    Resource.Image.Ball = love.graphics.newImage('assets/image/ball.png')
    Resource.Image.FlyCorpse = love.graphics.newImage('assets/image/fly_corpse.png')
    Resource.Image.StingerCorpse = love.graphics.newImage('assets/image/stinger_corpse.png')
    Resource.Image.Barrel = love.graphics.newImage('assets/image/explosive_barrel.png')
    -- Audio
    Resource.Sound.laser = love.audio.newSource('assets/sound/421704__bolkmar__sfx-laser-shoot-02.wav', 'static')
    -- sound credit: https://freesound.org/people/OwlStorm/sounds/404754/ [Owlstorm]
    Resource.Sound.Explode = love.audio.newSource('assets/sound/404754__owlstorm__retro-video-game-sfx-explode.wav', 'static')
    Resource.Sound.laser:setVolume(0.5)
end

return Resource
