local Anim = require 'lib/janim'
local Transform = require 'component/transform'

local AnimatedSprite = Class('AnimatedSprite')

function AnimatedSprite:init(owner, spritesheet, anims)
    self.owner = owner
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

function AnimatedSprite:play(key, callback)
    if self.anims[key] then
        self.current = self.anims[key]
        self.current.playing = true
        if callback then
            self.current.callback = callback
        end
    end
end


function AnimatedSprite:is_playing(key)
    if self.current then
        if key then return self.anims[key] == self.current end
        return self.current.playing
    end
end


function AnimatedSprite:draw()
    assert(self.owner:has_component(Transform),
           'no transform component on animation component owner')
    local t = self.owner:get_component(Transform)
    

    -- for animated sprites, when the scale is negative, it means the
    -- entity is facing left and hence we still draw the sprite from the same
    -- offset
    local dp = Vec2(self.frame_width / 2, self.frame_height / 2):rotated(t.rotation)
    local x = t.pos.x - dp.x
    local y = t.pos.y - dp.y
    if t.scale.x < 0 then
        x = x + self.frame_width * - 1 * t.scale.x
    end

    
    self.current:draw(x, y, t.rotation, t.scale.x, t.scale.y)
end

function AnimatedSprite:update(dt)
    self.current:update(dt)
end

function AnimatedSprite:delete()
    self.owner.world:remove_drawable(self)
end

return AnimatedSprite
