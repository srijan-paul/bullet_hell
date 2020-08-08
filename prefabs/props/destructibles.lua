local cmp = require 'component/common'
local Explosion = require 'prefabs/explosion'

return {
    ExplosiveBarrel = {
        drawable = {cmp.Sprite, Resource.Image.Barrel},
        size = {10, 10},
        hp = 1,
        scale = {0.9, 0.9},
        on_damage = function(d, dmg)
            local pos = d:get_pos()
            Explosion(d.world, pos.x, pos.y)
            Resource.Sound.Explode:play()
            -- explosion damage
            local nearby = d.world:query('circle', pos.x, pos.y, 15)
            sugar.foreach(nearby, function(gameobj)
                if type(gameobj.damage) == 'function' and gameobj ~= d then
                    gameobj:damage(d.dmg, pos, 30)
                end
            end)
            d:delete()
        end,
        damage = 10
    }
}
