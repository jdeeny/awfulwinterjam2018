doodad_data = {}

function doodad_data.spawn(kind, x, y, dx, dy, radius)
  local new_id = idcounter.get_id("doodad")

  doodads[new_id] = doodad:new()
  doodads[new_id].id = new_id
  doodads[new_id].x = x
  doodads[new_id].y = y
  doodads[new_id].radius = radius

  doodads[new_id].birth_time = game_time

  for i, v in pairs(doodad_data[kind]) do
    doodads[new_id][i] = v
  end

  return new_id
end

doodad_data["exit_east"] =
{
  kind = "exit_east", name = "Exit East",
  sprite = "bullet",
  radius = 8,

  trigger = function(self)
    dungeon.move_to_room()
  end,
}

return doodad_data
