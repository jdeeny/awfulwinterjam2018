local explosions = {}

function explosions.dynamite(x, y)
  ExplosionParticles:new(x, y, 2, 2, .2, 1.0)
  for i = 1, 12 + love.math.random(8) do
    angle = love.math.random() * 2 * math.pi
    speed = 800 + 4000 * love.math.random()
    spark_data.spawn("spark", {r=255, g=120, b=50},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 12 + love.math.random(8) do
    angle = love.math.random() * 2 * math.pi
    speed = 600 + 3000 * love.math.random()
    spark_data.spawn("spark_big", {r=255, g=120, b=50},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 200 + 2200 * love.math.random()
    spark_data.spawn("shard", {r=255, g=230, b=100},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 200 + 2200 * love.math.random()
    spark_data.spawn("shard", {r=255, g=120, b=50},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 100 + 1200 * love.math.random()
    spark_data.spawn("pow", {r=255, g=230, b=100},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 100 + 1200 * love.math.random()
    spark_data.spawn("pow", {r=255, g=120, b=50},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end

  spark_data.spawn("explosion", {r=255, g=230, b=100},
    x, y, 0, 0)

  camera.shake(12, 0.6)
end

function explosions.blood(x, y)
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 200 + 2200 * love.math.random()
    spark_data.spawn("shard", {r=180, g=0, b=30},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 200 + 2200 * love.math.random()
    spark_data.spawn("shard", {r=200, g=0, b=0},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 100 + 1200 * love.math.random()
    spark_data.spawn("pow", {r=180, g=0, b=30},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 4 + love.math.random(4) do
    angle = love.math.random() * 2 * math.pi
    speed = 100 + 1200 * love.math.random()
    spark_data.spawn("pow", {r=200, g=0, b=0},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end

  camera.shake(8, 0.6)
end

function explosions.rubble(x, y)
  ExplosionParticles:new(x, y, 1, 1, .2, 0.5)
  -- for i = 1, 4 + love.math.random(4) do
  --   angle = love.math.random() * 2 * math.pi
  --   speed = 200 + 1200 * love.math.random()
  --   spark_data.spawn("shard", {r=100, g=100, b=100},
  --     x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  -- end
  -- for i = 1, 4 + love.math.random(4) do
  --   angle = love.math.random() * 2 * math.pi
  --   speed = 200 + 1200 * love.math.random()
  --   spark_data.spawn("shard", {r=180, g=180, b=180},
  --     x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  -- end
  for i = 1, 1 + love.math.random(3) do
    angle = love.math.random() * 2 * math.pi
    speed = 100 + 800 * love.math.random()
    spark_data.spawn("pow", {r=100, g=100, b=100},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end
  for i = 1, 1 + love.math.random(3) do
    angle = love.math.random() * 2 * math.pi
    speed = 100 + 800 * love.math.random()
    spark_data.spawn("pow", {r=180, g=180, b=180},
      x + 32 * math.cos(angle), y + 32 * math.sin(angle), speed * math.cos(angle), speed * math.sin(angle), angle)
  end

  camera.shake(8, 0.6)
end

function explosions.damage_radius(damage, force, x, y, radius)
  local distance = math.sqrt((x - player.x) * (x - player.x) + (y - player.y) * (y - player.y))
  if distance < radius then
    player:take_damage(damage, false,
      math.atan2(player.y - y, player.x - x), force, true)
  elseif distance < radius * 2 then
    player:be_knocked_back(0.1 * force,
      60 * force * math.cos(math.atan2(player.y - y, player.x - x)),
      60 * force * math.cos(math.atan2(player.y - y, player.x - x)))
  end

  for _,z in pairs(enemies) do
    distance = math.sqrt((x - z.x) * (x - z.x) + (y - z.y) * (y - z.y))
    if distance < radius then
      z:take_damage(damage, false,
        math.atan2(z.y - y, z.x - x), force , true)
    elseif distance < radius * 2 then
      z:be_knocked_back(0.1 * force,
      60 * force * math.cos(math.atan2(z.y - y, z.x - x)),
      60 * force * math.cos(math.atan2(z.y - y, z.x - x)))
    end
  end

  -- now hit terrain
  local gx = current_level:pos_to_grid(x)
  local gy = current_level:pos_to_grid(y)
  for tgx = gx - 4, gx + 4 do
    for tgy = gy - 4, gy + 4 do
      if current_level.tiles[tgx] and current_level.tiles[tgx][tgy] then
        if math.sqrt((x - tgx * TILESIZE - 32) * (x - tgx * TILESIZE - 32) + (y - tgy * TILESIZE - 32) * (y - tgy * TILESIZE - 32)) < radius then
          current_level.tiles[tgx][tgy]:takeDamage(12000) -- :black101:
        end
      end
    end
  end
end

return explosions
