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

function spawner.spawn_from_north_door(kind, parameter)
	current_level:open_door("north", true, 1)
	local kind = kind
	if not enemy_data[kind] then kind = 'rifledude' end
	id = enemy_data.spawn(kind, current_level:pixel_width() / 2, TILESIZE * 2.5 - enemy_data[kind].speed * 2, parameter)
	enemies[id]:start_force_move(1, 0, enemies[id].speed)
end

function spawner.spawn_from_east_door(kind, parameter)
	current_level:open_door("east", true, 1)
	local kind = kind
	if not enemy_data[kind] then kind = 'rifledude' end
	id = enemy_data.spawn(kind, current_level:pixel_width() - TILESIZE * 2.5 + enemy_data[kind].speed * 2, current_level:pixel_height() / 2, parameter)
	enemies[id]:start_force_move(1, -enemies[id].speed, 0)
end

function spawner.spawn_from_south_door(kind, parameter)
	current_level:open_door("south", true, 1)
	local kind = kind
	if not enemy_data[kind] then kind = 'rifledude' end
	id = enemy_data.spawn(kind, current_level:pixel_width() / 2, current_level:pixel_height() - TILESIZE * 2.5 + enemy_data[kind].speed * 2, parameter)
	enemies[id]:start_force_move(1, 0, -enemies[id].speed)
end

function spawner.spawn_from_west_door(kind, parameter)
	current_level:open_door("west", true, 1)
	local kind = kind
	if not enemy_data[kind] then kind = 'rifledude' end
	id = enemy_data.spawn(kind, TILESIZE * 2.5 - enemy_data[kind].speed * 2, current_level:pixel_height() / 2, parameter)
	enemies[id]:start_force_move(1, enemies[id].speed, 0)
end

