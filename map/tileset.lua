
local TileSet = {}

-- TODO: change this to have the sprite filepath in this file so you dont have to edit two places

TileSet['void']               = Tile:new('void', 'void')
TileSet['wall']               = Tile:new('wall', 'wall')
TileSet['floor']              = Tile:new('floor', 'floor')
TileSet['teleporter']         = Tile:new('teleporter', 'teleporter')
TileSet['water_border']       = Tile:new('water_border', 'water_border')
TileSet['ballpost']           = Tile:new('ballpost', 'ballpost')


return TileSet
