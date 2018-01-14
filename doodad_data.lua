doodad_data = {}

function doodad_data.spawn(kind, x, y)
  local new_id = idcounter.get_id("doodad")

  doodads[new_id] = doodad:new()
  doodads[new_id].id = new_id
  doodads[new_id].x = x
  doodads[new_id].y = y

  doodads[new_id].birth_time = game_time

  for i, v in pairs(doodad_data[kind]) do
    doodads[new_id][i] = v
  end

  return new_id
end

doodad_data["exit_east"] =
{
  kind = "exit_east", name = "Exit East",
  sprite = "exit_east",
  radius = 64,

  trigger = function(self)
    if not fade.state then
      player:start_force_move(10, player.speed, 0)
      fade.start_fade("fadeout", 0.5, false,
        function()
          dungeon.move_to_room(player.dungeon_x + 1, player.dungeon_y, "west")
          fade.start_fade("fadein", 0.75, false, function() player:end_force_move() end)
        end)
    end
  end,
}

doodad_data["exit_north"] =
{
  kind = "exit_north", name = "Exit North",
  sprite = "exit_north",
  radius = 64,

  trigger = function(self)
    if not fade.state then
      player:start_force_move(10, 0, -(player.speed))
      fade.start_fade("fadeout", 0.5, false,
        function()
          dungeon.move_to_room(player.dungeon_x, player.dungeon_y - 1, "south")
          fade.start_fade("fadein", 0.75, false, function() player:end_force_move() end)
        end)
    end
  end,
}

return doodad_data
