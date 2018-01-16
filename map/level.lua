local Level = class("Level")

Level.tileset = require 'map/tileset'

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

function Level:addTile(id, x, y, tile)
  if id == nil or tile == nil then
    print("Attempted to add unknown tile")
    return
  end
  print("addtile: " .. x .. " " .. y)
  for _, t in ipairs(tile) do
    local e = t:toEntity(x, y)
    self:_add(t.id, id, e)
  end
end


function Level:addMob(id, x, y, mob)
  if id == nil or mob == nil then
    print("Attempted to add unknown mob")
    return
  end
  print("Addmob: " .. x .. " " .. y)
end

function Level:_add(kind, id, e)
  local l = e.layer
  if not self.layers[l] then self.layers[l] = Layer:new(l) end
  self.layers[l]:add(kind, id, e)
end

function Level:remove(id)
  for _, layer in ipairs(self.layers) do
    layer:remove(id)
  end
end

function Level:setTile(loc, tile)
  self.cells[loc] = tile
end

function Level:update(dt)
  for _, l in pairs(self.layers) do
    l:update(dt)
  end
end

function Level:draw()
  for _, l in pairs(self.layers) do
    l:draw()
  end
end

return Level
