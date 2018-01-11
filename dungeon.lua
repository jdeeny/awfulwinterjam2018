local dungeon = class("dungeon")

function dungeon.move_to_room()
  -- unload current map, load new one, place player appropriately, setup fights i guess
  enemies = {}
  enemy_count = 0
  shots = {}

  current_room = room:new()
  current_room:init(20, 15)
  current_room:setup_main()

  -- place on the appropriate side instead
  player.x = 300
  player.y = 300

  enemy_data.spawn("schmuck", 200, 200)
  enemy_data.spawn("schmuck", 300, 100)
end

return dungeon
