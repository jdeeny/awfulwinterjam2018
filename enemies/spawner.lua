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

spawner.wave_data = {}

spawner.wave_data.test = function()
	spawner.add(5, function() enemy_data.spawn('schmuck', 200, 600) end)
	spawner.add(10, function() enemy_data.spawn('schmuck', 600, 200) end)
	spawner.add(15, function() for i=1, 3 do enemy_data.spawn('schmuck', 300, 300 + 100 * i) end end)
end

return spawner
