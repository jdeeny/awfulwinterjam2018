
local TileSet = {}

-- TODO: change this to have the sprite filepath in this file so you dont have to edit two places

TileSet['void']               = { Tile:new('void') }
TileSet['invinciblewall']     = { Tile:new('wall',            '#'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable(false) }
TileSet['wall']               = { Tile:new('wall',            'W'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 150) }
TileSet['door']               = { Tile:new('wall',            'D'):setDoor(true):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 150) }
TileSet['opendoor']           = { Tile:new('floor',           'd'):setDoor(true):setSolid(false) }
TileSet['fakedoor']           = { Tile:new('floor')               :setDoor(true):setSolid(true):setDestroyable(false) }
TileSet['floor']              = { Tile:new('floor',           '-') }
TileSet['teleporter']         = { Tile:new('teleporter',      't') }
TileSet['ballpost']           = { Tile:new('ballpost',        'b'):setLayer(Layer.FURNITURE):setDestroyable('explodes', 'rubblefloor', 50),
                                  Tile:new('floor') }

TileSet['water_border']       = { Tile:new('water_border',    'w' ),
                                  Tile:new('water'):setLayer(Layer.WATER),
                                }

TileSet['rubblefloor']        = { Tile:new('rubble',          'r' ):setLayer(Layer.FURNITURE),
                                  Tile:new('floor'),
                                }

return TileSet
