local map = {}

function map:new(w, h)
  o = {width = w, height = h}
  setmetatable(o, self)
  self.__index = self

  for gx = 1, w do
    o[gx] = {}
    for gy=1, h do
      o[gx][gy] = {block = "void"}
    end
  end

  return o
end

function map:init_main()
  for gx = 1, self.width do
    for gy = 1, self.height do
      if gx == 1 or gy == 1 or gx == self.width or gy == self.height or (gx == 10 or gx == 16 and gy > 10 and gy < 24) then
        self[gx][gy].block = "wall"
      else
        self[gx][gy].block = "floor"
      end
    end
  end
end

function map:in_bounds(gx, gy)
  return gx >= 1 and gx <= self.width and gy >= 1 and gy <= self.height
end

function map:block_at(gx, gy)
  if not self:in_bounds(gx, gy) then
    return "void" -- the void
  else
    return self[gx][gy].block
  end
end

function map:is_solid(gx, gy)
  return (not self:in_bounds(gx, gy)) or self[gx][gy].block == "wall" or self[gx][gy].block == "void"
end

function map.bounding_box(gx, gy)
  return {x = TILESIZE * (gx + 0.5), y = TILESIZE * (gy + 0.5), radius = TILESIZE / 2}
end

function map.pos_to_grid(p)
  return math.floor(p / TILESIZE)
end

return map
