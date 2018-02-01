
local TileSet = {}

-- TODO: change this to have the sprite filepath in this file so you dont have to edit two places

TileSet['empty']            = { function() return Tile:new('empty', ' '):setLayer(Layer.BOTTOM) end, }
TileSet['void']               = { function() return Tile:new('void'):setSolid(true):setLayer(Layer.FURNITURE) end, }
TileSet['void_walltop']       = { function() return Tile:new('void_walltop'):setSolid(true):setLayer(Layer.FURNITURE) end, }
TileSet['invinciblewall']     = { function() return Tile:new('invinciblewall',  '#'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable(false) end, }
TileSet['invinciblewall_southface']     = { function() return Tile:new('invinciblewall_southface'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable(false) end, }
TileSet['invinciblewall_southdoor']     = { function() return Tile:new('invinciblewall_southdoor'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable(false) end, }
TileSet['wall']               = { function() return Tile:new('wall',            'W'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 30+math.random(30)) end, }
TileSet['wall_southface']     = { function() return Tile:new('wall_southface'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor',30+math.random(30)) end, }
TileSet['wall_southdoor']     = { function() return Tile:new('wall_southdoor'):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 30+math.random(30)) end, }
TileSet['door']               = { function() return Tile:new('door',            'D'):setDoor(true):setSolid(true):setLayer(Layer.FURNITURE)end, }
TileSet['door_southface']     = { function() return Tile:new('door_southface'):setDoor(true):setSolid(true):setLayer(Layer.FURNITURE)end, }
TileSet['opendoor']           = { function() return Tile:new('opendoor',        'd'):setDoor(true):setSolid(false) end, }
TileSet['fakedoor']           = { function() return Tile:new('fakedoor')           :setDoor(true):setSolid(true) end, }
TileSet['floor']              = { function() return Tile:new('floor',           '-'):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_concrete']      = { function() return Tile:new('floor_concrete'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_checker1']      = { function() return Tile:new('floor_checker1'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_checker2']      = { function() return Tile:new('floor_checker2'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_checker3']      = { function() return Tile:new('floor_checker3'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_metal']      = { function() return Tile:new('floor_metal'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_grating']      = { function() return Tile:new('floor_grating'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_wood_light']      = { function() return Tile:new('floor_wood_light'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_wood_long']      = { function() return Tile:new('floor_wood_long'       ):setLayer(Layer.SUBFLOOR) end, }
TileSet['floor_wood_dark']      = { function() return Tile:new('floor_wood_dark'       ):setLayer(Layer.SUBFLOOR) end, }

TileSet['teleporter']         = { function() return Tile:new('teleporter',      't') end, }
TileSet['ballpost']           = { function() return Tile:new('ballpost',        'b'):setLayer(Layer.FURNITURE):setConductive(1.0):setDestroyable('explodes', 'rubblefloor', 20 + math.random(15)) end, }

TileSet['wall_southface_teak']               = { function() return Tile:new('wall_southface_teak',            nil):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 30+math.random(30)) end, }
TileSet['wall_southface_wood']               = { function() return Tile:new('wall_southface_wood',            nil):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 30+math.random(30)) end, }
TileSet['wall_southface_white']               = { function() return Tile:new('wall_southface_white',            nil):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 30+math.random(30)) end, }
TileSet['wall_southface_greystone']               = { function() return Tile:new('wall_southface_greystone',            nil):setSolid(true):setLayer(Layer.FURNITURE):setDestroyable('crumbles', 'rubblefloor', 30+math.random(30)) end, }


TileSet['water_border']       = { --function() return Tile:new('water_border',    'w') end,
                                  function() return Tile:new('water', 'w'):setLayer(Layer.WATER) end,
                                }

TileSet['capacitor']        = { function() return Tile:new('capacitor',          'c' ):setLayer(Layer.FURNITURE):setConductive(1.0):setDestroyable('explodes', 'rubblefloor', 12):setSolid(true) end,
                                }


TileSet['rubblefloor']        = { function() return Tile:new('rubble',          'r' ):setLayer(Layer.FURNITURE) end, }



for i = 1, 2 do
TileSet["water_surround"..i]     = { function() return Tile:new('water_surround'..i):setLayer(Layer.WATER):setConductive(0.5) end, }
TileSet["water_e"..i]            = { function() return Tile:new('water_e'..i):setLayer(Layer.WATER):setConductive(0.5) end, }
TileSet["water_s"..i]            = { function() return Tile:new('water_e'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI/2) end, }
TileSet["water_n"..i]            = { function() return Tile:new('water_e'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(-PI/2) end, }
TileSet["water_w"..i]            = { function() return Tile:new('water_e'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI) end, }

TileSet["water_nw"..i]           = { function() return Tile:new('water_nw'..i):setLayer(Layer.WATER):setConductive(0.5) end, }
TileSet["water_ne"..i]           = { function() return Tile:new('water_nw'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI/2) end, }
TileSet["water_se"..i]           = { function() return Tile:new('water_nw'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI) end, }
TileSet["water_sw"..i]           = { function() return Tile:new('water_nw'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(-PI/2) end, }

TileSet["water_ew"..i]           = { function() return Tile:new('water_ns'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI/2) end, }

TileSet["water_ns"..i]           = { function() return Tile:new('water_ns'..i):setLayer(Layer.WATER):setConductive(0.5) end, }

TileSet["water_allbutn"..i]      = { function() return Tile:new('water_allbutn'..i):setLayer(Layer.WATER):setConductive(0.5) end, }
TileSet["water_allbute"..i]      = { function() return Tile:new('water_allbute'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI/2) end, }
TileSet["water_allbuts"..i]      = { function() return Tile:new('water_allbuts'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(-PI/2) end, }
TileSet["water_allbutw"..i]      = { function() return Tile:new('water_attbutw'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI) end, }

TileSet["water_island"..i] = { function() return Tile:new('water_island'..i):setLayer(Layer.WATER):setConductive(0.5) end, }

end
for i = 1, 4 do
TileSet["water_edge_w"..i]     = { function() return Tile:new('water_edge'..i):setLayer(Layer.WATER):setConductive(0.5) end, }
TileSet["water_edge_n"..i]     = { function() return Tile:new('water_edge'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI/2) end, }
TileSet["water_edge_e"..i]     = { function() return Tile:new('water_edge'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI) end, }
TileSet["water_edge_s"..i]     = { function() return Tile:new('water_edge'..i):setLayer(Layer.WATER):setConductive(0.5):setRotation(-PI/2) end, }

end

TileSet["water_open"] = { function() return Tile:new('water_open'):setLayer(Layer.WATER):setConductive(0.5) end, }


TileSet["water_cross"] = { function() return Tile:new('water_cross'):setLayer(Layer.WATER):setConductive(0.5) end, }

TileSet["water_t_nes"] = { function() return Tile:new('water_t_nes'):setLayer(Layer.WATER):setConductive(0.5) end, }
TileSet["water_t_esw"] = { function() return Tile:new('water_t_nes'):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI/2) end, }
TileSet["water_t_sen"] = { function() return Tile:new('water_t_nes'):setLayer(Layer.WATER):setConductive(0.5):setRotation(PI) end, }
TileSet["water_t_enw"] = { function() return Tile:new('water_t_nes'):setLayer(Layer.WATER):setConductive(0.5):setRotation(-PI/2) end, }





return TileSet
