local room = class('room', grid)

function room:update()
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
end

function room:is_solid(gx, gy)
  return (not self:in_bounds(gx, gy)) or self[gx][gy].kind == "wall" or self[gx][gy].kind == "void" or self[gx][gy].kind == "fake_floor"
end

function room:coda()
  -- we're done in this room; open doors and let the player move on
  self.cleared = true
  if self.exits.north then
    self:open_door("north", false) -- no time given, so it should stay open forever
    doodad_data.spawn("exit_north", current_room:pixel_width() / 2, TILESIZE / 2)
  end
  if self.exits.east then
    self:open_door("east", false)
    doodad_data.spawn("exit_east", current_room:pixel_width() - (TILESIZE / 2), current_room:pixel_height() / 2)
  end
end

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

function room.bounding_box(gx, gy)
  return {x = TILESIZE * (gx + 0.5), y = TILESIZE * (gy + 0.5), radius = TILESIZE / 2}
end

function room.pos_to_grid(p)
  return math.floor(p / TILESIZE)
end

function room:pixel_width()
  return (self.width + 2) * TILESIZE
end

function room:pixel_height()
  return (self.height + 2) * TILESIZE
end

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

--[[function room:draw()
  local kind
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx * TILESIZE - camera.x > -TILESIZE and gx * TILESIZE - camera.x < window.w and
          gy * TILESIZE - camera.y > -TILESIZE and gy * TILESIZE - camera.y < window.h then
        if self[gx][gy].tile then
          if self[gx][gy].tile == "water_border" then
            water_effect.draw(image[self[gx][gy].tile], (gx + 0.5) * TILESIZE - camera.x, (gy + 0.5) * TILESIZE - camera.y,
              self[gx][gy].tile_rotation or 0, self[gx][gy].tile_sx or 1, self[gx][gy].tile_sy or 1, TILESIZE / 2, TILESIZE / 2)
          elseif self[gx][gy].tile == "ballpost" then
            love.graphics.draw(image['floor'], (gx + 0.5) * TILESIZE - camera.x, (gy + 0.5) * TILESIZE - camera.y,
              self[gx][gy].tile_rotation or 0, self[gx][gy].tile_sx or 1, self[gx][gy].tile_sy or 1, TILESIZE / 2, TILESIZE / 2)
            love.graphics.draw(image[self[gx][gy].tile], (gx + 0.5) * TILESIZE - camera.x, (gy + 0.5) * TILESIZE - camera.y,
              self[gx][gy].tile_rotation or 0, self[gx][gy].tile_sx or 1, self[gx][gy].tile_sy or 1, TILESIZE / 2, TILESIZE / 2)
          else
            love.graphics.draw(image[self[gx][gy].tile], (gx + 0.5) * TILESIZE - camera.x, (gy + 0.5) * TILESIZE - camera.y,
              self[gx][gy].tile_rotation or 0, self[gx][gy].tile_sx or 1, self[gx][gy].tile_sy or 1, TILESIZE / 2, TILESIZE / 2)
          end
        end
      end
    end
  end
end]]

return room
