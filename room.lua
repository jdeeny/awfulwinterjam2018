local room = class('room', grid)

function room:is_solid(gx, gy)
  return (not self:in_bounds(gx, gy)) or self[gx][gy].kind == "wall" or self[gx][gy].kind == "void"
end

function room:coda()
  -- we're done in this room; open doors and let the player move on
  if self.exits.north then
    self[self.width / 2][1].kind = "floor"
    self[1 + self.width / 2][1].kind = "floor"
    doodad_data.spawn("exit_north", current_room:pixel_width() / 2, TILESIZE / 2)
  end
  if self.exits.east then
    self[self.width][self.height / 2].kind = "floor"
    self[self.width][1 + self.height / 2].kind = "floor"
    doodad_data.spawn("exit_east", current_room:pixel_width() - (TILESIZE / 2), current_room:pixel_height() / 2)
  end
  audiomanager:playOnce("unlatch") -- open the doors
  self:setup_tile_images()
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

function room:setup_tile_images()
  local kind
  for gx = 1, self.width do
    for gy = 1, self.height do
      kind = self[gx][gy].kind
      self[gx][gy].tile, self[gx][gy].tile_rotation, self[gx][gy].tile_sx, self[gx][gy].tile_sy = nil, nil, nil, nil
      if kind == "floor" then
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
end

function room:draw()
  local kind
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx * TILESIZE - camera.x > -TILESIZE and gx * TILESIZE - camera.x < window.w and
          gy * TILESIZE - camera.y > -TILESIZE and gy * TILESIZE - camera.y < window.h then
        if self[gx][gy].tile then
          if self[gx][gy].tile == "water_border" then
            water.draw(image[self[gx][gy].tile], (gx + 0.5) * TILESIZE - camera.x, (gy + 0.5) * TILESIZE - camera.y,
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
end

return room
