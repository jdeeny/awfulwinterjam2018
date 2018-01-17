
local TileSet = {}

-- TODO: change this to have the sprite filepath in this file so you dont have to edit two places

TileSet['void']               = { Tile:new('void') }
TileSet['invinciblewall']     = { Tile:new('wall'):setWall(true):setLayer(Layer.FURNITURE):setDestroyable(false) }
TileSet['wall']               = { Tile:new('wall'):setWall(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 150) }
TileSet['floor']              = { Tile:new('floor') }
TileSet['teleporter']         = { Tile:new('teleporter') }
TileSet['ballpost']           = { Tile:new('ballpost'):setLayer(Layer.FURNITURE):setDestroyable('explodes', 'rubblefloor', 50),
                                  Tile:new('floor') }

TileSet['water_border']       = { Tile:new('water_border'),
                                  Tile:new('water'):setLayer(Layer.WATER),
                                }

TileSet['rubblefloor']        = { Tile:new('rubble'):setLayer(Layer.FURNITURE),
                                  Tile:new('floor'),
                                }

return TileSet
