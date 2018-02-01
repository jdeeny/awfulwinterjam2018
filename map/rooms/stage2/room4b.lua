local room_s2r4b = RoomDef:new('s2r4b')

room_s2r4b:setDoor(RoomDef.NORTH, 's1r5')
room_s2r4b:setDoor(RoomDef.EAST, 's1r5')
room_s2r4b:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s2r4b:setMaptile('.', 'floor')
room_s2r4b:setMaptile(',', 'concretefloor')

room_s2r4b:setFloor([[
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
room_s2r4b:setMap([[
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

room_s2r4b:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s2r4b:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s2r4b:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s2r4b:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s2r4b
