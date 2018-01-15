local TileElecNode = class("TileElecNode", ElecNode)

function TileElecNode:initialize(chargemap, x, y)
  ElecNode.initialize(self, x * TILESIZE + TILESIZE / 2, y * TILESIZE + TILESIZE / 2)
  self.chargemap = chargemap
end


return TileElecNode
