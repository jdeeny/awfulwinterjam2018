RoomDef = class("RoomDef")

RoomDef.static.RANDOM = 0
RoomDef.static.NORTH = 1
RoomDef.static.EAST = 2
RoomDef.static.SOUTH = 3
RoomDef.static.WEST = 4

function RoomDef:initialize(name)
  self.name = name
  self.floorstr = ""
  self.mapstr = ""
  self.maptiles = {}
  self.spawns = {}
  self.doors = {}
  -- Setup default tile/letter combos
  --self.maptiles['.'] = 'floor'
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
  print("spawn_data id: "..spawn_data.id)
  local spawndata = {}
  spawndata.id = spawn_data.id or 'spawn'..math.random()
  spawndata.start = spawn_data.start or 0
  spawndata.mob = spawn_data.mob or 'rifledude'
  spawndata.count = spawn_data.count or 1
  spawndata.spawnkind = spawn_data.spawnkind or 'clump'
  spawndata.spawnperiod = spawn_data.spawnperiod or spawndata == 'clump' and 0.05 or 0.3
  spawndata.door = spawn_data.door or self.RANDOM
  spawndata.complete = spawn_data.complete or false
  self.spawns[spawndata.id] = spawndata
  print("addspawn: "..self.spawns[spawndata.id].id)
  return self
end

function RoomDef:launchSpawn(id)
  local spawns = {}

  -- if id is specified, load only that spawn
  if id ~= nil then
    if self.spawndata[id] then
      spawns[id] = self.spawndata[id]
    else
      print("Unknown spawn id: "..id)
      return
    end
  else
    print("Spawn is spawndata")
    spawns = self.spawns
  end

  for i, s in pairs(spawns) do
    local f = function()
      local door = s.door ~= RoomDef.RANDOM and s.door or math.random(4)
      local angle = -PI + (PI/2) * door + (-PI/8 + math.random() * PI / 4)
      for i = 1, s.count do
        if s.spawnkind == 'line' then
          local a = angle
        elseif s.spawnkind == 'clump' then
          local a = angle + (-PI/8 + math.random() * PI / 4)
        elseif s.spawnkind == 'stream' then
          local a = angle + (-PI/32 + math.random() * PI / 16)
        else
          local a = angle + (-PI/32 + math.random() * PI / 16)
        end
        delay.start(i * s.spawnperiod + (-s.spawnperiod/10 + math.random() * s.spawnperiod/5),
                    function()
                      if door == RoomDef.NORTH then
                        spawner.spawn_from_north_door(s.mob, a)
                      elseif door == RoomDef.EAST then
                        spawner.spawn_from_east_door(s.mob, a)
                      elseif door == RoomDef.SOUTH then
                        spawner.spawn_from_south_door(s.mob, a)
                      elseif door == RoomDef.WEST then
                        spawner.spawn_from_west_door(s.mob, a)
                      else
                        print("Attempt to spawn from unknown door: "..s.door)
                      end
                      if s.complete == true then
                        delay.start(2, function()
                          spawner.complete = true
                          spawner.test_completion()
                        end)
                      end
                    end)

      end
    end
    spawner.add(s.start, f)
  end

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

--[[  for x = 1, self.w do
    for y = 1, self.h do
      m:addTile(grid.hash(x, y), x, y, m.tileset['empty'])
    end
  end]]

  print("parse")
  local floorlines = self.floorstr:gmatch("[^\n]+")
  local maplines = self.mapstr:gmatch("[^\n]+")
  m = self:_parse(m, maplines, m.addTile)
  m = self:_parse(m, floorlines, m.addFloor)

  print("wh: "..self.w.." ".. self.h)

	return m
end

