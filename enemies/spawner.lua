local spawner = { events = {}, wave_count = 0 }

function spawner.reset()
	spawner.events = {}
	spawner.wave_count = 0
end

function spawner.add(threshold, f)
	spawner.events[threshold] = f
	spawner.wave_count = spawner.wave_count + 1
end

local score
function spawner.process()
	-- spawning is delayed if enemies are alive
	score = game_time - enemy_value
	for j,z in pairs(spawner.events) do
		if score >= j then
			z()
			spawner.events[j] = nil
			spawner.wave_count = spawner.wave_count - 1
		end
	end
end

function spawner.spawn_from_north_door(kind)
	id = enemy_data.spawn(kind, current_room:pixel_width() / 2, TILESIZE * 3 - enemy_data[kind].speed)
	enemies[id]:start_force_move(1, 0, enemies[id].speed)
end

function spawner.spawn_from_east_door(kind)
	id = enemy_data.spawn(kind, current_room:pixel_width() - TILESIZE * 3 + enemy_data[kind].speed, current_room:pixel_height() / 2)
	enemies[id]:start_force_move(1, -enemies[id].speed, 0)
end

spawner.wave_data = {}

spawner.wave_data.test = function()
	spawner.add(2,
		function()
			spawner.spawn_from_north_door('schmuck')
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_north_door('schmuck') end)
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_east_door('fodder')
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_east_door('fodder') end)
			end
		end)
end

return spawner
