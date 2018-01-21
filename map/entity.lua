local Entity = class("Entity")

function Entity:initialize(t, id, kind, x, y, layer, drawable, rotation, sx, sy, ox, oy)
  self.kind = kind or 'unknownkind'
  self.id = id
  self.loc = cpml.vec2.new(x, y)
  self.x, self.y = x, y
  self.layer = layer
  self.drawable = drawable
  self.rot = rotation or 0.0
  self.sx = sx or 1.0
  self.sy = sy or 1.0
  self.ox = ox or 0.0
  self.oy = oy or 0.0
  self.t = t
  return self
end

function Entity:update(dt)
end

function Entity:takeDamage(dmg)
  self.t:takeDamage(dmg)
end

function Entity:draw()
  if not self.drawable then
    print("nil entity: "..self.id.." layer "..self.layer.." xy:"..self.x.." "..self.y)
  else
    love.graphics.draw(self.drawable, self.loc.x - camera.x, self.loc.y - camera.y, self.rot, self.sx, self.sy, self.ox, self.oy)
  end
end

return Entity
