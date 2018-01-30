local Layer = class("Layer")

Layer.BOTTOM = 1
Layer.SUBFLOOR = 2
Layer.WATER = 3
Layer.FLOOR = 4
Layer.BLOOD = 5
Layer.BODIES = 6
Layer.FURNITURE = 7
Layer.SHADOW = 8
Layer.FXUNDER = 9
Layer.ENTITY = 10
Layer.ENTITYNOSHADOW = 11
Layer.SMOKE = 12
Layer.FXOVER = 13
Layer.HUD = 14
Layer.BROKEN = 15
Layer.LASTLAYER = 15

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
