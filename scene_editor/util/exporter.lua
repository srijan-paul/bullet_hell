local json = require 'lib.rxi.json'
local Tile = require 'world.tilemap.tiles'

local exporter = {}


function exporter:serialize(level)
    local ser = {}
    ser.tilemap = self:encode_tiles(level.tilemap)
    return json.encode(ser)
end


function exporter:deserialize(level_data)
    local level = json.decode(level_data)
    level.tilemap  = self:decode_tiles(level.tilemap)
    return level
end


function exporter:encode_tiles(tiles)
    local encoded = {}

    for i = 1, #tiles do
        encoded[i] = {}
        for j = 1, #tiles[i] do
            encoded[i][j] = Tile.GetID(tiles[i][j])
        end
    end
    return encoded
end


function exporter:decode_tiles(tiledata)
    local tiles = {}
    for i = 1, #tiledata do
        tiles[i] = {}
        for j = 1, #tiledata[i] do
            tiles[i][j] = Tile.Create(Tile.Q_ids(tiledata[i][j]))
        end
    end
    return tiles
end


function exporter:export(leveldata)
    local data = self:serialize(leveldata)
    local file = io.open('./rooms/a.json', 'w+')
    file:write(data)
    file:close()
end


return exporter
