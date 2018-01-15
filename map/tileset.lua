local TileSet = class("TileSet")

function TileSet:initialize()
  self.kinds = {
    Tile:new('void', 'void')
    Tile:new('wall', 'wall')
    Tile:new('floor', 'floor')
  }
end

return TileSet
