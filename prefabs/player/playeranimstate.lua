local AnimatedSprite = require 'component/animsprite'

local function anim_cmp(ent)
    return ent:get_component(AnimatedSprite)
end

-- first arg empty for "self"
local function switch_anim(_, player, next_anim_state)
    next_anim_state:enter(player)
end

local function enter_anim(anim, player)
    anim_cmp(player):play(anim.key)
    player.animation = anim
end

local function anim_state(name)
    return {
        key = name,
        enter = enter_anim,
        update = function(self, player, dt) end,
        switch = switch_anim
    }
end

-- where do run , idle and hurt come from ?
-- because I know the player has these animations. Yeah it's pretty
-- unclear at first glance but well... I'll prolly refactor it later anyway
local Move, Idle = anim_state('run'), anim_state('idle')
local Hurt = anim_state('hurt')

function Hurt:update(player, dt)
    if not anim_cmp(player):is_playing('hurt') then
        local x =  Input:keydown('d') - Input:keydown('a')
        local y = Input:keydown('s') - Input:keydown('w')
        local state = Move
        if x == 0 and y == 0 then state = Idle end
        player:switch_anim(state)
    end
end

function Hurt:switch(player, next_state)
    if not anim_cmp(player):is_playing('hurt') then
        next_state:enter(player)
    end
end


return {MOVE = Move, IDLE = Idle, HURT = Hurt}
