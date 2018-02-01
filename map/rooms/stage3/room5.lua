local room_s3r5 = RoomDef:new('s3r5')

room_s3r5:setDoor(RoomDef.NORTH, 's1r2a')
room_s3r5:setDoor(RoomDef.EAST, 's1r2b')
room_s3r5:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s3r5:setMaptile('.', 'floor')
room_s3r5:setMaptile(',', 'concretefloor')

room_s3r5:setFloor([[
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
room_s3r5:setMap([[
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

room_s3r5:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s3r5:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s3r5:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s3r5:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s3r5
