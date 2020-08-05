local ProjectileType = require 'prefabs/weapon/projectiletype'

return {
    HandGun = {
        sprite_path = 'Handgun',
        projectile = ProjectileType.Bullet,
        cooldown = 0.25,
        damage = 3,
        auto = false,
        sound = 'laser',
        speed = 150
    }
}