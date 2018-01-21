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
  self.shadow_xoff = 2
  self.shadow_yoff = 8

  self.layers = {}
  self.tiles = {}

  self:setLayerEffects(Layer.WATER, water_effect)
  return self
end

function Level:find_symbol(symbol)
  for name, tile in pairs(self.tileset) do
    if tile[1]().mapsymbol == symbol then
      return name
    end
  end
end

function Level:is_solid(gx, gy)
  if not self.tiles[gx] then return true end
  if not self.tiles[gx][gy] then return true end
  return self.tiles[gx][gy].t.issolid
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
  local id = id or self:hash(x, y)
  if tile == nil then
    print("Attempted to add unknown tile")
    return
  end

  self:remove(id)

  local first = {}
  for i, t in ipairs(tile) do
    local t = t()
    t.x, t.y = x, y
    local e = t:toEntity(x, y)
    if i == 1 then first = e end
    self:_add(id, e)
  end

  if not self.tiles[x] then self.tiles[x] = {} end
  self.tiles[x][y] = first
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
  local body = Entity:new(nil, id, sprite, x, y, Layer.BODIES, image[sprite], math.random() * 3.14 / 8, 1.0, 1.0, image[sprite]:getWidth()/2, image[sprite]:getWidth()/2)
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

  local dtype = (fake and "fakedoor") or "opendoor"
  local k = self.tileset[dtype]

  if dir == "north" then
    --self.tiles[self.width / 2][1].kind = k
    --self.tiles[1 + self.width / 2][1].kind = k
    self:addTile(nil, self.width/2, 1, k)
    self:addTile(nil, 1+self.width/2, 1, k)
  elseif dir == "south" then
    --self.tiles[self.width / 2][self.height].kind = k
    --self.tiles[1 + self.width / 2][self.height].kind = k
    self:addTile(nil, self.width/2, self.height, k)
    self:addTile(nil, 1+self.width/2, self.height, k)
  elseif dir == "east" then
    --self.tiles[self.width][self.height / 2].kind = k
    --self.tiles[self.width][1 + self.height / 2].kind = k
    self:addTile(nil, self.width, self.height/2, k)
    self:addTile(nil, self.width, self.height/2 + 1, k)
  elseif dir == "west" then
    --self.tiles[1][self.height / 2].kind = k
    --self.tiles[1][1 + self.height / 2].kind = k
    self:addTile(nil, 1,self.height/2, k)
    self:addTile(nil, 1,self.height/2+1, k)
  end
end

function Level:prologue()
  self:open_door("west", true) -- no time given, so it should stay open forever
end

function Level:coda()
  -- we're done in this room; open doors and let the player move on
  self.cleared = true
  if self.kind == "boss" then

    fade.start_fade("fadeout", 1, false)
	  -- set iframes so player doesn't die before progressing?
	  gamestage.save_upgrades()
	  delay.start(1, function()
        gamestage.setup_next_stage()
        if gamestage.stages[gamestage.current_stage].intro_movie then
  		    gamestage.stages[gamestage.current_stage].intro_movie.enter()
  	    else
		  gamestage.advance_to_play()
          play.enter()
        end
      end)

  else
    if self.exits.north then
      self:open_door("north", false) -- no time given, so it should stay open forever
      doodad_data.spawn("exit_north", current_level:pixel_width() / 2, TILESIZE / 2)
    end
    if self.exits.east then
      self:open_door("east", false)
      doodad_data.spawn("exit_east", current_level:pixel_width() - (TILESIZE / 2), current_level:pixel_height() / 2)
    end
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

function Level:_addToLayer(layer, id, e)
  self:getLayer(layer):add(id, e)
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

function Level:northWater(x, y)
  local k = self:feature_at(x, y - 1)

  if k:sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:southWater(x, y)
  if (self:feature_at(x, y + 1)):sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:eastWater(x, y)
  if (self:feature_at(x + 1, y)):sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:westWater(x, y)
  if (self:feature_at(x - 1, y)):sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:neWater(x, y)
  if (self:feature_at(x + 1, y - 1)):sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:nwWater(x, y)
  if (self:feature_at(x - 1, y - 1)):sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:swWater(x, y)
  if (self:feature_at(x - 1, y + 1)):sub(1, 5) == "water" then return 1 end
  return 0
end
function Level:seWater(x, y)
  if (self:feature_at(x + 1, y + 1)):sub(1, 5) == "water" then return 1 end
  return 0
