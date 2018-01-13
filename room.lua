local room = class('room', grid)

-- XXX replace with room_data
function room:setup_main()
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx == 1 or gy == 1 or gx == self.width or gy == self.height then
        self[gx][gy].kind = "wall"
      else
        self[gx][gy].kind = "floor"
      end
    end
  end

  for x = 1, 16 do
    self[love.math.random(6, self.width - 5)][love.math.random(6, self.height - 5)].kind = "wall"
  end
end

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

function room:draw()
  local kind
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx * TILESIZE - camera.x > -TILESIZE and gx * TILESIZE - camera.x < window.w and
          gy * TILESIZE - camera.y > -TILESIZE and gy * TILESIZE - camera.y < window.h then
        kind = self:feature_at(gx, gy)
        if kind ~= "void" then
          love.graphics.draw(image[kind], gx * TILESIZE - camera.x, gy * TILESIZE - camera.y)
        end
      end
    end
  end
end

return room
