local Effect = require 'prefabs/effects/effect'
local Effects = require 'prefabs/effects/effecttype'
local cmp = require 'component/common'

return {
    Bullet = {
        width = 5,
        height = 5,
        sx = 1,
        sy = 1,
        add_render = function(proj)
            proj:add_component(cmp.Sprite, Resource.Image.Bullet)
            return proj
        end,
        damage = 2,
        destroy_effect = function(world, x, y)
            return Effect(world, x, y, Effects.Block({1, 1, 1}, 10, 10), {
                life_span = 0.1,
                start_scale = {1, 1},
                end_scale = {0.5, 0.5}
            })
        end
    },
    Sting = {
        width = 2,
        height = 2,
        add_render = function(proj)
            local canvas = love.graphics.newCanvas(10, 1)
            canvas:renderTo(function()
                lg.setColor(1, 0, 0.2, 1)
                lg.rectangle('fill', 0, 0, 10, 2)
                -- graphics.rectangle('fill', 0, 0, 4, 4)
            end)
            proj:add_component(cmp.Sprite, canvas)
            return proj
        end,
        damage = 1
    },
    Ball = {
        width = 2,
        height = 2,
        sx = 0.6,
        sy = 0.6,
        add_render = function(proj)
            local canvas = love.graphics.newCanvas(12, 12)
            canvas:renderTo(function()
                lg.setColor(1, 1, 1, 1)
                lg.draw(Resource.Image.Ball, 0, 0)
            end)
            proj:add_component(cmp.Sprite, canvas)
            return canvas
        end,
        damage = 1,
        destroy_effect = function(world, x, y)
            return Effect(world, x, y, Effects.Block({sugar.rgb('#ffc2d8')}),
                          {life_span = 0.1, start_scale = {0.5, 0.5}})
        end
    }
}
