enemy_data = {}

function enemy_data.spawn(kind, x, y)
  local new_id = idcounter.get_id("enemy")

  enemies[new_id] = enemy:new()
  enemies[new_id].id = new_id
  enemies[new_id].x = x
  enemies[new_id].y = y

  enemies[new_id].birth_time = game_time
  enemies[new_id].wake_time = 0

  for i, v in pairs(enemy_data[kind]) do
    enemies[new_id][i] = v
  end

  enemies[new_id].hp = enemies[new_id].max_hp
  enemy_count = enemy_count + 1

  return new_id
end

enemy_data["schmuck"] =
{
  kind = "schmuck", name = "Test Loser",
  sprite = "dude",
  max_hp = 60,
  speed = 200,
  radius = 40,
}

return enemy_data