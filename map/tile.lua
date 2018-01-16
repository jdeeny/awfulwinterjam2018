local Tile = class("Tile")

function Tile:initialize(name)
  self.layer = Layer.FLOOR
  self.id = name
  self.sprite = name
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
  local e = Entity:new(self.id, (x + 0.5) * 64, (y + 0.5) * 64, self.layer, image[self.sprite], 0, 1.0, 1.0, 64 / 2, 64 / 2)
  return e
end

return Tile