function spawner.spawn_from_teleporter(kind, number, parameter)
	if #spawner.teleporters > 0 then
		local kind = kind
		if not enemy_data[kind] then kind = 'rifledude' end
		n = love.math.random(#spawner.teleporters)
		id = enemy_data.spawn(kind, (spawner.teleporters[n].x + 0.5) * TILESIZE, (spawner.teleporters[n].y + 0.5) * TILESIZE, parameter)
		enemies[id]:start_force_move(1, 0, 0)
	end
end

spawner.wave_data = {}

spawner.wave_data.first = function()
	spawner.add(2,
		function()
			local angle = math.pi * 0.25
			delay.start(4, function() spawner.spawn_from_north_door('rifledude', angle) end)
			for i = 1, 5 do
				delay.start(0.6 * i, function() spawner.spawn_from_north_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * 1.4
			for i = 1, 5 do
				delay.start(0.1 + 0.6 * i, function() spawner.spawn_from_south_door('remotedude_red', angle2) end)
			end
		end)
	spawner.add(5,
		function()
			local angle = math.pi * 1.7
			for i = 1, 6 do
				delay.start(0.6 * i, function() spawner.spawn_from_east_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * 0.9
			for i = 1, 6 do
				delay.start(0.1 + 0.6 * i, function() spawner.spawn_from_west_door('remotedude_red', angle2) end)
			end
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.easy_1 = function()
	spawner.add(2,
		function()
			local angle = math.pi * 0.7
			for i = 1, 6 do
				delay.start(0.3 * i, function() spawner.spawn_from_north_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * 1.1
			for i = 1, 6 do
				delay.start(0.1 + 0.3 * i, function() spawner.spawn_from_south_door('remotedude_red', angle2) end)
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_north_door('rifledude')
			spawner.spawn_from_east_door('bursterdude')
			spawner.spawn_from_east_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_north_door('rifledude')
			spawner.spawn_from_east_door('rifledude') end)
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.easy_2 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_east_door('canbot')
			spawner.spawn_from_north_door('canbot')
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_west_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_west_door('rifledude') end)
			spawner.spawn_from_east_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_east_door('rifledude') end)
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.easy_3 = function()
	spawner.add(2,
		function()
			local angle = math.pi * 0.75
			for i = 1, 10 do
				delay.start(0.3 * i, function() spawner.spawn_from_east_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * -0.25
			for i = 1, 10 do
				delay.start(0.1 + 0.3 * i, function() spawner.spawn_from_west_door('remotedude_red', angle2) end)
			end

			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_north_door('bursterdude')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_south_door('bursterdude')
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_north_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_west_door('rifledude') end)
			spawner.spawn_from_east_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_south_door('rifledude') end)
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.easy_4 = function()
	spawner.add(2,
		function()
			local angle = math.pi * -0.2
			for i = 1, 16 do
				delay.start(0.3 * i, function() spawner.spawn_from_east_door('remotedude_red', angle) end)
			end
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_north_door('bursterdude')
			spawner.spawn_from_north_door('bursterdude')

			spawner.spawn_from_south_door('rifledude')
			spawner.spawn_from_south_door('rifledude')
			spawner.spawn_from_south_door('rifledude')
			spawner.spawn_from_east_door('bursterdude')

		end)
	spawner.add(5,
		function()
			spawner.spawn_from_north_door('sniperdude')
			spawner.spawn_from_south_door('sniperdude')
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.easy_5 = function()
	spawner.add(2,
		function()
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_east_door('rifledude') end)
				delay.start(0.1 + 0.5 * i, function() spawner.spawn_from_west_door('rifledude') end)
				delay.start(0.2 + 0.5 * i, function() spawner.spawn_from_north_door('rifledude') end)
				delay.start(0.3 + 0.5 * i, function() spawner.spawn_from_south_door('rifledude') end)
			end
			delay.start(2,
					function()
						spawner.complete = true
						spawner.test_completion()
					end)
		end)
end

spawner.wave_data.easy_6 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_north_door('rocketguy')
			for i = 1, 16 do
				delay.start(0.1 + 0.3 * i, function() spawner.spawn_from_south_door('remotedude_blue', angle2) end)
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_west_door('rocketguy')
			spawner.spawn_from_east_door('rocketguy')
			spawner.spawn_from_north_door('rifledude')
			spawner.spawn_from_north_door('bursterdude')
			spawner.spawn_from_south_door('rifledude')
		end)
end

------

spawner.wave_data.stage1boss = function()

	spawner.add(2,
		function()
			spawner.spawn_from_north_door('superlump')
			local angle = math.pi * 1.4
			for i = 1, 12 do
				delay.start(0.3 * i, function() spawner.spawn_from_south_door('remotedude_red', angle) end)
			delay.start(0.3 * i, function() spawner.spawn_from_north_door('remotedude_red', angle) end)
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_west_door('rifledude')
			for i = 1, 4 do
				delay.start(0.5 * i, function() spawner.spawn_from_east_door('canbot') end)
			end
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

------

spawner.wave_data.second = function()
	spawner.add(2,
		function()
			for i = 1, 7 do
				delay.start(0.6 * i, function() spawner.spawn_from_north_door('rifledude') end)
			end
			for i = 1, 7 do
				delay.start(0.1 + 0.6 * i, function() spawner.spawn_from_south_door('rifledude') end)
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_south_door('sniperdude')
			spawner.spawn_from_north_door('sniperdude')
			spawner.spawn_from_west_door('sniperdude')
			spawner.spawn_from_east_door('sniperdude')
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.remotes = function()
	spawner.add(2,
	function()
		for i = 1,16 do
			delay.start(0.3 * i, function () spawner.spawn_from_north_door('remotedude_red') end)
		end
	end)
	spawner.add(4,
	function()
		for i = 1,12 do
			delay.start(0.5 * i, function () spawner.spawn_from_west_door('remotedude_blue') end)
		end

	end)
	spawner.add(12,
	function()
		for i = 1,24 do
			delay.start(0.3 * i, function () spawner.spawn_from_east_door('remotedude_green') end)
		end
		delay.start(2,
			function()
				spawner.complete = true
				spawner.test_completion()
			end)
	end)
end

spawner.wave_data.medium_1 = function()
	spawner.add(2,
		function()
			local angle = math.pi * 0.5
			for i = 1, 12 do
				delay.start(0.3 * i, function() spawner.spawn_from_north_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * 1.1
			for i = 1, 12 do
				delay.start(0.1 + 0.3 * i, function() spawner.spawn_from_south_door('remotedude_red', angle2) end)
			end
		end)
	spawner.add(5,
		function()
			for i = 1, 3 do
				spawner.spawn_from_south_door('rifledude')
				spawner.spawn_from_north_door('rifledude')
				spawner.spawn_from_south_door('rifledude')
				spawner.spawn_from_north_door('rifledude')
			end
			spawner.spawn_from_west_door('sniper')
			spawner.spawn_from_east_door('sniper')
		end)
	spawner.add(10,
		function()
			for i = 1, 3 do
				spawner.spawn_from_west_door('lumpgoon')
				spawner.spawn_from_west_door('lumpgoon')
				spawner.spawn_from_east_door('lumpgoon')
				spawner.spawn_from_east_door('lumpgoon')
			end
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.medium_2 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_east_door('canbot')
			spawner.spawn_from_north_door('canbot')
			spawner.spawn_from_west_door('canbot')
			spawner.spawn_from_south_door('canbot')
			spawner.spawn_from_east_door('canbot')
			spawner.spawn_from_north_door('canbot')
			spawner.spawn_from_west_door('canbot')
			spawner.spawn_from_south_door('canbot')
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_west_door('rocketdude')
			spawner.spawn_from_east_door('rocketdude')
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.medium_3 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_south_door('lumpgoon')
		end)
	spawner.add(5,
		function()
			local angle = math.pi * -1.2
			for i = 1, 8 do
				delay.start(0.3 * i, function() spawner.spawn_from_east_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * 0.6
			for i = 1, 8 do
				delay.start(0.1 + 0.3 * i, function() spawner.spawn_from_west_door('remotedude_red', angle2) end)
			end
			spawner.spawn_from_east_door('sniperdude')
		end)
	spawner.add(10,
		function()
			local angle = math.pi * 0.75
			for i = 1, 12 do
				delay.start(0.3 * i, function() spawner.spawn_from_east_door('remotedude_red', angle) end)
			end
			local angle2 = math.pi * -0.25
			for i = 1, 12 do
				delay.start(0.1 + 0.3 * i, function() spawner.spawn_from_west_door('remotedude_red', angle2) end)
			end
			spawner.spawn_from_north_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_west_door('rifledude') end)
			spawner.spawn_from_east_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_south_door('rifledude') end)
			delay.start(5,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.medium_4 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_west_door('sniperdude')
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_west_door('rifledude')
			spawner.spawn_from_south_door('sniperdude')
			spawner.spawn_from_south_door('rifledude')
			spawner.spawn_from_south_door('rifledude')
			spawner.spawn_from_west_door('rifledude')
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_north_door('rocketguy')
			spawner.spawn_from_south_door('homingrocketguy')
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

spawner.wave_data.medium_5 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_south_door('homingrocketguy')
			for i = 1, 9 do
				delay.start(0.5 * i, function()
					spawner.spawn_from_east_door('rifledude')
				end)
			end
		end)
	spawner.add(5,
	function()
		spawner.spawn_from_west_door('canbot')
		spawner.spawn_from_east_door('canbot')
		for i = 1, 5 do
			delay.start(0.5 * i, function()
				spawner.spawn_from_west_door('rifledude')
				spawner.spawn_from_east_door('rifledude')
			end)
		end
		delay.start(2,
			function()
				spawner.complete = true
				spawner.test_completion()
			end)
	end
	)
end

spawner.wave_data.medium_6 = function()
	spawner.add(2,
		function()
			spawner.spawn_from_north_door('sniperdude')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_north_door('lumpgoon')
			spawner.spawn_from_south_door('lumpgoon')
			spawner.spawn_from_north_door('lumpgoon')
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_east_door('rocketguy')
		end)
	spawner.add(10,
		function()
			spawner.spawn_from_north_door('rifledude')
			spawner.spawn_from_north_door('rifledude')
			spawner.spawn_from_north_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_west_door('rifledude') end)
			spawner.spawn_from_east_door('rifledude')
			spawner.spawn_from_east_door('rifledude')
			spawner.spawn_from_east_door('rifledude')
			delay.start(0.5, function() spawner.spawn_from_south_door('rifledude') end)
			delay.start(5,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

------

spawner.wave_data.stage2boss = function()
	spawner.add(2,
		function()
			for i = 1, 5 do
				spawner.spawn_from_north_door('canbot')
				spawner.spawn_from_south_door('canbot')
				spawner.spawn_from_east_door('canbot')
				spawner.spawn_from_west_door('canbot')
			end
		end)
	spawner.add(5,
		function()
			spawner.spawn_from_east_door('sniperdude')
			spawner.spawn_from_west_door('sniperdude')
			spawner.spawn_from_east_door('sniperdude')
			spawner.spawn_from_west_door('sniperdude')
		end)
	spawner.add(10,
		function()
			for i = 1, 5 do
				spawner.spawn_from_north_door('rifledude')
				spawner.spawn_from_south_door('rifledude')
				spawner.spawn_from_east_door('canbot')
				spawner.spawn_from_west_door('canbot')
			end
			delay.start(5,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
end

------


spawner.wave_data.stage3boss = function()

	spawner.add(3,
		function()
			spawner.spawn_from_north_door('edison')
			--for i = 1, 16 do
			--	delay.start(0.5 * i, function() spawner.spawn_from_east_door('canbot') end)
			--end
			--for i = 1,16 do
			--	delay.start(0.5 * i, function() spawner.spawn_from_west_door('canbot') end)
			--end
			delay.start(2,
				function()
					spawner.complete = true
					spawner.test_completion()
				end)
		end)
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
			for i = 1, 5 do
				delay.start(0.5 * i, function() spawner.spawn_from_east_door('lumpgoon') end)
			end
		end)
	spawner.add(8,
		function()
			spawner.spawn_from_west_door('lumpgoon')
			for i = 1, 2 do
				delay.start(i - 0.5, function() spawner.spawn_from_west_door('canbot') end)
			end
			for i = 1, 2 do
				delay.start(i , function() spawner.spawn_from_west_door('lumpgoon') end)
			end
		end)
	spawner.add(11,
		function()
			spawner.spawn_from_south_door('canbot')
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
