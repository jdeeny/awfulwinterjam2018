local dungeon = class("dungeon", grid)

local room_kinds = {'start','boss','generic'}

function dungeon:initialize()--w,h,room_files,spawns)

	self.room_files = {}
	self.spawns = {}
	-- fill in any empty sections
	for k,t in pairs(room_kinds) do
		if room_files and room_files[t] then
			self.room_files[t] = room_files[t]
		else
			self.room_files[t] = {}
			for i in ipairs(file_io.room_files) do
				table.insert(self.room_files[t], i)
			end
		end

		if spawns and spawns[t] then
			self.spawns[t] = spawns[t]
		else
			self.spawns[t] = {}
			for k,v in pairs(spawner.wave_data) do
				table.insert(self.spawns[t],k)
			end
		end
	end

end


function dungeon:move_to_room(rx, ry, from_dir)
  -- unload current map, load new one, place player appropriately, setup fights i guess
  print("move_to_room")
	player.init()
  enemies = {}
  enemy_value = 0
  shots = {}
  doodads = {}
  sparks = {}
  if not items then items = {} end
  spawner.reset()

  local room_set = self.room_files[self:get_room_kind(rx, ry)]
  local room_index = self[rx][ry].file

	print("BEFORE PARSE")
  current_level = file_io.parse_room_file(room_set[room_index])
  print("MOVE TO ROOM")
  current_level:updatewatertiles()
  print("MOVEDONE")
  current_level.exits = current_dungeon:get_exits(rx, ry)
  current_level.kind = current_dungeon:get_room_kind(rx,ry)
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


  local spawn_set = self.spawns[self:get_room_kind(rx, ry)]
  -- DBG
  for k,v in pairs(spawn_set) do
	  print("spawns",k,v)
  end
  -- DBG
  local selected_wave = spawn_set[love.math.random(#(spawn_set))] -- random pick from list
  spawner.wave_data[selected_wave]()
end

function dungeon:setup_main()
  for rx = 1, self.width do
    for ry=1, self.height do
      if rx == 1 and ry == self.height then
        self[rx][ry] = {room_kind = "start", file = love.math.random(#(self.room_files['start'])) }
        self.start_x = rx
        self.start_y = ry
      elseif rx == self.width and ry == 1 then
        self[rx][ry] = {room_kind = "boss", file = love.math.random(#(self.room_files['boss'])) }
      else
        self[rx][ry] = {room_kind = "generic", file = love.math.random(#(self.room_files['generic'])) }
      end
    end
  end
end

function dungeon:get_exits(rx, ry)
  return {north = self:feature_at(rx, ry - 1) ~= "void", east = self:feature_at(rx + 1, ry) ~= "void"}
end

function dungeon:get_room_kind(rx,ry)
	return self[rx][ry].room_kind
end

return dungeon
