local Healthbar = {HP_fraction = 1, hp_rect_len = 52, hp_rect_2_len = 52}

local SCALE = 4
local MAX_RECT_LEN = 52
local inner_rect_color = {1, 0.5, 0.5, 1}
local hp_rect_color = {1, 1, 1, 1}
local heath_canvas

function Healthbar.init()
    heath_canvas = lg.newCanvas(68, 17)
    -- just draws the border here
    heath_canvas:renderTo(function()
        -- just copy pasting the coordinates from asperite,
        -- so a few ugly magic numbers
        lg.setColor(1, 1, 1, 1)
        lg.polygon('line', 1, 1, 1, 16, 12, 16, 12, 12, 42, 12, 42, 7, 67, 7,
                   67, 1)
        -- TODO: show logo
    end)
end

function Healthbar.draw(x, y, hp_fraction)
    x = x / SCALE
    y = y / SCALE
    lg.push()
    lg.scale(SCALE, SCALE)
    lg.draw(heath_canvas, x, y)
    -- draw HP bar
    -- lg.setColor(250 / 255, 95 / 255, 82 / 255)
    lg.setColor(unpack(inner_rect_color))
    lg.rectangle('fill', x + 13, y + 2, Healthbar.hp_rect_2_len, 3)
    lg.setColor(unpack(hp_rect_color))
    lg.rectangle('fill', x + 13, y + 2, Healthbar.hp_rect_len, 3)
    -- draw EXP bar
    lg.setColor(109 / 255, 152 / 255, 243 / 255)
    lg.rectangle('fill', x + 13, y + 6, 27, 4)

    -- draw the icon
    lg.setColor(1, 1, 1, 1)
    lg.draw(Resource.Image.HealthIcon, x + 2, y + 3)

    lg.pop()
end

local function tween_inner_hp_rect(new_fraction)
    Timer.tween(0.2, Healthbar, {hp_rect_2_len = new_fraction * MAX_RECT_LEN},
                'linear')
end

function Healthbar.update(new_fraction)
    Timer.tween(0.1, Healthbar, {hp_rect_len = new_fraction * MAX_RECT_LEN},
                'linear', function() tween_inner_hp_rect(new_fraction) end)
end

return Healthbar
