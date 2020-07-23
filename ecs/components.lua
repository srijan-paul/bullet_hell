local Components = {}
local janim = require 'lib/janim'
local Concord = require 'lib/concord'

local tinsert = table.insert
local tremove = table.remove


Components.Transform = Concord.component(function(c, x, y, r, sx, sy)
    c.pos = Vec2(x or 0, y or 0)
    c.r = r or 0
    c.scale = Vec2(sx or 0, sy or 0)
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

Components.AnimatedSprite = Concord.component(function (c, spritesheet, anims)
    c.sheet = spritesheet
    c.anims = {}

    for i = 1, #anims do 
        local anim = anims[i]
        c.anims[anim[1]] = janim:new(c.sheet, anim[2], anim[3],  anim[4], anim[5])
    end
    c.current = c.anims[1]

end)

return Components