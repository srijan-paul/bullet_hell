local Anim = require 'lib/janim'
local Transform = require 'component/transform'
local AnimatedSprite = Class('AnimatedSprite')

function AnimatedSprite:init(owner, spritesheet, anims)
    self.owner = owner
    self._sheet = spritesheet
    self.anims = {}
    if type(anims) == 'table' then
        for i = 1, #anims do
            local new = anims[i]
            self.add_anim(new[1], new[2], new[3], new[4], new[5], new[6])
        end
    end
end

function AnimatedSprite:add_anim(key, s, e, t, l)
    self.anims[key] = Anim:new(s, e, t, l)
end

function AnimatedSprite:play(key)
    if self.anims[key] then
        self.current = self.anims[key]
    end
end


function AnimatedSprite:frame_height()
    return self.current._sheet.frameHeight
end


function AnimatedSprite:frame_width()
    return self.current._sheet.frameWidth
end


function AnimatedSprite:draw()
    assert(self.owner[Transform], 'no transform component on animation owner')
    local t = self.owner[Transform]
    -- TODO: draw considering the transform coordinate as the center
end

return AnimatedSprite
