local room_s1r1 = RoomDef:new('s1r1')

room_s1r1:setDoor(RoomDef.NORTH, 's1r2a')
room_s1r1:setDoor(RoomDef.EAST, 's1r2b')
room_s1r1:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s1r1:setMaptile('.', 'floor')
room_s1r1:setMaptile(',', 'concretefloor')

room_s1r1:setFloor([[
...................
......,,,,.........
......,,,..........
......,,,..........
......,,,..........
......,,,..........
......,,,..........
...................
...................
...................
...................
...................
...................
]])
room_s1r1:setMap([[
###################
# wwww            #
# ww   w w w   www#
# wwwww w w w  w  #
#  ww  ww  ww   w #
#   wwwwww  wwww  #
# w www w      w  #
# w  wwww         #
# w  w  w w  www  #
# w  w  www    w  #
# wwwwwwwwwww     #
# w      w        #
###################
]])

room_s1r1:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s1r1:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s1r1:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s1r1:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s1r1
