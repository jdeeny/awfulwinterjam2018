local room_s1r1 = RoomDef:new('s1r1')

room_s1r1:setDoor(RoomDef.NORTH, 's1r2a')
room_s1r1:setDoor(RoomDef.EAST, 's1r2b')
room_s1r1:setDoor(RoomDef.SOUTH, nil)

-- Setup some alternate floor tiles
room_s1r1:setMaptile('.', 'floor')
room_s1r1:setMaptile(',', 'floor_concrete')
room_s1r1:setMaptile('T', 'wall_southface_teak')

room_s1r1:setFloor([[
................
................
................
................
,,,,,...........
,,,,,...........
,,,,,...........
,,,,,...........
,,,,,...........
,,,,,...........
,,,,,...........
,,,,,...........
,,,,,...........
]])
room_s1r1:setMap([[
################
#              #
#        WWWWWW#
#        WWWWWW#
#TTTT          #
#   T          #
#   T          #
#   T          #
#   T      WWWW#
#   T      WWWW#
#              #
#              #
################
]])

room_s1r1:addSpawn{ id='1E', start=1.5, mob='remotedude_red', count=15, spawn_kind='line', door=RoomDef.EAST}
room_s1r1:addSpawn{ id='1N', start=2.5, mob='remotedude_red', count=10, spawn_kind='line', door=RoomDef.NORTH}
room_s1r1:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='line', door=RoomDef.SOUTH}
room_s1r1:addSpawn{ id='2', start=2.5, mob='rifledude', door=RoomDef.EAST, complete=true }
return room_s1r1
