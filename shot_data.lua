shot_data = {}

function shot_data.spawn(kind, x, y, dx, dy, owner)
  local new_id = idcounter.get_id("shot")

  shots[new_id] = shot:new()
  shots[new_id].id = new_id
  shots[new_id].x = x
  shots[new_id].y = y
  shots[new_id].dx = dx
  shots[new_id].dy = dy
  shots[new_id].owner = owner

  shots[new_id].birth_time = game_time

  for i, v in pairs(shot_data[kind]) do
    shots[new_id][i] = v
  end

  return new_id
end

shot_data["bullet"] =
{
  kind = "bullet", name = "Test Bullet",
  damage = 20,
  sprite = "bullet",
  radius = 8,
  collides_with_map = true,
  collides_with_enemies = true,
  sound = "snapgun",

  collide = function(self, hit, mx, my, mt, nx, ny)
    if hit and hit[1] == "enemy" then
      enemies[hit[2]]:take_damage(self.damage)
    end
    self:die()
  end,
}

return shot_data
