local room_s1r5a = RoomDef:new('s1r5a')

room_s1r5a:setDoor(RoomDef.NORTH, 's1r5b')
room_s1r5a:setDoor(RoomDef.EAST, nil)
room_s1r5a:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s1r5a:setMaptile('.', 'floor')
room_s1r5a:setMaptile(',', 'concretefloor')

room_s1r5a:setFloor([[
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
room_s1r5a:setMap([[
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

room_s1r5a:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s1r5a:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s1r5a:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s1r5a:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s1r5a
