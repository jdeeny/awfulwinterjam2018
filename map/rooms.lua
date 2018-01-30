local RoomDef = class("RoomDef")

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


local room_test1 = RoomDef:new()
room_test1:setMaptile('.', 'floor2')
room_test1:setMaptile(',', 'floor3')
room_test1:setFloor([[
........,,.........
........,,.........
........,,.........
,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,
........,,.........
........,,.........
........,,......
]])
room_test1:setMap([[
###################
#  ww      WW     #
#  www     WW  #  #
#   ww         #  #
#   www        #  #
#   wwww   WW  #  #
#    www   WW  ####
################
]])

room_test1:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_test1:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_test1:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_test1:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}

-- Put rooms in list
RoomDef.static.rooms = {}
RoomDef.static.rooms['test1'] = room_test1

return RoomDef
