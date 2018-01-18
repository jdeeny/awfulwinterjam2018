local Level = class("Level")

Level.tileset = require 'map/tileset'
local shadow_effect = moonshine(moonshine.effects.desaturate).chain(moonshine.effects.gaussianblur)
shadow_effect.desaturate.tint = {0,0,0}
shadow_effect.gaussianblur.sigma = 1.0


function Level:initialize(w, h)
  self.height = h
  self.width = w
  self:createCanvases()
  --window.addCallback(self:createCanvases())
  self.shadow_xoff = 3
  self.shadow_yoff = 12

  self.layers = {}
  self.tiles = {}

  self:setLayerEffects(Layer.WATER, water_effect)
  return self
end

function Level:find_symbol(symbol)
  for name, tile in pairs(self.tileset) do
    if tile[1].mapsymbol == symbol then
      return name
    end
  end
end


function Level:is_solid(gx, gy)
  return self.tiles[gx] and self.tiles[gx][gy] and self.tiles[gx][gy].issolid
end

function Level:pixel_width()
  return (self.width + 2) * TILESIZE
end

function Level:pixel_height()
  return (self.height + 2) * TILESIZE
end

function Level:bounding_box(gx, gy)
  return {x = TILESIZE * (gx + 0.5), y = TILESIZE * (gy + 0.5), radius = TILESIZE / 2}
end

function Level:pos_to_grid(p)
  return math.floor(p / TILESIZE)
end

function Level:in_bounds(gx, gy)
  return gx >= 1 and gx <= self.width and gy >= 1 and gy <= self.height
end

function Level:feature_at(gx, gy)
  if not self:in_bounds(gx, gy) then
    return "void" -- the void
  else
    return self.tiles[gx][gy].kind or 'void'
  end
end

function Level:hash(x, y)
  return 512 * x + y
end

function Level:unhash(hash)
  return math.floor(hash / 512), hash % 512
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
  if not self.tiles[x] then self.tiles[x] = {} end
  self.tiles[x][y] = tile[1].kind
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






function Level:open_door(dir, fake, time)
  if not self.door_close_time then
    self.door_close_time = {}
  end

  if not self.door_close_time[dir] then
    -- wasn't already open
    audiomanager:playOnce("unlatch")
  end

  -- if time is given, close the door again after that time
  if time then
    self.door_close_time[dir] = game_time + time
  end

  local k = fake and "fakedoor" or "opendoor"

  if dir == "north" then
    --self.tiles[self.width / 2][1].kind = k
    --self.tiles[1 + self.width / 2][1].kind = k
    self:addTile(self.width/2, 1, k)
    self.addTile(1+self.width/2, 1, k)
  elseif dir == "south" then
    --self.tiles[self.width / 2][self.height].kind = k
    --self.tiles[1 + self.width / 2][self.height].kind = k
    self:addTile(self.width/2, self.height, k)
    self.addTile(1+self.width/2, self.height, k)
  elseif dir == "east" then
    --self.tiles[self.width][self.height / 2].kind = k
    --self.tiles[self.width][1 + self.height / 2].kind = k
    self:addTile(self.width, self.height/2, k)
    self.addTile(self.width, self.height/2 + 1, k)
  elseif dir == "west" then
    --self.tiles[1][self.height / 2].kind = k
    --self.tiles[1][1 + self.height / 2].kind = k
    self:addTile(1,self.height/2, k)
    self.addTile(1,self.height/2+1, k)
  end


  --self:setup_tile_images()
end


function Level:coda()
  -- we're done in this room; open doors and let the player move on
  self.cleared = true
  if self.exits.north then
    self:open_door("north", false) -- no time given, so it should stay open forever
    doodad_data.spawn("exit_north", current_level:pixel_width() / 2, TILESIZE / 2)
  end
  if self.exits.east then
    self:open_door("east", false)
    doodad_data.spawn("exit_east", current_level:pixel_width() - (TILESIZE / 2), current_level:pixel_height() / 2)
  end
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
