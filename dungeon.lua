local dungeon = class("dungeon", grid)

local room_kinds = {'start','boss','generic'}

function dungeon:initialize(w,h,room_layout)
	grid:initialize(w,h)
	self.room_layout = room_layout
end

function dungeon:move_to_room(rx, ry, from_dir)
  -- unload current map, load new one, place player appropriately, setup fights i guess
  --player.init()
  enemies = {}
  enemy_value = 0
  shots = {}
  doodads = {}
  sparks = {}
  --if not items then items = {} end
  items = {}
  spawner.reset()

	print("level setup")
	--local room = RoomDef.rooms['s1r1']
  local room = self[rx][ry].room
  current_level = room:parse()--file_io.parse_room_file(room_set[room_index])
	print("done")
  current_level:setup_outer_walls()
  current_level:updatewatertiles()
  current_level:updatewalltiles()

  current_level.exits = self:get_exits(rx, ry)
  
  --print("rx,ry, dung_dim",rx,ry,self.width,self.height) -- DBG
  --print("exits:",self:get_exits(rx,ry).north,self:get_exits(rx,ry).east) -- DBG
  current_level.kind = self:get_room_kind(rx,ry)

  --current_level:prologue()

  player.dungeon_x = rx
  player.dungeon_y = ry
  -- we should only ever come from south or west, but still
  if from_dir == "north" then
    player.x = current_level:pixel_width() / 2
    player.y = 2.5 * TILESIZE - player.speed / 2
  elseif from_dir == "south" then
    player.x = current_level:pixel_width() / 2
    player.y = current_level:pixel_height() - 2.5 * TILESIZE + player.speed / 2
  elseif from_dir == "west" then
    player.x = 2.5 * TILESIZE - player.speed / 2
    player.y = current_level:pixel_height() / 2
  elseif from_dir == "east" then
    player.x = current_level:pixel_width() - 2.5 * TILESIZE + player.speed / 2
    player.y = current_level:pixel_height() / 2
  else
    love.errhand("bad room from_dir")
  end

  current_level:open_door(from_dir, true, 1)

  camera.recenter()
  
  room:launchSpawn()	-- launch spawns as defined in room
end

function dungeon:setup_main()
  for rx=1, self.width do
    for ry=1, self.height do
		print("room at",rx,ry) -- DBG
		print("room is ",self.room_layout[ry][rx]) -- DBG
		self[rx][ry].room = RoomDef.rooms[self.room_layout[ry][rx]]
      if rx == 1 and ry == self.height then
        self.start_x = rx
        self.start_y = ry
		self[rx][ry].kind = 'start'
      elseif rx == self.width and ry == 1 then
		self[rx][ry].kind = 'boss'
     else
         self[rx][ry].kind = 'generic'
      end
    end
  end
end

function dungeon:get_exits(rx, ry)
  return {north = self:feature_at(rx, ry - 1) ~= "void", east = self:feature_at(rx + 1, ry) ~= "void"}
end

function dungeon:get_room_kind(rx,ry)
  return self[rx][ry].kind
end

return dungeon
