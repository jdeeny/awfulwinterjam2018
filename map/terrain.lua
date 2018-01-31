local Terrain = class("Terrain")


function Terrain:initialize(name, w, h)
  self.name = name
  self.w = w
  self.h = h
  self.tiles = {}
  self.terrains = ""
end

-- Add a tile and all rotation/flip variations
function Terrain:addTile(terrain, tile, surroundings)
  if not self.terrains:find(terrain) then
    self.terrains = self.terrains .. terrain
  end
  local cw = self:_rotatecw(surroundings)
  local ccw = self:_rotateccw(surroundings)
  print("t: "..surroundings.."/"..cw.."/"..ccw.."/")

  self:_add(surroundings, tile)
  self:_add(cw, Tile:new(tile):setRotation(PI/2))
  self:_add(ccw, Tile:new(tile):setRotation(-PI/2))
  self:_add(self:_flipv(cw), Tile:new(tile):setRotation(PI/2):setFlipV(true))
  self:_add(self:_fliph(cw), Tile:new(tile):setRotation(PI/2):setFlipH(true))
  self:_add(self:_flipv(ccw), Tile:new(tile):setRotation(-PI/2):setFlipV(true))
  self:_add(self:_fliph(ccw), Tile:new(tile):setRotation(-PI/2):setFlipH(true))
  self:_add(self:_flipv(surroundings), Tile:new(tile):setFlipV(true))
  self:_add(self:_fliph(surroundings), Tile:new(tile):setFlipH(true))
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

function Terrain:showRemaining()
  --local permutes = self:_getpermutes(self.terrains)

end


function Terrain:_add(surroundings, tile)
  if not self.tiles[surroundings] then
    self.tiles[surroundings] = {}
  end
  local slist = self.tiles[surroundings]
  slist[#slist+1] = tile
end

function Terrain:_rotatecw(surroundings)
  return string.sub(surroundings,8,8)..string.sub(surroundings,1,7)
end

function Terrain:_rotateccw(surroundings)
  return string.sub(surroundings,2,8)..string.sub(surroundings,1,1)
end

function Terrain:_flipv(surroundings)
  print("flipv: "..surroundings)
  return string.reverse(string.sub(surroundings,1,5))..string.reverse(string.sub(surroundings,6,8))
end

function Terrain:_fliph(surroundings)
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
