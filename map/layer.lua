local Layer = class("Layer")

Layer.WATER = 1
Layer.FLOOR = 2
Layer.SHADOW = 3
Layer.FXUNDER = 4
Layer.ENTITY = 5
Layer.ENTITYOVER = 6
Layer.FXOVER = 7
Layer.HUD = 8
Layer.BROKEN = 9
Layer.LASTLAYER = 9

function Layer:initialize(id, effects)
  self.id = id
  self.entities = {}
  self.effects = effects
end

function Layer:add(id, entity)
  local kind = entity.kind

  if self.entities[kind] == nil then self.entities[kind] = {} end
  local l = self.entities[kind]
  self.entities[kind][id] = entity
end

function Layer:remove(id)
  for kindname, kind  in pairs(self.entities) do  -- for each type of thing
    kind[id] = nil
  end
end

function Layer:update(dt)
  for kindname, kind  in pairs(self.entities) do  -- for each type of thing
    for id, e in pairs(kind) do    -- for each location
      e:update(dt)
    end
  end
end

function Layer:draw()
  if self.effects then
    self.effects(self:_drawall())
  else
    self:_drawall()
  end
end

function Layer:_drawall()
  for kindname, kind  in pairs(self.entities) do  -- for each type of thing
    for id, e in pairs(kind) do    -- for each location
      e:draw()
    end
  end
end

return Layer
