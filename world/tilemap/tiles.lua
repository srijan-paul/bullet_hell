local Tile = {
    Map = Resource.Image.TileMap,
    Quads = {},
    SIZE = 16,
    MAP_ROWS = 5,
    MAP_COLS = 5
}
local TILE_SIZE = 16

function Tile.init( ... )
    for i = 1, Tile.MAP_ROWS do
        Tile.Quads[i] = {}
        for j = 1, Tile.MAP_COLS do
            local x, y = (i - 1) * TILE_SIZE, (j - 1) * TILE_SIZE
            Tile.Quads[i][j] = lg.newQuad(x, y, TILE_SIZE, TILE_SIZE,
                                          Tile.Map:getDimensions())
        end
    end
    
    Tile.Type = {
        WALL_TL = Tile.Quads[1][1],
        WALL_T = Tile.Quads[1][2],
        WALL_TR = Tile.Quads[1][3],
        WALL_L = Tile.Quads[2][1],
        WALL = Tile.Quads[2][2],
        WALL_R = Tile.Quads[2][3],
        WALL_BL = Tile.Quads[3][1],
        WALL_B = Tile.Quads[3][2],
        WALL_BR = Tile.Quads[3][3],
        WALL_V = Tile.Quads[2][4],
        WALL_VT = Tile.Quads[1][4],
        WALL_VB = Tile.Quads[3][4],
        WALL_HL = Tile.Quads[4][1],
        WALL_HR = Tile.Quads[4][2],
        WALL_H1 = Tile.Quads[4][3],
        WALL_H2 = Tile.Quads[4][4],
        FLOOR1 = Tile.Quads[5][1]
    }

    Tile.inited = true
end

if not Tile.inited then
    Tile.init()
end


function Tile.Draw (t, x, y)
    lg.draw(Tile.Map, t.quad, x, y)
end

function Tile.Create(quad, collidable)
    return {
        quad = quad,
        collides = collidable
    }
end


return setmetatable(Tile, {
    __call = function(quad, collidable)
        return {quad = quad, colldes = collidable}
    end
})