function RoomDef:_parse(level, lines, addfunc)
  --print("lines: ")
  local x = 1
  local y = 1
  for s in lines do
		for c in s:gmatch"." do
      --print("c: "..x.." "..y.." "..c)
			local tilekind = self.maptiles[c] or level:find_symbol(c) or 'empty'
      print(x..", "..y.."  "..tilekind)
	   addfunc(level, grid.hash(x, y), x, y, level.tileset[tilekind])
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
-- Stage 1 - Edison Machine Works

-- Enemies: remotedude_red & rifledude
RoomDef.static.rooms['s1r1'] = require 'map/rooms/stage1/room1'     -- Tesla's workspace
-- Enemies: add remotedude_blue
RoomDef.static.rooms['s1r2a'] = require 'map/rooms/stage1/room2a'   -- More workspace
RoomDef.static.rooms['s1r2b'] = require 'map/rooms/stage1/room2b'   -- Tunnel
-- Enemies: add bursterdude
RoomDef.static.rooms['s1r3a'] = require 'map/rooms/stage1/room3a'   -- R&D
RoomDef.static.rooms['s1r3b'] = require 'map/rooms/stage1/room3b'   -- Warehouse
-- Enemies: add sniper
RoomDef.static.rooms['s1r4a'] = require 'map/rooms/stage1/room4a'   -- Production
RoomDef.static.rooms['s1r4b'] = require 'map/rooms/stage1/room4b'   -- Quality
-- Enemies: add lump
RoomDef.static.rooms['s1r5a'] = require 'map/rooms/stage1/room5a'   -- Empty edison office
RoomDef.static.rooms['s1r5b'] = require 'map/rooms/stage1/room5b'   -- Charle's office
-- Enemies: add Boss 1 - Charles Batchelder (special burster)
RoomDef.static.rooms['s1r6'] = require 'map/rooms/stage1/room6'     -- Exit?


-- Stage 2 - Wardenclyffe
-- Enemies: add canbot
RoomDef.static.rooms['s2r1'] = require 'map/rooms/stage2/room1'     -- Entrance / Foyer
RoomDef.static.rooms['s2r2'] = require 'map/rooms/stage2/room2'     -- Hallway
-- Enemies: add remotedude_green + controller (does not exist yet)
RoomDef.static.rooms['s2r3'] = require 'map/rooms/stage2/room3'     -- Office
-- Enemies: add rocket
RoomDef.static.rooms['s2r4a'] = require 'map/rooms/stage2/room4a'   -- 1st floor
RoomDef.static.rooms['s2r4b'] = require 'map/rooms/stage2/room4b'   -- 2nd floor
-- Enemies: add superlump
RoomDef.static.rooms['s2r5'] = require 'map/rooms/stage2/room5'     -- Tower base bldg
RoomDef.static.rooms['s2r6'] = require 'map/rooms/stage2/room6'     -- Tower 1
-- Enemies: add shottydude (does not exist yet)
RoomDef.static.rooms['s2r7'] = require 'map/rooms/stage2/room7'     -- Tower 2
-- Enemies: add Boss 2 - Megalump (== marconi, does not exist yet)
RoomDef.static.rooms['s2r8'] = require 'map/rooms/stage2/room8'     -- Top of tower


-- Stage 3 - Edison's Lair
-- Enemies: add homing rocket
RoomDef.static.rooms['s3r1'] = require 'map/rooms/stage3/room1'     -- Library 1
-- Enemies: add burster badass
RoomDef.static.rooms['s3r2'] = require 'map/rooms/stage3/room2'     -- Library 2
-- Enemies: add super sniper (burst sniper, does not exist yet)
RoomDef.static.rooms['s3r3'] = require 'map/rooms/stage3/room3'     -- Catacombs 1
RoomDef.static.rooms['s3r4'] = require 'map/rooms/stage3/room4'     -- Catacombs 2
-- Enemies: add Boss 3 - Edison
RoomDef.static.rooms['s3r5'] = require 'map/rooms/stage3/room5'     -- Edison's Lair



RoomDef.static.firstroom = RoomDef.static.rooms['s1r1']

return RoomDef
