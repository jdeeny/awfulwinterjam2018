local Level = class("Level")

Level.tileset = require 'map/tileset'
local shadow_effect = moonshine(moonshine.effects.desaturate).chain(moonshine.effects.gaussianblur)
shadow_effect.desaturate.tint = {0,0,0}
shadow_effect.gaussianblur.sigma = 1.0




function Level:initialize(w, h)
  self:createCanvases()
  --window.addCallback(self:createCanvases())
  self.shadow_xoff = 3
  self.shadow_yoff = 12

  self.layers = {}
  self:setLayerEffects(Layer.WATER, water_effect)
  return self
end

function Level:find_symbol(symbol)
  print(symbol)
  for name, tile in pairs(self.tileset) do
    if tile[1].mapsymbol == symbol then
      return name
    end
  end
end


function Level:createCanvases()
  self.shadow_canvas = love.graphics.newCanvas()
  self.entity_canvas = love.graphics.newCanvas()
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
  mob.layer = mob.layer or Layer.ENTITY
  self:_add(id, mob)
end

function Level:addBody(sprite, x, y)
  if not image[sprite] then
    print ("Attempted to add unknown body " .. sprite)
    return
  end
  local id = 'body' .. math.random()
  local body = Entity:new(id, sprite, x, y, Layer.BODIES, image[sprite], math.random() * 3.14 / 8, 1.0, 1.0, image[sprite]:getWidth()/2, image[sprite]:getWidth()/2)
  self:_add(id, body)
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
--[[  We do this in a particular order:
        Draw entities that cast shadows (it is assumed these things also reflect in water)
        Create a shadow layer from that
        Draw remaining entities (the ones with no shadow) to be used for reflect

        Draw layers in order, but use the above canvases to build layers
          Water gets reflection
          Shadow over floor
  ]]

  -- Draw shadows to shadow canvas
  love.graphics.setCanvas(self.shadow_canvas)
  love.graphics.setBackgroundColor(0,0,0,0)
  love.graphics.clear()

  shadow_effect(function()
    if self.layers[Layer.ENTITY] then self.layers[Layer.ENTITY]:draw() end
  end)

  -- Draw entities to entity canvas (for reflection)
  love.graphics.setCanvas(self.entity_canvas)
  love.graphics.setBackgroundColor(0,0,0,0)
  love.graphics.clear()

  if self.layers[Layer.ENTITY] then self.layers[Layer.ENTITY]:draw() end
  if self.layers[Layer.ENTITYNOSHADOW] then self.layers[Layer.ENTITYNOSHADOW]:draw() end

  -- Draw everything now
  love.graphics.setCanvas()
  for i = 1, Layer.LASTLAYER do

    -- Exceptions here, could probably refactor
    if i == Layer.SHADOW then
      love.graphics.draw(self.shadow_canvas, self.shadow_xoff, self.shadow_yoff)
    elseif i == Layer.ENTITY then
      love.graphics.draw(self.entity_canvas)
    elseif i == Layer.ENTITYNOSHADOW then   -- Don't draw, included in the entity_canvas drawn in ENTITY layer
    elseif self.layers[i] then
      self.layers[i]:draw()
    end
  end
end

return Level
