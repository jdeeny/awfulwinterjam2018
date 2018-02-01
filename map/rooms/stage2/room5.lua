local room_s2r5 = RoomDef:new('s2r5')

room_s2r5:setDoor(RoomDef.NORTH, 's1r6')
room_s2r5:setDoor(RoomDef.EAST, nil)
room_s2r5:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s2r5:setMaptile('.', 'floor')
room_s2r5:setMaptile(',', 'concretefloor')

room_s2r5:setFloor([[
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
room_s2r5:setMap([[
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

room_s2r5:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s2r5:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s2r5:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s2r5:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s2r5
