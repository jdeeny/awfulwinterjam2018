local room_s3r4 = RoomDef:new('s3r4')

room_s3r4:setDoor(RoomDef.NORTH, nil)
room_s3r4:setDoor(RoomDef.EAST, nil)
room_s3r4:setDoor(RoomDef.SOUTH, 's3r5')


-- Setup some alternate floor tiles
room_s3r4:setMaptile('.', 'floor')
room_s3r4:setMaptile(',', 'concretefloor')

room_s3r4:setFloor([[
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
room_s3r4:setMap([[
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

room_s3r4:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s3r4:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s3r4:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s3r4:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s3r4
