RoomDef = class("RoomDef")

RoomDef.static.RANDOM = 0
RoomDef.static.NORTH = 1
RoomDef.static.EAST = 2
RoomDef.static.SOUTH = 3
RoomDef.static.WEST = 4

function RoomDef:initialize(name)
  self.name = name
  self.maptiles = {}
  self.spawns = {}
  self.doors = {}
  -- Setup default tile/letter combos
  self.maptiles['.'] = 'floor'
  return self
end

function RoomDef:setMaptile(key, kind)
  print(self)
  self.maptiles[key] = kind
  return self
end

function RoomDef:setFloor(floor_string)
  self.floorstr = floor_string
  return self
end

function RoomDef:setMap(map_string)
  self.mapstr = map_string
  return self
end

function RoomDef:setDoor(door, status)
  self.doors[door] = status
  return self
end

function RoomDef:addSpawn(spawn_data)
  local spawndata = {}
  spawndata.id = spawn_data.id or 'spawn'..math.random()
  spawndata.start = spawn_data.start or 0
  spawndata.mob = spawn_data.mob or 'rifledude'
  spawndata.count = spawn_data.count or 1
  spawndata.spawnkind = spawn_data.spawnkind or 'clump'
  spawndata.spawnperiod = spawn_data.spawnperiod or 0.3
  spawndata.door = spawn_data.door or RANDOM
  self.spawns[spawndata.id] = spawndata
  return self
end

function RoomDef:parse()
  local floorlines = self.floorstr:gmatch("[^\n]+")
  local fx = 0
  local fy = 0
  for l in floorlines do
    local len = l:len()
    print("fx:"..fx)
    fx = math.max(fx, len)
    if l:len() > 3 then
      fy = fy + 1
    end
  end
  self.w = math.max(fx, self.w or 0)
  self.h = math.max(fy, self.h or 0)
  local maplines = self.mapstr:gmatch("[^\n]+")
  local mx = 0
  local my = 0
  for l in maplines do
    if l:len() > mx then mx = l:len() end
    if l:len() > 3 then
      my = my + 1
    end
  end
  self.w = math.max(mx, self.w or 0)
  self.h = math.max(my, self.h or 0)

	local m = Level:new(self.w, self.h):setLayerEffects(Layer.WATER, water_effect)
  print("parse")
  local floorlines = self.floorstr:gmatch("[^\n]+")
  local maplines = self.mapstr:gmatch("[^\n]+")
  m = self:_parse(m, floorlines)
  m = self:_parse(m, maplines)

  for x = 1, self.w do
    for y = 1, self.h do
      m:addTile(grid.hash(x, y), x, y, m.tileset['void'])
    end
  end

  print("wh: "..self.w.." ".. self.h)

	return m
end

function RoomDef:_parse(level, lines)
  --print("lines: ")
  local x = 1
  local y = 1
  for s in lines do
		for c in s:gmatch"." do
      --print("c: "..x.." "..y.." "..c)
			local tilekind = self.maptiles[c] or level:find_symbol(c) or 'void'
			level:addTile(grid.hash(x, y), x, y, level.tileset[tilekind])
			x = x + 1
		end
    if x > 3 then
      y = y + 1
    end
    x = 1
	end
  return level
end

-- Put rooms in list
RoomDef.static.rooms = {}
RoomDef.static.rooms['s1r1'] = require 'map/rooms/stage1/room1'
RoomDef.static.rooms['s1r2a'] = require 'map/rooms/stage1/room2a'
RoomDef.static.rooms['s1r2b'] = require 'map/rooms/stage1/room2b'
RoomDef.static.rooms['s1r3a'] = require 'map/rooms/stage1/room3a'
RoomDef.static.rooms['s1r3b'] = require 'map/rooms/stage1/room3b'
RoomDef.static.rooms['s1r4a'] = require 'map/rooms/stage1/room4a'
RoomDef.static.rooms['s1r4b'] = require 'map/rooms/stage1/room4b'
RoomDef.static.rooms['s1r5'] = require 'map/rooms/stage1/room5'

RoomDef.static.firstroom = RoomDef.static.rooms['s1r1']

return RoomDef
