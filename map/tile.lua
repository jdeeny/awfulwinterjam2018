local Tile = class("Tile")

function Tile:initialize(name)
  self.layer = Layer.FLOOR
  self.id = name
  return self
end

function Tile:setWall(w)
  self.iswall = w
  return self
end

function Tile:setLayer(l)
  self.layer = l
  return self
end

function Tile:toEntity(x, y)
  return nil --TileEntity:new(self.id, self.layer)
end

return Tile
