local room = class('room')

-- XXX replace with room_data
function room:init(w, h)
  self.width = w
  self.height = h

  for gx = 1, w do
    self[gx] = {}
    for gy=1, h do
      self[gx][gy] = {block = "void"}
    end
  end
end

function room:setup_main()
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx == 1 or gy == 1 or gx == self.width or gy == self.height or ((gx == 6 or gx == 9) and gy > 3 and gy < 24) then
        self[gx][gy].block = "wall"
      else
        self[gx][gy].block = "floor"
      end
    end
  end
end

function room:in_bounds(gx, gy)
  return gx >= 1 and gx <= self.width and gy >= 1 and gy <= self.height
end

function room:block_at(gx, gy)
  if not self:in_bounds(gx, gy) then
    return "void" -- the void
  else
    return self[gx][gy].block
  end
end

function room:is_solid(gx, gy)
  return (not self:in_bounds(gx, gy)) or self[gx][gy].block == "wall" or self[gx][gy].block == "void"
end

function room:coda()
  -- we're done in this room; open doors and let the player move on
  dungeon.move_to_room()
end

function room.bounding_box(gx, gy)
  return {x = TILESIZE * (gx + 0.5), y = TILESIZE * (gy + 0.5), radius = TILESIZE / 2}
end

function room.pos_to_grid(p)
  return math.floor(p / TILESIZE)
end

function room:draw()
  local block
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx * TILESIZE - camera.x > -TILESIZE and gx * TILESIZE - camera.x < window.w and
          gy * TILESIZE - camera.y > -TILESIZE and gy * TILESIZE - camera.y < window.h then
        block = self:block_at(gx, gy)
        if block ~= "void" then
          love.graphics.draw(image[block], gx * TILESIZE - camera.x, gy * TILESIZE - camera.y)
        end
      end
    end
  end
end

return room
