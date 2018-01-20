
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



TileSet["water_surround1"]     = { function() return Tile:new('water_surround1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_w1"]            = { function() return Tile:new('water_w1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_s1"]            = { function() return Tile:new('water_s1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_sw1"]           = { function() return Tile:new('water_sw1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_e1"]            = { function() return Tile:new('water_e1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_ew1"]           = { function() return Tile:new('water_ew1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_se1"]           = { function() return Tile:new('water_se1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbutn1"]      = { function() return Tile:new('water_allbutn1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_n1"]            = { function() return Tile:new('water_n1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_nw1"]           = { function() return Tile:new('water_nw1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_ns1"]           = { function() return Tile:new('water_ns1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbute1"]      = { function() return Tile:new('water_allbute1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_ne1"]           = { function() return Tile:new('water_ne1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbuts1"]      = { function() return Tile:new('water_allbuts1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_allbutw1"]      = { function() return Tile:new('water_attbutw1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }
TileSet["water_island1"] = { function() return Tile:new('water_island1'):setLayer(Layer.WATER) end,
                                  function() return Tile:new('floor') end, }




return TileSet
