local Anim = require 'lib/janim'
local Transform = require 'component/transform'

local AnimatedSprite = Class('AnimatedSprite')

function AnimatedSprite:init(owner, spritesheet, anims)
    self.owner = owner
    print(type(self.owner), self.owner[Transform], 'is the transform')
    self._spritesheet = spritesheet
    self.frame_width = self._spritesheet.frameWidth
    self.frame_height = self._spritesheet.frameHeight
    self.anims = {}
    if type(anims) == 'table' then
        for i = 1, #anims do
            local new = anims[i]
            -- each element in anims is a table like 
            -- {'walk', 1, 2, 0.1, false} (name, start_index, end_index, time_per_frame, loop)
            self:add_anim(new[1], new[2], new[3], new[4], new[5], new[6])
        end
    end
    self.owner.world:add_drawable(self)
end

function AnimatedSprite:add_anim(key, s, e, t, l)
    self.anims[key] = Anim:new(self._spritesheet, s, e, t, l)
end

function AnimatedSprite:play(key)
    if self.anims[key] then self.current = self.anims[key] end
end

function AnimatedSprite:draw()
    assert(self.owner[Transform],
           'no transform component on animation component owner')
    local t = self.owner[Transform]
    local x = t.pos.x - self.frame_width / 2
    local y = t.pos.y - self.frame_height / 2
    self.current:draw(x, y, t.rotation, t.scale.x, t.scale.y)
end

function AnimatedSprite:update(dt)
    self.current:update(dt)
end

return AnimatedSprite
