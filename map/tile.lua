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

function Tile:setDestroyable(kind, into, hp)
  self.destroyable = kind or false
  if kind and into then
    self.destroyed = into
    self.hp = hp or 100
  end
  return self
end

function Tile:setLayer(l)
  self.layer = l
  return self
end

function Tile:toEntity(x, y)
  local e = Entity:new('sprite' .. self.id, self.id, (x + 0.5) * TILESIZE, (y + 0.5) * TILESIZE, self.layer, image[self.sprite], 0, 1.0, 1.0, TILESIZE / 2, TILESIZE / 2)
  return e
end

return Tile
