local Healthbar = {HP_fraction = 1, hp_rect_len = 50, hp_rect_2_len = 50}

local SCALE = 4
local MAX_RECT_LEN = 50
local hp_rect_color = {sugar.rgb('#ED4C67')}
local inner_rect_color = {sugar.rgb('c52f23')}
local heath_canvas

function Healthbar.init()
    heath_canvas = lg.newCanvas(68, 17)
    -- just draws the border here
    heath_canvas:renderTo(function()
        -- just copy pasting the coordinates from asperite,
        -- so a few ugly magic numbers
        lg.setColor(1, 1, 1, 1)
        lg.rectangle('line', 1, 1, 67, 16)
        -- TODO: show logo
    end)
end

function Healthbar.draw(x, y)

    Healthbar.hp_rect_len = sugar.clamp(Healthbar.hp_rect_len, 0, MAX_RECT_LEN)
    Healthbar.hp_rect_2_len = sugar.clamp(Healthbar.hp_rect_2_len, 0, MAX_RECT_LEN)
    
    x = x / SCALE
    y = y / SCALE
    lg.push()
    lg.scale(SCALE, SCALE)
    lg.translate(x, y)

    -- draw HP bar
    -- lg.setColor(250 / 255, 95 / 255, 82 / 255)
    lg.setColor(unpack(inner_rect_color))

    -- draw EXP bar
    lg.setColor(109 / 255, 152 / 255, 243 / 255)
    -- lg.rectangle('fill', x + 13, y + 6, 27, 4)

    -- draw the icon
    lg.setColor(1, 1, 1, 1)
    lg.draw(Resource.Image.HealthIcon, 0, 0)

    -- draw the rectangle
    lg.rectangle('line', 12, 1, 52, 8)
    
    lg.setColor(unpack(inner_rect_color))
    lg.rectangle('fill', 13, 2, Healthbar.hp_rect_2_len, 6)
    lg.setColor(unpack(hp_rect_color))
    lg.rectangle('fill', 13, 2, Healthbar.hp_rect_len, 6)

    -- lg.setColor(1, 1, 1, 0.6)
    -- lg.rectangle('fill', 13, 2, MAX_RECT_LEN, 2)

    lg.translate(-x, -y)
    lg.pop()
end

local function tween_inner_hp_rect(new_fraction)
    Timer.tween(0.2, Healthbar, {hp_rect_2_len = new_fraction * MAX_RECT_LEN},
                'linear')
end

function Healthbar.update(new_fraction)
    Timer.tween(0.2, Healthbar, {hp_rect_len = new_fraction * MAX_RECT_LEN},
                'linear', function() tween_inner_hp_rect(new_fraction) end)
end

return Healthbar
