local ProjectileType = require 'prefabs/weapon/projectiletype'

return {
  HandGun = {
    sprite_path = 'Handgun',
    projectile = ProjectileType.Bullet,
    cooldown = 0.17,
    damage = 3,
    auto = false,
    sound = 'laser',
    speed = 200,
    knockback = 30,
    muzzle_offset = Vec2(5, 3)
  }
}
