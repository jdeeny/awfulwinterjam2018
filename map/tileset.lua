
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



for i = 1, 2 do
TileSet["water_surround"..i]     = { function() return Tile:new('water_surround'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_w"..i]            = { function() return Tile:new('water_w'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_s"..i]            = { function() return Tile:new('water_w'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_n"..i]            = { function() return Tile:new('water_w'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_e"..i]            = { function() return Tile:new('water_e'..i):setLayer(Layer.WATER) end,
                                function() return Tile:new('floor') end, }



TileSet["water_sw"..i]           = { function() return Tile:new('water_sw'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_se"..i]           = { function() return Tile:new('water_sw'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_ne"..i]           = { function() return Tile:new('water_sw'..i):setLayer(Layer.WATER) end,
                                function() return Tile:new('floor') end, }
TileSet["water_nw"..i]           = { function() return Tile:new('water_sw'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }

TileSet["water_ew"..i]           = { function() return Tile:new('water_ew'..i):setLayer(Layer.WATER) end,
function() return Tile:new('floor') end, }

TileSet["water_ns"..i]           = { function() return Tile:new('water_ns'..i):setLayer(Layer.WATER) end,
function() return Tile:new('floor') end, }

TileSet["water_allbutn"..i]      = { function() return Tile:new('water_allbutn'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbute"..i]      = { function() return Tile:new('water_allbute'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbuts"..i]      = { function() return Tile:new('water_allbuts'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbutw"..i]      = { function() return Tile:new('water_attbutw'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }

TileSet["water_island"..i] = { function() return Tile:new('water_island'..i):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
end




return TileSet
