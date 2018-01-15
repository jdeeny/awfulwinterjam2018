local Layer = class("Layer")

function Layer:intialize(drawable, effects)
  self.drawable = drawable
  self.effects = effects
  self.locations = {}
end

function Layer:draw()
  if self.effects then
  end
  for loc, params in self.locations do
    love.graphics.draw()
  end
end

return Layer
