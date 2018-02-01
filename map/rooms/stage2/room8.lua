local room_s2r8 = RoomDef:new('s2r8')

room_s2r8:setDoor(RoomDef.NORTH, nil)
room_s2r8:setDoor(RoomDef.EAST, 's3r1')
room_s2r8:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s2r8:setMaptile('.', 'floor')
room_s2r8:setMaptile(',', 'concretefloor')

room_s2r8:setFloor([[
................
................
................
................
................
................
................
................
................
................
................
................
................
]])
room_s2r8:setMap([[
################
#              #
#              #
#              #
#              #
#              #
#              #
#              #
#              #
#              #
#              #
#              #
################
]])

room_s2r8:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s2r8:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s2r8:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s2r8:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s2r8
