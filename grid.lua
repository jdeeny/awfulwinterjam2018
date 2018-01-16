local grid = class('grid')

function grid:init(w, h)
  self.width = w
  self.height = h

  for gx = 1, w do
    self[gx] = {}
    for gy=1, h do
      self[gx][gy] = {kind = "void"}
    end
  end
end

function grid:in_bounds(gx, gy)
  return gx >= 1 and gx <= self.width and gy >= 1 and gy <= self.height
end

function grid:feature_at(gx, gy)
  if not self:in_bounds(gx, gy) then
    return "void" -- the void
  else
    return self[gx][gy].kind
  end
end

function grid.hash(x, y)
  return 512 * x + y
end

function grid.unhash(hash)
  return math.floor(hash / 512), hash % 512
end

return grid
