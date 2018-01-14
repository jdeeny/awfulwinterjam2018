local TileElecNode = class("TileElecNode", ElecNode)

function TileElecNode:initialize(chargemap, x, y)
  ElecNode.initialize(self)
  self.chargemap = chargemap
  self.x = x
  self.y = y
end


return TileElecNode
