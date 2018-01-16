local Level = class("Level")

Level.tileset = require 'map/tileset'

function Level:initialize(w, h)
  self.layers = {}
  self:setLayerEffects(Layer.WATER, water_effect)
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
    self:_add(id, e)
  end
end


function Level:addMob(id, mob)
  if id == nil or mob == nil then
    print("Attempted to add unknown mob")
    return
  end
  print("Addmob: " .. id)
  mob.layer = mob.layer or Layer.ENTITY
  self:_add(id, mob)
end

function Level:getLayer(n)
  local l = n or Layer.BROKEN
  if not self.layers[l] then self.layers[l] = Layer:new(l) end
  return self.layers[l]
end

function Level:_add(id, e)
  self:getLayer(e.layer):add(id, e)
end

function Level:remove(id)
  for _, layer in pairs(self.layers) do
    layer:remove(id)
  end
end

function Level:setLayerEffects(layer, effects)
  self:getLayer(layer).effects = effects
  return self
end

function Level:setTile(loc, tile)
  self.cells[loc] = tile
end

function Level:update(dt)
  for i = 1, Layer.LASTLAYER do
    if self.layers[i] then
      self.layers[i]:update(dt)
    end
  end
end

function Level:draw()
  for i = 1, Layer.LASTLAYER do
    if self.layers[i] then
      self.layers[i]:draw()
    end
  end
end

return Level
