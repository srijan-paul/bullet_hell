local Tile = {
    Map = Resource.Image.TileMap,
    Quads = {},
    SIZE = 16,
    MAP_ROWS = 5,
    MAP_COLS = 5,
    -- Id_Q maps a Tile's Type ID (WALL, FLOOR... enums) to
    -- the actual Quad that the tile is supposed to use when drawing
    -- a Tile only stores it's type data and not the actual quad
    Id_Q = {}
}

local TILE_SIZE = 16

function Tile.init(...)

    for i = 1, Tile.MAP_ROWS do
        Tile.Quads[i] = {}
        for j = 1, Tile.MAP_COLS do
            local x, y = (i - 1) * TILE_SIZE, (j - 1) * TILE_SIZE
            Tile.Quads[i][j] = love.graphics.newQuad(x, y, TILE_SIZE, TILE_SIZE,
                                                     Tile.Map:getDimensions())
        end
    end

    -- Tile names are just enums, the order of the enums is actually important because
    -- an enum name is used to index into the Tile quads array and pick that particular quad
    -- when creating a quad, only the enum needs to be known

    Tile.Type = sugar.enum {
        'WALL_TL', 'WALL_T', 'WALL_TR', 'WALL_L', 'WALL', 'WALL_R', 'WALL_BL',
        'WALL_B', 'WALL_BR', 'WALL_V', 'WALL_VT', 'WALL_VB', 'WALL_HL',
        'WALL_HR', 'WALL_H1', 'WALL_H2', 'FLOOR1', 'FLOOR2', 'FLOOR3', 'FLOOR4',
        'FLOOR5', 'FLOOR6', 'FLOOR7', 'FLOOR8', 'FLOOR9'
    }

    -- maps a Tile's ID to it's Quad

    Tile.Id_Q = {
        Tile.Quads[1][1], Tile.Quads[1][2], Tile.Quads[1][3], Tile.Quads[2][1],
        Tile.Quads[2][2], Tile.Quads[2][3], Tile.Quads[3][1], Tile.Quads[3][2],
        Tile.Quads[3][3], Tile.Quads[2][4], Tile.Quads[1][4], Tile.Quads[3][4],
        Tile.Quads[4][1], Tile.Quads[4][2], Tile.Quads[4][3], Tile.Quads[4][4],
        Tile.Quads[5][1], Tile.Quads[5][2], Tile.Quads[5][3], Tile.Quads[5][4],
        Tile.Quads[5][5], Tile.Quads[4][5], Tile.Quads[3][5], Tile.Quads[2][5],
        Tile.Quads[1][5]
    }

    -- each boolean here corresponds to an enum value.

    Tile.Collides = {
        true, true, true, true, true, true, true, true, true, true, true, true,
        true, true, true, true, false, false, false, false, false, false, false,
        false, false
    }

end

Tile.init()

function Tile.Draw(t, x, y)
    lg.draw(Tile.Map, Tile.Id_Q[t.quad_index], x, y)
end

function Tile.GetQuad(type)
    return Tile.Id_Q[type]
end

function Tile.GetID(tile)
    return tile.quad_index
end

function Tile.Create(type)
    return {
        quad_index = type,
        collides = Tile.Collides[type]
    }
end

return Tile
