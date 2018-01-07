shot_data = {}

function shot_data.spawn(class, x, y, dx, dy, owner)
	local new_id = idcounter.get_id("shot")
	shots[new_id] = shot:new({
		id = new_id,
		dx = dx, dy = dy, owner = owner
	})

	for i, v in pairs(shot_data[class]) do
		shots[new_id][i] = v
	end

	shots[new_id].x, shots[new_id].y = x, y
	shots[new_id].birth_time = game_time

	return new_id
end

shot_data["bullet"] =
{
	class = "bullet", name = "Test Bullet",
	damage = 20,
	sprite = "bullet",
	radius = 8,
	collides_with_map = true,

	collide = function(self, hit, mx, my, mt, nx, ny)
		self:die()
	end,
}

return shot_data
