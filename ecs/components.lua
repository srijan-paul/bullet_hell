local Components = {}
local janim = require 'lib/janim'
local Concord = require 'lib/concord'

Components.Transform = Concord.component(function(c, x, y, r, sx, sy)
    c.pos = Vec2(x or 0, y or 0)
    c.rotation = r or 0
    c.scale = Vec2(sx or 1, sy or 1)
end)

Components.Velocity = Concord.component(function(c, x, y)
    c.velocity = Vec2(x, y)
end)

Components.Collider = Concord.component(function(c, class, shape, width, height)
    if shape == 'circle' then
        c.radius = width
        return c
    end
    c.width = width
    c.height = height
    c.class = class
end)

-- AnimatedSprite component
-- * spritesheet: a jAnim spritesheet object (NOT a love2d image/quad or a path to image)
-- * anims: a table where each element is {<animation name>, <start_frame>, <end frame>, <duration>, <loop>}

Components.AnimatedSprite = Concord.component(function (c, spritesheet, ...)
    c.sheet = spritesheet
    c.anims = {}

    local args = {...}

    for i = 1, #args do 
        local anim = args[i]
        c.anims[anim[1]] = janim:new(c.sheet, anim[2], anim[3],  anim[4], anim[5])
    end
    c.current = c.anims[args[1][1]]
end)

return Components