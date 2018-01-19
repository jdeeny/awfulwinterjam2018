
local TileSet = {}

-- TODO: change this to have the sprite filepath in this file so you dont have to edit two places

TileSet['void']               = { function() return Tile:new('void') end, }
TileSet['invinciblewall']     = { function() return Tile:new('wall',            '#'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable(false) end, }
TileSet['wall']               = { function() return Tile:new('wall',            'W'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 150) end, }
TileSet['door']               = { function() return Tile:new('wall',            'D'):setDoor(true):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 150) end, }
TileSet['opendoor']           = { function() return Tile:new('floor',           'd'):setDoor(true):setSolid(false) end, }
TileSet['fakedoor']           = { function() return Tile:new('floor')               :setDoor(true):setSolid(true):setDestroyable(false) end, }
TileSet['floor']              = { function() return Tile:new('floor',           '-') end, }
TileSet['teleporter']         = { function() return Tile:new('teleporter',      't') end, }
TileSet['ballpost']           = { function() return Tile:new('ballpost',        'b'):setLayer(Layer.FURNITURE):setDestroyable('explodes', 'rubblefloor', 50) end,
                                  function() return Tile:new('floor') end, }

TileSet['water_border']       = { function() return Tile:new('water_border',    'w') end,
                                  function() return Tile:new('water'):setLayer(Layer.WATER) end,
                                }

TileSet['rubblefloor']        = { function() return Tile:new('rubble',          'r' ):setLayer(Layer.FURNITURE) end,
                                  function() return Tile:new('floor') end,
                                }

return TileSet
