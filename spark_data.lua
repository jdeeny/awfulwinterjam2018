local spark_data = {}

function spark_data.spawn(class, color, x, y, dx, dy)
  local new_id = idcounter.get_id("spark")
  sparks[new_id] = spark:new()
  sparks[new_id].id = new_id
  sparks[new_id].color = color
  sparks[new_id].x = x
  sparks[new_id].y = y
  sparks[new_id].dx = dx
  sparks[new_id].dy = dy
  sparks[new_id].birth_time = game_time

  for i, v in pairs(spark_data[class]) do
    sparks[new_id][i] = v
  end

  if sparks[new_id]["duration_variance"] then
    sparks[new_id]["duration"] = sparks[new_id]["duration"] + sparks[new_id]["duration_variance"] * love.math.random()
  end

  return new_id
end

spark_data["spark"] =
{
  class = "spark",
  sprite = "spark",
  duration = 0.05,
  duration_variance = 0.3,
  radius = 4,
}

spark_data["spark_big"] =
{
  class = "spark_big",
  sprite = "spark_big",
  duration = 0.1,
  duration_variance = 0.3,
  radius = 8,
}

return spark_data
