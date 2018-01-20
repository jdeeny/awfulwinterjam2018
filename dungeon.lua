local dungeon = class("dungeon", grid)

local room_kinds = {'start','boss','generic'}

function dungeon:init(w,h,room_files,spawns)
	grid:init(w,h)
	
	self.room_files = {}
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
	end
	
	if spawns then
		self.spawns = spawns
	else
		local n = 1
		self.spawns = {}
		for k in pairs(spawner.wave_data) do
			self.spawns[n] = k
			n = n + 1
		end
	end
end
	

function dungeon:move_to_room(rx, ry, from_dir)
  -- unload current map, load new one, place player appropriately, setup fights i guess
  print("move_to_room")
  enemies = {}
  enemy_value = 0
  shots = {}
  doodads = {}
  sparks = {}
  items = {}
  spawner.reset()
  
  local room_set = self.room_files[self:get_room_kind(rx, ry)]
  local room_index = self[rx][ry].file

  current_level = file_io.parse_room_file(room_set[room_index])
  current_level.exits = self:get_exits(rx, ry)
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

  local selected_wave = self.spawns[love.math.random(#(self.spawns))]
  print("wave", selected_wave) -- DBG
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