end



local function iswater(kind)
  return kind:sub(1,5) == "water"
end

function Level:updatewatertiles()
  local N, E, W, S = 8, 4, 2, 1
  local NE, NW, SW, SE = 128, 64, 32, 16
  for tx = 1, self.width do
    for ty = 1, self.height do
      if self:feature_at(tx, ty):sub(1,5) == 'water' then
        local waterstatus_sides = self:northWater(tx,ty) * N + self:eastWater(tx,ty) * E + self:southWater(tx,ty) * S + self:westWater(tx,ty) * W
        local waterstatus_diag = self:neWater(tx,ty) * NE + self:nwWater(tx,ty) * NW + self:seWater(tx,ty)*SE + self:swWater(tx,ty)*SW
        local waterstatus = waterstatus_sides + waterstatus_diag
        -- TODO: Account for corners
        if waterstatus == 0 then self:addTile(nil, tx, ty, self.tileset["water_surround"..math.random(2)]) end

        if waterstatus_sides == W then self:addTile(nil, tx, ty, self.tileset["water_w"..math.random(2)]) end
        if waterstatus_sides == S then self:addTile(nil, tx, ty, self.tileset["water_s"..math.random(2)]) end
        if waterstatus_sides == E then self:addTile(nil, tx, ty, self.tileset["water_e"..math.random(2)]) end
        if waterstatus_sides == N then self:addTile(nil, tx, ty, self.tileset["water_n"..math.random(2)]) end

        if waterstatus_sides == N+S then self:addTile(nil, tx, ty, self.tileset["water_ns"..math.random(2)]) end
        if waterstatus_sides == E+W then self:addTile(nil, tx, ty, self.tileset["water_ew"..math.random(2)]) end

        if waterstatus_sides == W+S then self:addTile(nil, tx, ty, self.tileset["water_sw"..math.random(2)]) end
        if waterstatus_sides == E+S then self:addTile(nil, tx, ty, self.tileset["water_se"..math.random(2)]) end
        if waterstatus_sides == W+N then self:addTile(nil, tx, ty, self.tileset["water_nw"..math.random(2)]) end
        if waterstatus_sides == E+N then self:addTile(nil, tx, ty, self.tileset["water_ne"..math.random(2)]) end


        --[[if waterstatus == 6 then self:addTile(nil, tx, ty, self.tileset["water_se"..math.random(2)]) end
        if waterstatus == 7 then self:addTile(nil, tx, ty, self.tileset["water_allbutn"..math.random(2)]) end
        if waterstatus == 8 then self:addTile(nil, tx, ty, self.tileset["water_n"..math.random(2)]) end
        if waterstatus == 9 then self:addTile(nil, tx, ty, self.tileset["water_nw"..math.random(2)]) end
        if waterstatus == 10 then self:addTile(nil, tx, ty, self.tileset["water_ns"..math.random(2)]) end
        if waterstatus == 11 then self:addTile(nil, tx, ty, self.tileset["water_allbute"..math.random(2)]) end
        if waterstatus == 12 then self:addTile(nil, tx, ty, self.tileset["water_ne"..math.random(2)]) end
        if waterstatus == 13 then self:addTile(nil, tx, ty, self.tileset["water_allbuts"..math.random(2)]) end
        if waterstatus == 14 then self:addTile(nil, tx, ty, self.tileset["water_allbutw"..math.random(2)]) end
        if waterstatus == 15 then self:addTile(nil, tx, ty, self.tileset["water_singleisland"..math.random(2)]) end]]
      end
    end
  end
end

--[[function room:update()
  if self.door_close_time then
    local closed = false
    if self.door_close_time.north and self.door_close_time.north < game_time then
      self[self.width / 2][1].kind = "wall"
      self[1 + self.width / 2][1].kind = "wall"
      closed = true
      self.door_close_time.north = nil
    end
    if self.door_close_time.south and self.door_close_time.south < game_time then
      self[self.width / 2][self.height].kind = "wall"
      self[1 + self.width / 2][self.height].kind = "wall"
      closed = true
      self.door_close_time.south = nil
    end
    if self.door_close_time.east and self.door_close_time.east < game_time then
      self[self.width][self.height / 2].kind = "wall"
      self[self.width][1 + self.height / 2].kind = "wall"
      closed = true
      self.door_close_time.east = nil
    end
    if self.door_close_time.west and self.door_close_time.west < game_time then
      self[1][self.height / 2].kind = "wall"
      self[1][1 + self.height / 2].kind = "wall"
      closed = true
      self.door_close_time.west = nil
    end

    if closed then
      --self:setup_tile_images()
      audiomanager:playOnce("unlatch")
    end
  end
end]]

