
local TileSet = {}

-- TODO: change this to have the sprite filepath in this file so you dont have to edit two places

TileSet['void']               = { Tile:new('void') }
TileSet['wall']               = { Tile:new('wall'):setWall(true):setLayer(Layer.ENTITY) }
TileSet['floor']              = { Tile:new('floor') }
TileSet['teleporter']         = { Tile:new('teleporter') }
TileSet['ballpost']           = { Tile:new('ballpost'):setLayer(Layer.FURNITURE),
                                  Tile:new('floor') }

TileSet['water_border']       = { Tile:new('water_border'),
                                  Tile:new('water'):setLayer(Layer.WATER)
                                }


return TileSet
