local Tile = class("Tile")

function Tile:initialize(name)
  self.id = name
  return self
end

return Tile
