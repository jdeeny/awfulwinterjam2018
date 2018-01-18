local dungeon = class("dungeon", grid)

function dungeon.move_to_room(rx, ry, from_dir)
  -- unload current map, load new one, place player appropriately, setup fights i guess
  print("move_to_room")
  enemies = {}
  enemy_value = 0
  shots = {}
  doodads = {}
  sparks = {}
  spawner.reset()

  current_level = file_io.parse_room_file(current_dungeon[rx][ry].file)
  current_level.exits = current_dungeon:get_exits(rx, ry)
  --current_level:prologue()

  player.dungeon_x = rx
  player.dungeon_y = ry
  -- we should only ever come from south or west, but still
  if from_dir == "north" then
    player.x = current_level:pixel_width() / 2
    player.y = 3 * TILESIZE - player.speed / 2
  elseif from_dir == "south" then
    player.x = current_level:pixel_width() / 2
    player.y = current_level:pixel_height() - 3 * TILESIZE + player.speed / 2
  elseif from_dir == "west" then
    player.x = 3 * TILESIZE - player.speed / 2
    player.y = current_level:pixel_height() / 2
  elseif from_dir == "east" then
    player.x = current_level:pixel_width() - 3 * TILESIZE + player.speed / 2
    player.y = current_level:pixel_height() / 2
  else
    love.errhand("bad room from_dir")
  end

  current_level:open_door(from_dir)

  camera.recenter()

  enemy_data.spawn("schmuck", 600, 600)
  enemy_data.spawn("schmuck", 300, 800)

  enemy_data.spawn("fodder", 400, 600)
  enemy_data.spawn("fodder", 200, 600)

  spawner.wave_data.test()
end

function dungeon:setup_main()
  local file_count = #file_io.room_files
  for rx = 1, self.width do
    for ry=1, self.height do
      if rx == 1 and ry == self.height then
        self[rx][ry] = {room_kind = "start", file = love.math.random(file_count)}
        self.start_x = rx
        self.start_y = ry
      elseif rx == self.width and ry == 1 then
        self[rx][ry] = {room_kind = "boss", file = love.math.random(file_count)}
      else
        self[rx][ry] = {room_kind = "generic", file = love.math.random(file_count)}
      end
    end
  end
end

function dungeon:get_exits(rx, ry)
  return {north = self:feature_at(rx, ry - 1) ~= "void", east = self:feature_at(rx + 1, ry) ~= "void"}
end

return dungeon
