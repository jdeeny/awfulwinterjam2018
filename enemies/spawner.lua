local spawner = { events = {}, wave_count = 0, teleporters = {} }

function spawner.reset()
	spawner.events = {}
	spawner.wave_count = 0
	spawner.teleporters = {}
	spawner.score = 0
	spawner.start_time = game_time
	spawner.complete = false
end

function spawner.add(threshold, f)
	spawner.events[threshold] = f
	spawner.wave_count = spawner.wave_count + 1
end

function spawner.process()
	-- spawning is delayed if enemies are alive
	spawner.score = game_time - enemy_value - spawner.start_time
	for j,z in pairs(spawner.events) do
		if spawner.score >= j then
			z()
			spawner.events[j] = nil
			spawner.wave_count = spawner.wave_count - 1
		end
	end
end

function spawner.test_completion()
	if enemy_value < 0.01 and spawner.complete then
		delay.start(1, function() current_level:coda() end)
	end
end

function spawner.spawn_from_north_door(kind)
	current_level:open_door("north", true, 1)
	id = enemy_data.spawn(kind, current_level:pixel_width() / 2, TILESIZE * 2.5 - enemy_data[kind].speed * 2)
	enemies[id]:start_force_move(1, 0, enemies[id].speed)
end

function spawner.spawn_from_east_door(kind)
	current_level:open_door("east", true, 1)
	id = enemy_data.spawn(kind, current_level:pixel_width() - TILESIZE * 2.5 + enemy_data[kind].speed * 2, current_level:pixel_height() / 2)
	enemies[id]:start_force_move(1, -enemies[id].speed, 0)
end

function spawner.spawn_from_south_door(kind)
	current_level:open_door("south", true, 1)
	id = enemy_data.spawn(kind, current_level:pixel_width() / 2, current_level:pixel_height() - TILESIZE * 2.5 + enemy_data[kind].speed * 2)
	enemies[id]:start_force_move(1, 0, -enemies[id].speed)
end

function spawner.spawn_from_west_door(kind)
	current_level:open_door("west", true, 1)
	id = enemy_data.spawn(kind, TILESIZE * 2.5 - enemy_data[kind].speed * 2, current_level:pixel_height() / 2)
	enemies[id]:start_force_move(1, enemies[id].speed, 0)
end

function spawner.spawn_from_teleporter(kind, number)
	if #spawner.teleporters > 0 then
		n = love.math.random(#spawner.teleporters)
		id = enemy_data.spawn(kind, (spawner.teleporters[n].x + 0.5) * TILESIZE, (spawner.teleporters[n].y + 0.5) * TILESIZE)
		enemies[id]:start_force_move(1, 0, 0)
	end
end

spawner.wave_data = {}

spawner.wave_data.ez_lvl = function()
	spawner.add(2,
		function()
			spawner.spawn_from_north_door('schmuck')
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_south_door('remotedude_red') end)
			end
		end)
	spawner.add(5,
	function()
		spawner.spawn_from_west_door('rifledude')
		for i = 1, 4 do
			delay.start(0.5 * i, function() spawner.spawn_from_east_door('schmuck') end)
		end
		delay.start(2,
			function()
				spawner.complete = true
				spawner.test_completion()
			end)
	end
	)
end

spawner.wave_data.test = function()
	spawner.add(2,
		function()
			spawner.spawn_from_north_door('remotedude_red')
			spawner.spawn_from_south_door('remotedude_blue')
			spawner.spawn_from_east_door('remotedude_green')
			spawner.spawn_from_north_door('rifledude')
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_north_door('rifledude') end)
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_east_door('lumpgoon')
			for i = 1, 40 do
				delay.start(0.5 * i, function() spawner.spawn_from_east_door('lumpgoon') end)
			end
		end)
	spawner.add(8,
		function()
			spawner.spawn_from_west_door('lumpgoon')
			for i = 1, 2 do
				delay.start(i - 0.5, function() spawner.spawn_from_west_door('schmuck') end)
			end
			for i = 1, 2 do
				delay.start(i , function() spawner.spawn_from_west_door('lumpgoon') end)
			end
		end)
	spawner.add(11,
		function()
			spawner.spawn_from_south_door('schmuck')
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_south_door('lumpgoon') end)
			end
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end



return spawner
