local spark_data = {}

function spark_data.spawn(class, color, x, y, dx, dy, r, sx, sy)
  local new_id = idcounter.get_id("spark")
  sparks[new_id] = spark:new()
  sparks[new_id].id = new_id
  sparks[new_id].color = color
  sparks[new_id].x = x
  sparks[new_id].y = y
  sparks[new_id].dx = dx or 0
  sparks[new_id].dy = dy or 0
  sparks[new_id].birth_time = game_time
  sparks[new_id].r = r or 0
  sparks[new_id].sx = sx or 1
  sparks[new_id].sy = sy or 1

  for i, v in pairs(spark_data[class]) do
    if i == "animation" then
      sparks[new_id][i] = v:clone()
    elseif i == "sprite" and type(v) == "table" then
      sparks[new_id][i] = v[love.math.random(#v)]
    else
      sparks[new_id][i] = v
    end
  end

  if sparks[new_id]["duration_variance"] then
    sparks[new_id].duration = duration.start(sparks[new_id]["duration"] + sparks[new_id]["duration_variance"] * love.math.random())
  else
    sparks[new_id].duration = duration.start(sparks[new_id]["duration"])
  end

  return new_id
end

spark_data["spark"] =
{
  class = "spark",
  sprite = "spark",
  duration = 0.1,
  duration_variance = 0.4,
  sprite_hwidth = 8,
  sprite_hheight = 8,
}

spark_data["spark_big"] =
{
  class = "spark_big",
  sprite = "spark_big",
  duration = 0.1,
  duration_variance = 0.3,
  sprite_hwidth = 32,
  sprite_hheight = 32,
}

spark_data["spark_blue"] =
{
  class = "spark_blue",
  sprite = "spark_blue",
  duration = 0.1,
  duration_variance = 0.4,
  sprite_hwidth = 8,
  sprite_hheight = 8,
}

spark_data["spark_big_blue"] =
{
  class = "spark_big_blue",
  sprite = "spark_big_blue",
  duration = 0.1,
  duration_variance = 0.3,
  sprite_hwidth = 32,
  sprite_hheight = 32,
}

spark_data["pow"] =
{
  class = "pow",
  sprite = "pow",
  animation = animation.pow,
  duration = 0.2,
  sprite_hwidth = 64,
  sprite_hheight = 64,
}

spark_data["muzzle"] =
{
  class = "muzzle",
  sprite = {"muzzle1", "muzzle2", "muzzle3", "muzzle4", "muzzle5"},
  animation = animation.pow,
  duration = 0.2,
  sprite_hwidth = 64,
  sprite_hheight = 64,
}

spark_data["shard"] =
{
  class = "shard",
  sprite = "shard",
  animation = animation.shard,
  duration = 0.4,
  sprite_hwidth = 32,
  sprite_hheight = 8,
}

spark_data["explosion"] =
{
  class = "explosion",
  sprite = "explosion",
  animation = animation.explosion,
  duration = 0.36,
  sprite_hwidth = 128,
  sprite_hheight = 128,
}

return spark_data
