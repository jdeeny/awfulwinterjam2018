local Layer = class("Layer")

Layer.WATER = 1
Layer.FLOOR = 2
Layer.BODIES = 3
Layer.FURNITURE = 4
Layer.SHADOW = 5
Layer.FXUNDER = 6
Layer.ENTITY = 7
Layer.ENTITYNOSHADOW = 8
Layer.FXOVER = 9
Layer.HUD = 10
Layer.BROKEN = 11
Layer.LASTLAYER = 12

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
  if self.effects then
    self.effects:update(dt)
  end

  for kindname, kind  in pairs(self.entities) do  -- for each type of thing
    for id, e in pairs(kind) do    -- for each location
      e:update(dt)
    end
  end
end

function Layer:draw()
  if self.effects then
    water_effect.effect(function()
      self:_drawall()
    end)
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
