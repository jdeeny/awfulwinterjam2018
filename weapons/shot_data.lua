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
  sprite = "bullet_blue",
  radius = 8,
  collides_with_map = true,
  collides_with_enemies = true,

  collide = function(self, hit, mx, my, mt, nx, ny)
    if hit and hit[1] == "enemy" then
      enemies[hit[2]]:take_damage(self.damage, false, math.atan2(self.dy, self.dx), 3, true)
    end
    for i = 1, 6 do
      angle = math.atan2(ny, nx) + (love.math.random() - 0.5) * math.pi
      speed = 200 + 1800 * love.math.random()
      spark_data.spawn("spark_blue", {r=255, g=255, b=255}, mx, my, speed * math.cos(angle), speed * math.sin(angle))
    end
    for i = 1, 3 do
      angle = math.atan2(ny, nx) + (love.math.random() - 0.5) * math.pi
      speed = 200 + 1000 * love.math.random()
      spark_data.spawn("spark_big_blue", {r=255, g=255, b=255}, mx, my, speed * math.cos(angle), speed * math.sin(angle))
    end

    spark_data.spawn("pow", {r=100, g=220, b=255}, mx, my, 0, 0, love.math.random() * math.pi * 2, 2 * love.math.random(0, 1) - 1, 1)

    self:die()
  end,
}


shot_data["enemybullet"] =
{
  kind = "bullet", name = "Test Bullet",
  damage = 10,
  sprite = "bullet",
  radius = 8,
  collides_with_map = true,
  collides_with_enemies = false,
  collides_with_player = true,

  collide = function(self, hit, mx, my, mt, nx, ny)
    if hit and hit[1] == "player" then
      player:take_damage(self.damage, false, math.atan2(self.dy, self.dx), 3, true)
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

    spark_data.spawn("pow", {r=255, g=230, b=50}, mx, my, 0, 0, love.math.random() * math.pi * 2, 2 * love.math.random(0, 1) - 1, 1)

    self:die()
  end,
}

return shot_data
