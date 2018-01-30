RoomDef = class("RoomDef")

RoomDef.static.RANDOM = 0
RoomDef.static.NORTH = 1
RoomDef.static.EAST = 2
RoomDef.static.SOUTH = 3
RoomDef.static.WEST = 4

function RoomDef:initialize()
  self.maptiles = {}
  self.spawns = {}

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
  return self
end

function RoomDef:setMap(map_string)
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

return RoomDef
