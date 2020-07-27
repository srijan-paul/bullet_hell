_G.keyboard= love.keyboard

local Room = require 'world.room'

local room
-- shader code taken from : https://love2d.org/forums/viewtopic.php?t=85736
-- credits to ivan from Love2d forums 
local shader = love.graphics.newShader [[
    // jangsy5 code
    extern number distortion = 0.06;
    extern number aberration = 2.5;
    vec4 effect(vec4 color, Image tx, vec2 tc, vec2 pc) {
        // curvature
        vec2 cc = tc - 0.5f;
        float dist = dot(cc, cc)*distortion;
        tc = (tc + cc * (1.0f + dist) * dist);

        // fake chromatic aberration
        float sx = aberration/love_ScreenSize.x;
        float sy = aberration/love_ScreenSize.y;
        vec4 r = Texel(tx, vec2(tc.x + sx, tc.y - sy));
        vec4 g = Texel(tx, vec2(tc.x, tc.y + sy));
        vec4 b = Texel(tx, vec2(tc.x - sx, tc.y - sy));
        number a = (r.a + g.a + b.a)/3.0;

        return vec4(r.r, g.g, b.b, a);
    }
]]

function love.load()
    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(sugar.rgb('19202f'))
    -- print(sugar.rgb('19202f'))
    Resource.load()
    room = Room()
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.setShader(shader)
    room:draw()
    love.graphics.setLineWidth(2)
    love.graphics.setShader()
end

function love.update(dt) room:update(dt) end
