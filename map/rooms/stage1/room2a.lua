local room_s1r2a = RoomDef:new('s1r2a')

room_s1r2a:setDoor(RoomDef.NORTH, nil)
room_s1r2a:setDoor(RoomDef.EAST, 's1r3a')
room_s1r2a:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s1r2a:setMaptile('.', 'floor')
room_s1r2a:setMaptile(',', 'concretefloor')

room_s1r2a:setFloor([[
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
room_s1r2a:setMap([[
################
#  ww          #
#  www         #
#   ww         #
#   www        #
#    ww        #
#     www      #
#   WWwww      #
#   WWwwwWWWWWW#
#   WW  ww  www#
#   WW   wwww  #
#   WW         #
################
]])

room_s1r2a:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='line', door=RoomDef.NORTH}
room_s1r2a:addSpawn{ id='1Nb', start=3.5, mob='rifledude', count=1, door=RoomDef.NORTH}
room_s1r2a:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='line', door=RoomDef.SOUTH}
room_s1r2a:addSpawn{ id='1Sb', start=3.5, mob='rifledude', count=1, door=RoomDef.SOUTH}
room_s1r2a:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='line', door=RoomDef.EAST}
room_s1r2a:addSpawn{ id='2', start=3.5, mob='rifledude', count=4, door=RoomDef.EAST, complete=true}
return room_s1r2a
