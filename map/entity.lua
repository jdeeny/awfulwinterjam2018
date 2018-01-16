local Entity = class("Entity")

function Entity:initialize(id, x, y, layer, drawable, rotation, sx, sy, ox, oy)
  print("!")
  self.id = id
  self.loc = cpml.vec2.new(x, y)
  self.layer = layer
  self.drawable = drawable
  self.rot = rotation or 0.0
  self.sx = sx or 1.0
  self.sy = sy or 1.0
  self.ox = ox or 0.0
  self.oy = oy or 0.0
  return self
end

function Entity:update(dt)
end

function Entity:draw()
  love.graphics.draw(self.drawable, self.loc.x - camera.x, self.loc.y - camera.y, self.rot, sx, sy, ox, oy)
end

return Entity
