local Level = class("Level")

local Layer = require 'map/layer'

function Level:initialize(w, h)
  self.layers = {}
  return self
end

function Level:rebuild()
  self:clear()
  for loc, tile in self.cells do

  end
end

function Level:clear()
  for layer in self.layers do
    layer:clear()
  end
end

function Level:add(id, entity)
  local kind = entity.getKind()
  for layer in entity:getLayers() do
    if not self.layers[l] then self.layers[layer] = Layer:new(layer) end
    self.layers[l].add(kind, id, entity)
  end
end

function Level:remove(id)
  for layer in self.layers do
    layer.remove(id)
  end
end

function Level:setTile(loc, tile)
  self.cells[loc] = tile
end

function Level:update(dt)
  for _, l in pairs(self.layers) do
    l.update(dt)
  end
end

function Level:draw()
  for _, l in pairs(self.layers) do
    l.draw()
  end
end

return Level
