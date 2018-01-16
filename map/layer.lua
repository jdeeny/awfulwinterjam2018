local Layer = class("Layer")

Layer.WATER = 1
Layer.FLOOR = 2
Layer.SHADOW = 3
Layer.FXUNDER = 4
Layer.ENTITY = 5
Layer.ENTITYOVER = 6
Layer.FXOVER = 7
Layer.HUD = 8


function Layer:initialize(id, effects)
  self.id = id
  self.entities = {}
  self.effects = effects
end

function Layer:add(kind, id, entity)
  if not self.entities[kind] then self.entities[kind] = {} end
  self.entities[kind][id] = entity
end

function Layer:remove(kind, id)
  self.entities[kind][id] = nil
end

function Layer:draw()
  if self.effects then
    self.effects(self:_drawall())
  else
    self_drawall()
  end
end

function Layer:_drawall()
  for id, e in self.entites do  -- for each type of thing
    for id, location in e do    -- for each location
      print("!")
      --love.graphics.draw()
    end
  end
end

return Layer
