local Terrain = class("Terrain")


function Terrain:initialize(name, w, h, default)
  assert(name and w and h and default, "Must pass a name, width, height, and default tile")
  self.name = name
  self.w = w
  self.h = h
  self.default = default
  self.tiles = {}
  self.terrains = " "
end

-- Add a tile and all rotation/flip variations
function Terrain:addTile(terrain, tile, surroundings)
  if not self.terrains:find(terrain) then
    self.terrains = self.terrains .. terrain
  end

  -- for each '*' replace with each terrain type and recurse
  if string.find(surroundings, '*') then
    local start = 1
    local f = string.find(surroundings, '*', start)
    while f do
      for t in self.terrains:gmatch(".") do
        print("f: "..f.. " t: "..t)
        local s = string.sub(surroundings, 1, f-1)..t..string.sub(surroundings,f+1)
        print(s)
        self:addTile(terrain, tile, s)
      end
      start = f+1
      f = string.find(surroundings, '*', start)
    end
    return
  end

  local cw = self:_rotatecw(surroundings)
  local ccw = self:_rotateccw(surroundings)
  print("")
  print("add tile: ["..surroundings..']')

  self:_add(surroundings, { function() return Tile:new(tile) end } )
  self:_add(cw, { function() return Tile:new(tile):setRotation(PI/2) end } )
  self:_add(ccw, { function() return Tile:new(tile):setRotation(-PI/2) end } )
  self:_add(self:_flipv(cw), { function() return Tile:new(tile):setRotation(PI/2):setFlipV(true) end } )
  self:_add(self:_fliph(cw), { function() return Tile:new(tile):setRotation(PI/2):setFlipH(true) end } )
  self:_add(self:_flipv(ccw), { function() return Tile:new(tile):setRotation(-PI/2):setFlipV(true) end } )
  self:_add(self:_fliph(ccw), { function() return Tile:new(tile):setRotation(-PI/2):setFlipH(true) end } )
  self:_add(self:_flipv(surroundings), { function() return Tile:new(tile):setFlipV(true) end } )
  self:_add(self:_fliph(surroundings), { function() return Tile:new(tile):setFlipH(true) end } )
  self:_add(self:_flipv(self:_fliph(surroundings)), { function() return Tile:new(tile):setFlipH(true):setFlipV(true) end } )
end

function Terrain:debugPrint()
  local i = 0
  for name, t in pairs(self.tiles) do
    print(name.."  #"..#t)
    for _, subtile in ipairs(t) do
    end
    i = i + 1
  end
  print ("Total: "..i.."  Remain: "..256-i)
end

function Terrain:lookup(terrain, surroundings)
  if not self.tiles[surroundings] then
    print("Couldn't find: ".. surroundings.." using default" .. self.default)
    return { function() return Tile:new(self.default) end }
  end

  -- pick a random version
  local l = self.tiles[surroundings]
  local sel = math.random(#l)
  return l[sel]
end


function Terrain:_add(surroundings, tile)
  print("          ["..surroundings..']')
  if not self.tiles[surroundings] then
    self.tiles[surroundings] = {}
  end
  local slist = self.tiles[surroundings]
  slist[#slist+1] = tile
end

function Terrain:_rotatecw(surroundings)
  return string.sub(surroundings,7,8)..string.sub(surroundings,1,6)
end

function Terrain:_rotateccw(surroundings)
  return string.sub(surroundings,3,8)..string.sub(surroundings,1,2)
end

function Terrain:_fliph(surroundings)
  --print("flipv: "..surroundings)
  return string.reverse(string.sub(surroundings,1,5))..string.reverse(string.sub(surroundings,6,8))
end

function Terrain:_flipv(surroundings)
  return string.sub(surroundings,1,1)..string.reverse(string.sub(surroundings,2,8))
end


function Terrain:_getpermutes(t)
    return coroutine.wrap(Terrain._permute),8,t
end

function Terrain._permute(n,t,k,s)
    k=k or 1
    s=s or {}
    if k>n then
        coroutine.yield(table.concat(s))
    else
        for i=1,#t do
            s[k]=t[i]
            Terrain._permute(n,t,k+1,s)
        end
    end
end

return Terrain
