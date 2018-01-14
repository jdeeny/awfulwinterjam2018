local TileElecNode = class("TileElecNode", ElecNode)

function TileElecNode:initialize(chargemap)
  ElecNode.initialize(self)
  self.chargemap = chargemap
end


return TileElecNode
