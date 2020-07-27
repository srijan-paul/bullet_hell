local GameObject = require 'prefabs/gameobject'
local cmp = require 'component/common'

local Projectile = Class('Projectile', GameObject)

function Projectile:init(owner, ptype, ...)
    GameObject.init(self, ...)
    
end

function Projectile:update(dt)
    
end


return Projectile