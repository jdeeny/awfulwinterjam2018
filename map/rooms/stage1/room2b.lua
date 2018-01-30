local room_s1r2b = RoomDef:new('s1r2b')

room_s1r2b:setDoor(RoomDef.NORTH, 's1r3a')
room_s1r2b:setDoor(RoomDef.EAST, 's1r3b')
room_s1r2b:setDoor(RoomDef.SOUTH, nil)


-- Setup some alternate floor tiles
room_s1r2b:setMaptile('.', 'floor')
room_s1r2b:setMaptile(',', 'floor')
--[[room_s1r2b:setFloor([[
........,,.........
........,,.........
........,,.........
,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,
........,,.........
........,,.........
........,,......
]]--)
room_s1r2b:setMap([[
###################
#  ww      WW     #
#  www     WW  #  #
#   ww         #  #
#   www        #  #
#   wwww   WW  #  #
#    www   WW  ####
################
]])

room_s1r2b:addSpawn{ id='1N', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=NORTH}
room_s1r2b:addSpawn{ id='1S', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=SOUTH}
room_s1r2b:addSpawn{ id='1E', start=0.5, mob='remotedude_red', count=5, spawn_kind='stream', door=EAST}
room_s1r2b:addSpawn{ id='2', start=3.5, mob='rifledude', door=EAST}
return room_s1r2b
