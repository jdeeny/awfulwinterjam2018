local room_s1r3a = RoomDef:new('s1r3a')

room_s1r3a:setDoor(RoomDef.NORTH, nil)
room_s1r3a:setDoor(RoomDef.EAST, 's1r4a')
room_s1r3a:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s1r3a:setMaptile('.', 'floor')
room_s1r3a:setMaptile(',', 'concretefloor')

room_s1r3a:setFloor([[
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
room_s1r3a:setMap([[
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

room_s1r3a:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s1r3a:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s1r3a:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s1r3a:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s1r3a
