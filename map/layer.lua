local Layer = class("Layer")

Layer.SUBFLOOR = 1
Layer.WATER = 2
Layer.FLOOR = 3
Layer.BLOOD = 4
Layer.BODIES = 5
Layer.FURNITURE = 6
Layer.SHADOW = 7
Layer.FXUNDER = 8
Layer.ENTITY = 9
Layer.ENTITYNOSHADOW = 10
Layer.SMOKE = 11
Layer.FXOVER = 12
Layer.HUD = 13
Layer.BROKEN = 14
Layer.LASTLAYER = 14

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
      love.graphics.setBlendMode("alpha", "alphamultiply")
      self:_drawall()
    end)
  else
    love.graphics.setBlendMode("alpha", "alphamultiply")
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
