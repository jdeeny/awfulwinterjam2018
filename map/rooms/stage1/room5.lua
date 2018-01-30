local room_test1 = RoomDef:new()
room_test1:setMaptile('.', 'floor2')
room_test1:setMaptile(',', 'floor3')
room_test1:setFloor([[
........,,.........
........,,.........
........,,.........
,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,
........,,.........
........,,.........
........,,......

]])
room_test1:setMap([[
###################
#  ww      WW     #
#  www     WW  #  #
#   ww         #  #
#   www        #  #
#   wwww   WW  #  #
#    www   WW  ####
################
]])

room_test1:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_test1:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_test1:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_test1:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_test1
