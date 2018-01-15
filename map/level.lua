local Level = class("Level")

local Layer = require 'map/layer'

function Level:initialize(w, h)
  self:clear()
  return self
end

function Level:rebuild()
  self:clear()
  for loc, tile in self.cells do

  end
end

function Level:clear()
  self.layers = {}
  return self
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
