local janim = require 'lib/janim'
local Resource = {Sprite = {}, Image = {}, Sound = {}, UI = {}}

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
    Resource.Sound.Explode = love.audio.newSource('assets/sound/explosion_2.wav', 'static')
    -- Resource.Sound.laser:setVolume(0.5)
    Resource.Sound.PlayerHurt = love.audio.newSource('assets/sound/player_hurt.wav', 'static')
    -- Resource.Sound.PlayerHurt:setVolume(0.5)
    Resource.Sound.EnemyHurt = love.audio.newSource('assets/sound/enemy_hurt.wav', 'static')
    -- Resource.Sound.EnemyHurt:setVolume(0.5)
    Resource.Sound.BulletTileHit = love.audio.newSource('assets/sound/bullet_hit_wall.wav', 'static')
    -- Resource.Sound.BulletTileHit:setVolume(0.5)
    Resource.Sound.FlyAttack = love.audio.newSource('assets/sound/385049__mortisblack__attack.ogg', 'static')
    Resource.Sound.FlyAttack:setVolume(0.5)
    Resource.Sound.Track1 = love.audio.newSource('assets/sound/spaceship.wav', 'stream')
    Resource.Sound.Track1:setLooping(true)

    -- UI
    Resource.UI.BtnPlaceHolder = love.graphics.newImage('assets/image/placeholder_btn.png')

    -- TileMap
    Resource.Image.TileMap = love.graphics.newImage('assets/image/tilesheet.png')
end

return Resource
