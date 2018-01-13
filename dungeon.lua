local dungeon = class("dungeon", grid)

function dungeon.move_to_room(rx, ry, from_dir)
  -- unload current map, load new one, place player appropriately, setup fights i guess
  enemies = {}
  enemy_count = 0
  shots = {}
  doodads = {}

  current_room = room:new()
  current_room:init(20, 16)
  current_room.exits = current_dungeon:get_exits(rx, ry)
  current_room:setup_main()

  player.dungeon_x = rx
  player.dungeon_y = ry
  -- we should only ever come from south or west, but still
  if from_dir == "north" then
    player.x = current_room:pixel_width() / 2
    player.y = 3 * TILESIZE - player.speed / 2
  elseif from_dir == "south" then
    player.x = current_room:pixel_width() / 2
    player.y = current_room:pixel_height() - 3 * TILESIZE + player.speed / 2
  elseif from_dir == "west" then
    player.x = 3 * TILESIZE - player.speed / 2
    player.y = current_room:pixel_height() / 2
  elseif from_dir == "east" then
    player.x = current_room:pixel_width() - 3 * TILESIZE + player.speed / 2
    player.y = current_room:pixel_height() / 2
  else
    love.errhand("bad room from_dir")
  end

  camera.recenter()

  enemy_data.spawn("schmuck", 600, 600)
  enemy_data.spawn("schmuck", 300, 800)

  enemy_data.spawn("fodder", 400, 600)
  enemy_data.spawn("fodder", 200, 600)
end

function dungeon:setup_main()
  for rx = 1, self.width do
    for ry=1, self.height do
      if rx == 1 and ry == self.height then
        self[rx][ry] = {room = "start"}
        self.start_x = rx
        self.start_y = ry
      elseif rx == self.width and ry == 1 then
        self[rx][ry] = {room = "boss"}
      else
        self[rx][ry] = {room = "generic"}
      end
    end
  end
end

function dungeon:get_exits(rx, ry)
  return {north = self:feature_at(rx, ry - 1) ~= "void", east = self:feature_at(rx + 1, ry) ~= "void"}
end

return dungeon
