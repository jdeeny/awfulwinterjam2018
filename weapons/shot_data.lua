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

  collide = function(self, hit, mx, my, mt, nx, ny)
    if hit and hit[1] == "enemy" then
      camera.bump(10)
      angle = math.atan2(self.dy,  self.dx)
      enemies[hit[2]]:be_stunned(0.3, 400 * math.cos(angle), 400 * math.sin(angle))
      enemies[hit[2]]:take_damage(self.damage)
    end
    for i = 1, 6 do
      angle = math.atan2(ny, nx) + (love.math.random() - 0.5) * math.pi
      speed = 200 + 1800 * love.math.random()
      spark_data.spawn("spark", {r=255, g=255, b=255}, mx, my, speed * math.cos(angle), speed * math.sin(angle))
    end
    for i = 1, 3 do
      angle = math.atan2(ny, nx) + (love.math.random() - 0.5) * math.pi
      speed = 200 + 1000 * love.math.random()
      spark_data.spawn("spark_big", {r=255, g=255, b=255}, mx, my, speed * math.cos(angle), speed * math.sin(angle))
    end
    self:die()
  end,
}

return shot_data