--[[function room:is_solid(gx, gy)
  return (not self:in_bounds(gx, gy)) or self[gx][gy].kind == "wall" or self[gx][gy].kind == "void" or self[gx][gy].kind == "fake_floor"
end]]

--[[function room:coda()
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
end]]
--[[
function room:open_door(dir, fake, time)
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

  local k = fake and "fake_floor" or "floor"

  if dir == "north" then
    self[self.width / 2][1].kind = k
    self[1 + self.width / 2][1].kind = k
  elseif dir == "south" then
    self[self.width / 2][self.height].kind = k
    self[1 + self.width / 2][self.height].kind = k
  elseif dir == "east" then
    self[self.width][self.height / 2].kind = k
    self[self.width][1 + self.height / 2].kind = k
  elseif dir == "west" then
    self[1][self.height / 2].kind = k
    self[1][1 + self.height / 2].kind = k
  end

  --self:setup_tile_images()
end
]]
--[[function room.bounding_box(gx, gy)
  return {x = TILESIZE * (gx + 0.5), y = TILESIZE * (gy + 0.5), radius = TILESIZE / 2}
end

function current_level:pos_to_grid(p)
  return math.floor(p / TILESIZE)
end]]


--[[function room:pixel_width()
  return (self.width + 2) * TILESIZE
end

function room:pixel_height()
  return (self.height + 2) * TILESIZE
end]]

--[[
function room:setup_tile_images()
  local kind
  for gx = 1, self.width do
    for gy = 1, self.height do
      kind = self[gx][gy].kind
      self[gx][gy].tile, self[gx][gy].tile_rotation, self[gx][gy].tile_sx, self[gx][gy].tile_sy = nil, nil, nil, nil
      if kind == "floor" or kind == "fake_floor" then
        self[gx][gy].tile = "floor"
      elseif kind == "water_border" then
        self[gx][gy].tile = "water_border"
      elseif kind == "ballpost" then
        self[gx][gy].tile = "ballpost"
      elseif kind == "teleporter" then
        self[gx][gy].tile = "teleporter"
      elseif kind == "wall" then
        -- XXX do better at picking which tile
        if gx == 1 and gy == 1 then
          self[gx][gy].tile = "corner_nw"
        elseif gx == 1 and gy == self.height then
          self[gx][gy].tile = "corner_nw"
          self[gx][gy].tile_rotation = -math.pi / 2
        elseif gx == self.width and gy == self.height then
          self[gx][gy].tile = "corner_nw"
          self[gx][gy].tile_rotation = math.pi
        elseif gx == self.width and gy == 1 then
          self[gx][gy].tile = "corner_nw"
          self[gx][gy].tile_rotation = math.pi / 2
        elseif gx == 2 and gy == 1 then
          self[gx][gy].tile = "wallcorner_transition"
        elseif gx == self.width - 1 and gy == 1 then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_sx = -1
        elseif gx == 1 and gy == 2 then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_rotation = -math.pi / 2
          self[gx][gy].tile_sx = -1
        elseif gx == 1 and gy == self.height - 1 then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_rotation = -math.pi / 2
        elseif gx == 2 and gy == self.height then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_rotation = math.pi
          self[gx][gy].tile_sx = -1
        elseif gx == self.width - 1 and gy == self.height then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_rotation = math.pi
        elseif gx == self.width and gy == 2 then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_rotation = math.pi / 2
        elseif gx == self.width and gy == self.height - 1 then
          self[gx][gy].tile = "wallcorner_transition"
          self[gx][gy].tile_rotation = math.pi / 2
          self[gx][gy].tile_sx = -1
        elseif gy == 1 then
          self[gx][gy].tile = "wall"
        elseif gx == 1 then
          self[gx][gy].tile = "wall"
          self[gx][gy].tile_rotation = -math.pi / 2
        elseif gy == self.height then
          self[gx][gy].tile = "wall"
          self[gx][gy].tile_rotation = math.pi
        elseif gx == self.width then
          self[gx][gy].tile = "wall"
          self[gx][gy].tile_rotation = math.pi / 2
        else
          -- default
          self[gx][gy].tile = "wall"
        end
      end
    end
  end
end]]


return Level
