local Tile = class("Tile")

function Tile:initialize(name, mapsymbol)
  self.layer = Layer.FLOOR
  self.id = name
  self.kind = name
  self.sprite = name
  self.mapsymbol = mapsymbol or nil
  return self
end

function Tile:setSolid(state)
  self.issolid = state
  return self
end

function Tile:setDoor(state)
  self.isdoor = state
  return self
end

function Tile:setRotation(state)
  self.rot = state or 0
  return self
end


function Tile:setDestroyable(kind, into, hp)
  self.destroyable = kind or false
  if kind and into then
    self.destroyed_version = into
    self.maxhp = hp or 100
    self.hp = self.maxhp
  end
  return self
end

function Tile:takeDamage(dmg)
  if self.destroyable then
    self.hp = cpml.utils.clamp(self.hp - dmg, self.hp - dmg, self.maxhp)
    if self.hp <= 0 then
      -- launch explosion
      explosions.rubble(self.x * TILESIZE + 32, self.y * TILESIZE + 32)

      -- replace self
      current_level:addTile(nil, self.x, self.y, current_level.tileset[self.destroyed_version])
    end
  end
end


function Tile:setSmoke(hp)
  self.smokepoint = hp
  return self
end

function Tile:setLayer(l)
  self.layer = l
  return self
end

function Tile:toEntity(x, y)
  --print("sprite to entity "..self.id.." ".. self.sprite .. " " .. self.kind)
  local e = Entity:new(self, 'sprite' .. self.id, self.id, (x + 0.5) * TILESIZE, (y + 0.5) * TILESIZE, self.layer, image[self.sprite], self.rot or 0, 1.0, 1.0, TILESIZE / 2, TILESIZE / 2)
  return e
end

return Tile
