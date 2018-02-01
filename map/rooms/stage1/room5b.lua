local room_s1r5b = RoomDef:new('s1r5b')

room_s1r5b:setDoor(RoomDef.NORTH, nil)
room_s1r5b:setDoor(RoomDef.EAST, 's1r6')
room_s1r5b:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s1r5b:setMaptile('.', 'floor')
room_s1r5b:setMaptile(',', 'concretefloor')

room_s1r5b:setFloor([[
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
room_s1r5b:setMap([[
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

room_s1r5b:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s1r5b:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s1r5b:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s1r5b:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s1r5b
