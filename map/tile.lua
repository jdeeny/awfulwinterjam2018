local Tile = class("Tile")

function Tile:initialize(name, mapsymbol)
  print("New tile " .. name)
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
      ExplosionParticles:new(self.x * TILESIZE + 32, self.y * TILESIZE + 32, 2, 2, .2, 1.0)
      for i = 1, 12 + love.math.random(8) do
        angle = love.math.random() * 2 * math.pi
        speed = 800 + 4000 * love.math.random()
        spark_data.spawn("spark", {r=255, g=120, b=50},
          self.x * TILESIZE + 32 + 32 * math.cos(angle), self.y * TILESIZE + 32 + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
      end
      for i = 1, 12 + love.math.random(8) do
        angle = love.math.random() * 2 * math.pi
        speed = 600 + 3000 * love.math.random()
        spark_data.spawn("spark_big", {r=255, g=120, b=50},
          self.x * TILESIZE + 32 + 32 * math.cos(angle), self.y * TILESIZE + 32 + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
      end
      for i = 1, 4 + love.math.random(4) do
        angle = love.math.random() * 2 * math.pi
        speed = 200 + 2200 * love.math.random()
        spark_data.spawn("shard", {r=255, g=230, b=100},
          self.x * TILESIZE + 32 + 32 * math.cos(angle), self.y * TILESIZE + 32 + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
      end
      for i = 1, 4 + love.math.random(4) do
        angle = love.math.random() * 2 * math.pi
        speed = 200 + 2200 * love.math.random()
        spark_data.spawn("shard", {r=255, g=120, b=50},
          self.x * TILESIZE + 32 + 32 * math.cos(angle), self.y * TILESIZE + 32 + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
      end
      for i = 1, 4 + love.math.random(4) do
        angle = love.math.random() * 2 * math.pi
        speed = 100 + 1200 * love.math.random()
        spark_data.spawn("pow", {r=255, g=230, b=100},
          self.x * TILESIZE + 32 + 32 * math.cos(angle), self.y * TILESIZE + 32 + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
      end
      for i = 1, 4 + love.math.random(4) do
        angle = love.math.random() * 2 * math.pi
        speed = 100 + 1200 * love.math.random()
        spark_data.spawn("pow", {r=255, g=120, b=50},
          self.x * TILESIZE + 32 + 32 * math.cos(angle), self.y * TILESIZE + 32 + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
      end

      spark_data.spawn("explosion", {r=255, g=230, b=100},
        self.x * TILESIZE + 32, self.y * TILESIZE + 32, 0, 0)

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
  print("sprite to entity "..self.id.." ".. self.sprite .. " " .. self.kind)
  local e = Entity:new(self, 'sprite' .. self.id, self.id, (x + 0.5) * TILESIZE, (y + 0.5) * TILESIZE, self.layer, image[self.sprite], 0, 1.0, 1.0, TILESIZE / 2, TILESIZE / 2)
  return e
end

return Tile
